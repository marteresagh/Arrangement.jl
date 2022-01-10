using Common
using Visualization
using Arrangement
# V in 2D e EV sono gli spigoli
function find_cycles(V,EV)
    triangles = Common.constrained_triangulation2D(V,EV)
    edges_of_triangles = convert(Array{Array{Int64,1},1}, collect(Set(Common.CAT(map(Common.FV2EV,triangles)))))
    edges_of_triangles = unique(sort.(edges_of_triangles))
    boundary_edges = sort.(EV)
    cells = clustering_cells(V,triangles,edges_of_triangles, boundary_edges)
    FVs = map(x->triangles[x],cells)
    return boundary_edges,FVs
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



V = [
        1.0 0.0 9.0 4.0 2.0 7.0 11.0 16.0 15.0 25.0 9.0 14.0 12.0 19.0 23.0 27.0 29.0 33.0 33.0 37.0 33.0 41.0 41.0 35.0 39.0 38.0 32.0 28.0 25.0 26.0 23.0
        17.0 10.0 10.0 12.0 11.0 16.0 18.0 10.0 16.0 17.0 5.0 5.0 11.0 4.0 6.0 3.0 14.0 17.0 10.0 18.0 4.0 4.0 10.0 5.0 5.0 9.0 11.0 11.0 14.0 12.0 13.0
]
EV = [
        [1, 2],
        [2, 3],
        # [3, 4],
        # [4, 5],
        [3, 6],
        [1, 6],
        # [6, 7],
        # [7, 9],
        [8, 9],
        [8, 10],
        [9, 10],
        [11, 12],
        [12, 13],
        [11, 13],
        [8, 19],
        [19, 18],
        [17, 18],
        [10, 17],
        # [10, 29],
        [29, 30],
        [30, 31],
        [29, 31],
        [17, 28],
        [27, 28],
        [17, 27],
        [20, 19],
        [18, 20],
        # [14, 15],
        # [15, 16],
        [19, 21],
        [21, 22],
        [22, 23],
        [23, 19],
        # [21, 24],
        [24, 25],
        [25, 26],
        [24, 26],
]


Visualization.VIEW([ Visualization.GLLines(V,EV) ])

FVs = find_cycles(V,EV)
Visualization.VIEW(Visualization.GLExplode(V,FVs,1.2,1.2,1.2,99,1));

V = [1 6. 14 11  3 20  19 24 27 28;
     6 1  7  11 11  1  11  1  5  1]

EV = [[1,2],[2,3],[3,4],[4,5],[1,5],[2,6],[6,7],[7,4],[8,10],[8,9],[9,10]]

Visualization.VIEW([ Visualization.GLLines(V,EV) ])

FVs = find_cycles(V,EV)
Visualization.VIEW(Visualization.GLExplode(V,FVs,1.2,1.2,1.2,99,1));


######################### intersezioni facce nel 3D

V = [
    0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.5 0.5 0.5 0.5 3.0 3.0 3.0 3.0
    0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.5 0.5 1.5 1.5 0.5 0.5 1.5 1.5
    0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 1.5 0.5 1.5 0.5 1.5 0.5 1.5
]

VV = [[i] for i in 1:size(V,2)]

EV = [
    [1, 2],
    [3, 4],
    [5, 6],
    [7, 8],
    [1, 3],
    [2, 4],
    [5, 7],
    [6, 8],
    [1, 5],
    [2, 6],
    [3, 7],
    [4, 8],
    [9, 10],
    [11, 12],
    [13, 14],
    [15, 16],
    [9, 11],
    [10, 12],
    [13, 15],
    [14, 16],
    [9, 13],
    [10, 14],
    [11, 15],
    [12, 16],
]

FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [1, 2, 5, 6],
    [3, 4, 7, 8],
    [1, 3, 5, 7],
    [2, 4, 6, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16],
    [9, 10, 13, 14],
    [11, 12, 15, 16],
    [9, 11, 13, 15],
    [10, 12, 14, 16],
]

Visualization.VIEW([
    Visualization.GLFrame,
    Visualization.GLLines(V,EV),
]);


function arrangement3D_prova(V,EV,FV)
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
    EV_final,FVs_final = find_cycles(newV,newEV)
    @show EV_final
    @show FVs_final
    V_final = Common.apply_matrix(Common.inv(permutedims(M)),Common.add_zeta_coordinates(newV,0.0))

    rV = permutedims(V_final)
    rEV = Arrangement.lar2cop(EV_final)
    rFE = Common.spzeros(Int8, length(FVs_final), length(EV_final))
    for i in 1:length(FVs_final)
        edges_boundary = sort.(Common.get_boundary_edges(V_final,FVs_final[i]))
        @show edges_boundary
        idx_edges = []
        for j in 1:length(edges_boundary)
            indices = findall(x->x==edges_boundary[j],EV_final)
            union!(idx_edges,indices)
        end
        @show idx_edges
        for t in idx_edges
            @show rFE
            @show i
            @show t
            rFE[i,t]= 1
        end
    end

    return rV,rEV,rFE
    # return V_final,EV_final,FV_final
end



rV, rcopEV, rcopFE = arrangement3D_prova(V,EV,FV)
T = permutedims(rV)
ET = Arrangement.cop2lar(rcopEV)
T, ETs, FTs = get_topology3D(rV, rcopEV, rcopFE)

Visualization.VIEW([ Visualization.GLLines(T,ET) ])


Visualization.VIEW(Visualization.GLExplode(T,FTs,1.2,1.2,1.2,99,1));
FVs = [[[2, 4, 3], [3, 1, 2]]]

FV_final = Common.get_boundary_edges(V,FVs[1])

union!(FV_final...)
