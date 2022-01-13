# V in 2D e EV sono gli spigoli
function find_cycles(V,EV)
    bicon = Arrangement.biconnected_components(Arrangement.lar2cop(EV))
    all_edges_used = union(bicon...)
    copEV = Arrangement.lar2cop(EV)
    a = [i for i in 1:size(V,2) if sum(copEV[all_edges_used,:], dims = 1)[1,i]!=0]
    newcopEV = copEV[all_edges_used,a]
    points = V[:,a]
    new_EV = Arrangement.cop2lar(newcopEV)
    boundary_edges = sort.(new_EV)

    triangles = Common.constrained_triangulation2D(points,boundary_edges)
    edges_of_triangles = convert(Array{Array{Int64,1},1}, collect(Set(Common.CAT(map(Common.FV2EV,triangles)))))
    edges_of_triangles = unique(sort.(edges_of_triangles))
    cells = clustering_cells(points,triangles,edges_of_triangles, boundary_edges)
    FVs = map(x->triangles[x],cells)
    return points,boundary_edges,FVs
end

function clustering_cells(V,triangles, edges_of_triangles, boundary_edges)

    copFE = Arrangement.u_coboundary_1(triangles,edges_of_triangles)
    ## grafo adiacenze

    regions = Vector{Int}[]
    visited_triangles = zeros(length(triangles))

    ## main loop
    idx_seed = get_seed_cell(visited_triangles)
    while idx_seed != -1
        region = []
        visited_triangles[idx_seed] = 1
        seeds_face = [copy(idx_seed)]
        push!(region,copy(idx_seed))

        while !isempty(seeds_face)
            seed_face = pop!(seeds_face)
            # println("$seed_face in $seeds_face")
            # NN = list_adj[seed_face] #neighbour_of(seed_face)
            NN = neigbour_faces(copFE, edges_of_triangles, boundary_edges, seed_face)
            for vicino in NN
                # println("sto visitando il vicino $vicino ")
                if visited_triangles[vicino] != 1
                    push!(seeds_face,vicino)
                    push!(region,vicino)
                    visited_triangles[vicino] = 1
                end
            end
            # println("chi sono i seeds ora? $seeds_face")
        end
        push!(regions,region)
        idx_seed = get_seed_cell(visited_triangles)
        # println("$(sum(visited_triangles)) visited of $(length(triangles))")
    end

    return regions
end

function get_seed_cell(visited_triangles)
    s = -1 # se ritorna questo esce dal loop
    for i = 1:length(visited_triangles)
        if visited_triangles[i] == 0 # se non è mai stata visitata
            s = i
        end
    end
    return s
end

function neigbour_faces(copFE, edges_of_triangles, boundary_edges, seed_face)
    NN = Int[]
    c_ld = Common.spzeros(Int8, copFE.m)
    c_ld[seed_face] = 1
    #bordo del triangolo

    bordo = copFE'*c_ld
    for tau in bordo.nzind
        #cobordo del primo
        if !(edges_of_triangles[tau] in boundary_edges)
            cobordo = copFE'[tau,:]

            union!(NN, setdiff(cobordo.nzind,seed_face))
        end
    end
    return NN
end

function my_arrangement_3D(V,EV,FV)
    W = permutedims(V)
    cop_EV = Arrangement.coboundary_0(EV)
    cop_FE = Arrangement.coboundary_1(V, FV, EV)
    sp_idx = Arrangement.spatial_index(W, cop_EV, cop_FE)


    fs_num = size(cop_FE, 1)

    rV = Common.Points(undef, 0, 3)
    rEV = Common.spzeros(Int8, 0, 0)
    rFE = Common.spzeros(Int8, 0, 0)

    depot_V = Array{Array{Float64,2},1}(undef, fs_num)
    depot_EV = Array{Common.ChainOp,1}(undef, fs_num)
    depot_FE = Array{Common.ChainOp,1}(undef, fs_num)

    for sigma in 1:fs_num

        nV, nEV, nFE = sigma_intersection(W,cop_EV,cop_FE,sigma,sp_idx)
        depot_V[sigma] = nV
        depot_EV[sigma] = nEV
        depot_FE[sigma] = nFE

    end
    rV = vcat(depot_V...)
    rEV = Common.blockdiag(depot_EV...)
    rFE = Common.blockdiag(depot_FE...)

    rV, rcopEV, rcopFE = Arrangement.merge_vertices(rV, rEV, rFE)
    return rV, rcopEV, rcopFE
    return T,ET,FTs
end


### da eliminare i vertici e gli spigoli che non creano celle
function sigma_intersection(W,cop_EV,cop_FE,sigma,sp_idx)
    # 2D transformation of sigma face
    vs_num = size(W, 1)
    sigmavs = (abs.(cop_FE[sigma:sigma, :])*abs.(cop_EV))[1, :].nzind
    sV = W[sigmavs, :]
    sEV = cop_EV[cop_FE[sigma, :].nzind, sigmavs]
    M = Arrangement.submanifold_mapping(sV)
    tV = ([W ones(vs_num)]*M)[:, 1:3]  # folle convertire *tutti* i vertici
    sV = tV[sigmavs, :]

    # sigma face intersection with faces in sp_idx[sigma]
    for i in sp_idx[sigma]
        tmpV, tmpEV = Arrangement.face_int(tV, cop_EV, cop_FE[i, :])
        sV, sEV = Arrangement.skel_merge(sV, sEV, tmpV, tmpEV)
    end

    sV,sEV = Arrangement.merge_vertices2!(sV,sEV)
    T = permutedims(sV)[1:2,:]
    ET = Arrangement.cop2lar(sEV)
    newV,newEV = Arrangement.get_planar_graph(T, ET)
    V_final2D, EV_final, FVs_final = find_cycles(newV,newEV)
    V_final = Common.apply_matrix(Common.inv(permutedims(M)),Common.add_zeta_coordinates(V_final2D,0.0))

    rV = permutedims(V_final)
    rEV = Arrangement.lar2cop(EV_final)
    rFE = Common.spzeros(Int8, length(FVs_final), length(EV_final))
    for i in 1:length(FVs_final)
        edges_boundary = sort.(Common.get_boundary_edges(V_final,FVs_final[i]))
        idx_edges = []
        for j in 1:length(edges_boundary)
            indices = findall(x->x==edges_boundary[j],EV_final)
            union!(idx_edges,indices)
        end
        for t in idx_edges
            rFE[i,t]= 1
        end
    end

    return rV,rEV,rFE
    # return V_final,EV_final,FV_final
end

function get_topology3D(rV, rcopEV, rcopFE)
    points = permutedims(rV)
    all_edges = Arrangement.cop2lar(rcopEV)
    edges_for_faces = Arrangement.FV2EVs(rcopEV, rcopFE) # polygonal face fragments

    triangles_for_faces = []
    for i = 1:length(edges_for_faces)
        EV = edges_for_faces[i]
        idx_points = union(EV...)
        points_on_face = points[:,idx_points]
        plane = Common.Plane(points_on_face)
        T = Common.apply_matrix(plane.matrix, points_on_face)[1:2,:]
        ET = map.(x->findfirst(j->j==x,idx_points),EV)
        triangles_in_cells = Common.constrained_triangulation_with_holes2D(T,ET)

        push!(triangles_for_faces, map.(x->idx_points[x],triangles_in_cells))
    end

    return points, all_edges, edges_for_faces, triangles_for_faces
end
