function cycle_basis(V,copEV,bicon_comps)
    # V_by_row
    # 1. calcola i cicli minimi per ogni componente biconnessa
    # calcola tutti i cicli minimi + la cella esterna perhce ogni spigolo viene visitato al massimo 2 volte
    # 2. calcola il ciclo esterno per ogni componente biconnessa

    n_of_comps = length(bicon_comps)
    shells = Array{Lar.Chain,1}(undef, n_of_comps)
    boundaries = Array{Lar.ChainOp,1}(undef, n_of_comps)
    EVs = Array{Lar.ChainOp,1}(undef, n_of_comps)
    # for each component
    for p = 1:n_of_comps
        ev = copEV[sort(bicon_comps[p]), :]

        # computation of 2-cells
        fe = minimal_2cycles(V, ev)

        # exterior cycle
        shell_num = get_external_cycle(V, ev, fe)

        # decompose each fe (co-boundary local to component)
        EVs[p] = ev
        tokeep = setdiff(1:fe.m, shell_num)
        boundaries[p] = fe[tokeep, :]
        shells[p] = fe[shell_num, :]
    end
    return EVs, shells, boundaries
end


function minimal_2cycles(V::Lar.Points, EV::Lar.ChainOp)

    function edge_angle(v::Int, e::Int)
        edge = EV[e, :]
        v2 = setdiff(edge.nzind, [v])[1]
        x, y = V[v2, :] - V[v, :]
        return atan(y, x)
    end


    for i = 1:EV.m
        j = min(EV[i, :].nzind...)
        EV[i, j] = -1
    end
    VE = convert(Lar.ChainOp, Lar.SparseArrays.transpose(EV))
    EF = minimal_cycles(edge_angle)(V, VE)

    return convert(Lar.ChainOp, Lar.SparseArrays.transpose(EF))
end

## calcola i cicli minimi e la cella esterna
function minimal_cycles(angles_fn::Function, verbose = true)

    function _minimal_cycles(V::Lar.Points, ld_bounds::Lar.ChainOp)  # (V , VE)

        function get_seed_cell()
            s = -1 # se ritorna questo esce dal loop
            for i = 1:ld_cellsnum
                if count_marks[i] == 0 # se non è mai stata visitata
                    return i
                elseif count_marks[i] == 1 && s < 0 # se è stata visitata
                    s = i
                end
            end
            return s
        end

        function nextprev(lld::Int64, ld::Int64, norp)
            # println("============= Start NEXTPREV function =========")
            as = angles[lld]
            #ne = findfirst(as, ld)  (findfirst(isequal(v), A), 0)[1]
            ne = (findfirst(isequal(ld), as), 0)[1] # ne e mi da l'indice del pivot
            # ld è il pivot da dove provengo
            # @show as
            # @show ne
            # @show norp
            while true
                ne += norp # se norp positivo next or se norp negativo previous
                # @show ne
                if ne > length(as)
                    ne = 1
                elseif ne < 1
                    ne = length(as)
                end

                if count_marks[as[ne]] < 2
                    break
                end
            end
            for k = 1:length(count_marks)
                if count_marks[k] > 2
                    error("TGW is looping")
                end
            end

            # @show as[ne]

            # println("============= END NEXTPREV function =========")
            as[ne]
        end

        lld_cellsnum, ld_cellsnum = size(ld_bounds)
        # lld sono i vertici
        # ld sono gli spigoli
        count_marks = zeros(Int64, ld_cellsnum) # quante volte ho visitato lo spigolo (fino a due volte posso visitarlo)
        dir_marks = zeros(Int64, ld_cellsnum) # direzione di visita degli spigoli
        d_bounds = Lar.spzeros(Int64, ld_cellsnum, 0) # cicli trovati inizialmente zero
        angles = Array{Array{Int64,1},1}(undef, lld_cellsnum)

        # calcola tutti gli angoli in precedenza,
        # mi salvo l'ordinamento in senso antiorario degli spigoli
        # relativi ad ogni vertice
        for lld = 1:lld_cellsnum
            as = []
            for ld in ld_bounds[lld, :].nzind
                push!(as, (ld, angles_fn(lld, ld)))
            end
            sort!(as, lt = (a, b) -> a[2] < b[2])
            as = map(a -> a[1], as)
            angles[lld] = as
        end

        println("angoli: ", angles)

        # println("count_marks: $(Vector(count_marks))")
        sigma = get_seed_cell()
        println("spigolo seed: ", sigma)
        while (sigma) > 0
            println("")
            println("########################################  ricerca del nuovo ciclo iniziata")
            if verbose
                print(Int(floor(50 * sum(count_marks) / ld_cellsnum)), "%\r") # <<<<<<<<<<<<<<<<<<<
            end

            c_ld = Lar.spzeros(Int8, ld_cellsnum)
            if count_marks[sigma] == 0
                c_ld[sigma] = 1
            else
                c_ld[sigma] = -dir_marks[sigma]
            end

            # println("c_ld: $(Vector(c_ld))")

            c_lld = ld_bounds * c_ld # calcola il boundary della cella, essendo uno spigolo sono gli estremi

            while c_lld.nzind != [] #processa finchè non esistono più punti sul boundary
                # when looping, loops here !! perchè non si svuota mai
                corolla = Lar.spzeros(Int64, ld_cellsnum)
                #corolla = zeros(Int64, ld_cellsnum)

                println("bordo della catena", c_lld)
                println("")
                for tau in c_lld.nzind
                    println("ciclo for: tau $tau")
                    # tau è il vertice
                    # pivot è lo spigolo
                    b_ld = ld_bounds[tau, :] # per ogni tau calcola il cobordo (quindi gli spigoli adiacenti)
                    ############### ERRORE nel LOOP
                    # l'esempio con il loop va in loop perchè il pivot scelto è sbagliato ,
                    # prende il 2 invece di prendere il 3 ma giustamente non può sapere chi è
                    # perchè l'intersezione ha due valori ma lui prende sempre il primo
                    ###############
                    # @show intersect(c_ld.nzind, b_ld.nzind)
                    pivot = intersect(c_ld.nzind, b_ld.nzind)[1] # il pivot è da dove provengo

                    # se tau > 0 cerco il next
                    # se tau < 0 cerco il prev
                    adj = nextprev(tau, pivot, sign(-c_lld[tau]))
                    corolla[adj] = c_ld[pivot]
                    if b_ld[adj] == b_ld[pivot]
                        corolla[adj] *= -1
                    end

                    println("corolla: $(Vector(corolla)), pivot $pivot, adj $adj")
                end

                c_ld += corolla
                # println("c_ld: $(Vector(c_ld))")
                c_lld = ld_bounds * c_ld # calcolo di nuovo il bordo della catena costruita
                # @show Vector(corolla)
                println("cicli trovati $(d_bounds)")

            end

            map(s -> count_marks[s] += 1, c_ld.nzind)
            # println("count_marks: $(Vector(count_marks))")
            for k = 1:length(count_marks)
                if count_marks[k] > 2
                    error("TGW is looping")
                end
            end

            map(s -> dir_marks[s] = c_ld[s], c_ld.nzind)
            # println("dir_marks: $(Vector(dir_marks))")
            d_bounds = [d_bounds c_ld] # aggiungi una nuova colonna alla lista dei cicli trovati

            println("")
            sigma = get_seed_cell()
            println("spigolo seed: ", sigma)

        end
        return d_bounds
    end

    return _minimal_cycles
end


# in base all'area identifica quale sia la cella esterna
function get_external_cycle(V::Lar.Points, EV::Lar.ChainOp, FE::Lar.ChainOp)
    FV = abs.(FE) * EV
    vs = Lar.sparsevec(mapslices(sum, abs.(EV), dims = 1)').nzind
    minv_x1 = maxv_x1 = minv_x2 = maxv_x2 = pop!(vs)
    for i in vs
        if V[i, 1] > V[maxv_x1, 1]
            maxv_x1 = i
        elseif V[i, 1] < V[minv_x1, 1]
            minv_x1 = i
        end
        if V[i, 2] > V[maxv_x2, 2]
            maxv_x2 = i
        elseif V[i, 2] < V[minv_x2, 2]
            minv_x2 = i
        end
    end


    cells = intersect(
        FV[:, minv_x1].nzind,
        FV[:, maxv_x1].nzind,
        FV[:, minv_x2].nzind,
        FV[:, maxv_x2].nzind,
    )

    if length(cells) == 1
        return cells[1]
    else
        for c in cells
            if Lar.face_area(V, EV, FE[c, :]) < 0
                return c
            end
        end
    end
end
