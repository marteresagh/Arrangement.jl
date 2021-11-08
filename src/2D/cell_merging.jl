"""
Return matrix map of edges and faces.
"""
function cell_merging(
    containment_graph::Lar.ChainOp,
    V::Lar.Points,
    EVs,
    boundaries,
    shells,
    shell_bboxes,
)

    # V_by_row
    # EVs: vettore di copev delle componenti
    # boundaries: vettore con cicli in matrice per ongi componente
    function bboxes(V::Lar.Points, indexes::Lar.ChainOp)
        boxes = Array{Tuple{Any,Any}}(undef, indexes.n)
        for i = 1:indexes.n
            v_inds = indexes[:, i].nzind
            boxes[i] = Lar.bbox(V[v_inds, :])
        end
        boxes
    end
    # initialization

    sums = Array{Tuple{Int,Int,Int}}(undef, 0)
    # assembling child components with father components
    for father = 1:containment_graph.n
        if sum(containment_graph[:, father]) > 0
            father_bboxes =
                bboxes(V, abs.(EVs[father]') * abs.(boundaries[father]'))
            for child = 1:containment_graph.n
                if containment_graph[child, father] > 0
                    child_bbox = shell_bboxes[child]
                    for b = 1:length(father_bboxes)
                        if Lar.bbox_contains(father_bboxes[b], child_bbox)
                            push!(sums, (father, b, child)) # father: componente, b: quale ciclo di father contiene, child: figlio contenuto nel ciclo
                            break
                        end
                    end
                end
            end
        end
    end

    # offset assembly initialization
    EV = vcat(EVs...)
    edgenum = size(EV, 1)
    facenum = sum(map(x -> size(x, 1), boundaries))
    FE = Lar.spzeros(Int8, facenum, edgenum)
    shells2 = Lar.spzeros(Int8, length(shells), edgenum)
    r_offsets = [1]
    c_offset = 1
    # submatrices construction
    for i = 1:containment_graph.n
        min_row = r_offsets[end]
        max_row = r_offsets[end] + size(boundaries[i], 1) - 1
        min_col = c_offset
        max_col = c_offset + size(boundaries[i], 2) - 1
        FE[min_row:max_row, min_col:max_col] = boundaries[i]
        shells2[i, min_col:max_col] = shells[i]
        push!(r_offsets, max_row + 1)
        c_offset = max_col + 1
    end

    # offsetting assembly of component submatrices
    for (f, r, c) in sums
        FE[r_offsets[f]+r-1, :] += shells2[c, :]
    end

    return EV, FE
end
