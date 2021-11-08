"""
	frag_face(V, EV, FE, sp_idx, sigma)

`sigma` face fragmentation against faces in `sp_idx[sigma]`
"""
function frag_face(V, EV, FE, sp_idx, sigma)

    vs_num = size(V, 1)

    # 2D transformation of sigma face
    sigmavs = (abs.(FE[sigma:sigma, :])*abs.(EV))[1, :].nzind
    sV = V[sigmavs, :]
    sEV = EV[FE[sigma, :].nzind, sigmavs]
    M = Lar.Arrangement.submanifold_mapping(sV)
    tV = ([V ones(vs_num)]*M)[:, 1:3]  # folle convertire *tutti* i vertici
    sV = tV[sigmavs, :]
    # sigma face intersection with faces in sp_idx[sigma]
    for i in sp_idx[sigma]
        tmpV, tmpEV = Lar.Arrangement.face_int(tV, EV, FE[i, :])
        sV, sEV
        sV, sEV = Lar.skel_merge(sV, sEV, tmpV, tmpEV)
    end

    # computation of 2D arrangement of sigma face
    sV = sV[:, 1:2]
    nV, nEV, nFE = TGW.planar_arrangement(
        sV,
        sEV;
        sigma = Lar.sparsevec(ones(Int8, length(sigmavs))),
    )
    if nV == nothing ## not possible !! ... (each original face maps to its decomposition)
        return [], spzeros(Int8, 0, 0), spzeros(Int8, 0, 0)
    end
    nvsize = size(nV, 1)
    nV = [nV zeros(nvsize) ones(nvsize)] * inv(M)[:, 1:3] ## ????

    return nV, nEV, nFE
end

function merge_vertices(
    V::Lar.Points,
    EV::Lar.ChainOp,
    FE::Lar.ChainOp,
    err = 1e-4,
)
    vertsnum = size(V, 1)
    edgenum = size(EV, 1)
    facenum = size(FE, 1)
    newverts = zeros(Int, vertsnum)
    # KDTree constructor needs an explicit array of Float64
    V = Array{Float64,2}(V)
    W = convert(Lar.Points, Lar.LinearAlgebra.transpose(V))
    kdtree = Lar.KDTree(W)
    # remove vertices congruent to a single representative
    todelete = []
    i = 1
    for vi = 1:vertsnum
        if !(vi in todelete)
            nearvs = Lar.inrange(kdtree, V[vi, :], err)
            newverts[nearvs] .= i
            nearvs = setdiff(nearvs, vi)
            todelete = union(todelete, nearvs)
            i = i + 1
        end
    end
    nV = V[setdiff(collect(1:vertsnum), todelete), :]
    # V[30,:] = V[26,:] #<<<<<<<<<<<<<<<<<< TEST

    # translate edges to take congruence into account
    edges = Array{Tuple{Int,Int},1}(undef, edgenum)
    oedges = Array{Tuple{Int,Int},1}(undef, edgenum)
    for ei = 1:edgenum
        v1, v2 = EV[ei, :].nzind
        edges[ei] = Tuple{Int,Int}(sort([newverts[v1], newverts[v2]]))
        oedges[ei] = Tuple{Int,Int}(sort([v1, v2]))
    end
    nedges = union(edges)
    # remove edges of zero length
    nedges = filter(t -> t[1] != t[2], nedges)
    nedgenum = length(nedges)
    nEV = Lar.spzeros(Int8, nedgenum, size(nV, 1))

    etuple2idx = Dict{Tuple{Int,Int},Int}()
    for ei = 1:nedgenum
        begin
            nEV[ei, collect(nedges[ei])] .= 1
            nEV
        end
        etuple2idx[nedges[ei]] = ei
    end
    for e = 1:nedgenum
        v1, v2 = Lar.findnz(nEV[e, :])[1]
        nEV[e, v1] = -1
        nEV[e, v2] = 1
    end

    # compute new faces to take congruence into account
    faces = [
        [
            map(
                x -> newverts[x],
                FE[fi, ei] > 0 ? oedges[ei] : reverse(oedges[ei]),
            ) for ei in FE[fi, :].nzind
        ] for fi = 1:facenum
    ]


    visited = []
    function filter_fn(face)

        verts = []
        map(e -> verts = union(verts, collect(e)), face)
        verts = Set(verts)

        if !(verts in visited)
            push!(visited, verts)
            return true
        end
        return false
    end

    nfaces = filter(filter_fn, faces)

    nfacenum = length(nfaces)
    nFE = Lar.spzeros(Int8, nfacenum, size(nEV, 1))

    for fi = 1:nfacenum
        for edge in nfaces[fi]
            ei = etuple2idx[Tuple{Int,Int}(sort(collect(edge)))]
            nFE[fi, ei] = sign(edge[2] - edge[1])
        end
    end

    return Lar.Points(nV), nEV, nFE
end



function get_model_intersected(V, EV, FE)
    fs_num = size(FE, 1)
    sp_idx = Lar.Arrangement.spatial_index(V, EV, FE)

    rV = Lar.Points(undef, 0, 3)
    rEV = Lar.SparseArrays.spzeros(Int8, 0, 0)
    rFE = Lar.SparseArrays.spzeros(Int8, 0, 0)

    depot_V = Array{Array{Float64,2},1}(undef, fs_num)
    depot_EV = Array{Lar.ChainOp,1}(undef, fs_num)
    depot_FE = Array{Lar.ChainOp,1}(undef, fs_num)
    for sigma = 1:fs_num
        print(sigma, "/", fs_num, "\r")
        nV, nEV, nFE = frag_face(V, EV, FE, sp_idx, sigma)
        depot_V[sigma] = nV
        depot_EV[sigma] = nEV
        depot_FE[sigma] = nFE
    end
    rV = vcat(depot_V...)
    rEV = Lar.SparseArrays.blockdiag(depot_EV...)
    rFE = Lar.SparseArrays.blockdiag(depot_FE...)

    rV, rcopEV, rcopFE = merge_vertices(rV, rEV, rFE)
    return rV, rcopEV, rcopFE
end


function model_intersection(V, EV, FV)

    get_centroid(points::Lar.Points) = (sum(points, dims = 2)/size(points, 2))[:, 1]

    cop_EV = Lar.coboundary_0(EV)
    cop_FE = Lar.coboundary_1(V, FV, EV)
    W = permutedims(V)

    rV, rcopEV, rcopFE = get_model_intersected(W, cop_EV, cop_FE)
    V = permutedims(rV)
    EV = Lar.cop2lar(rcopEV)
    FE = Lar.cop2lar(rcopFE)


    ETs = Lar.FV2EVs(rcopEV, rcopFE) # polygonal face fragments

    FTs = Vector{Vector{Int64}}[]

    for i = 1:length(ETs)
        ET = ETs[i]
        idxs_verts = union(ET...)
        points_face = V[:,idxs_verts]
        EV_mapped = [map(x->findall(j->j==x, idxs_verts)[1], ET[i]) for i in 1:length(ET)]


        baricentro = get_centroid(points_face)
        normal = Lar.cross(
                baricentro - points_face[:, 1],
                points_face[:, 2] - points_face[:, 1],
            )

        centroid = points_face[:, 1]
        @show normal
        M = TGW.affine_transformation(normal, centroid)


        point_z_zero = TGW.apply_matrix(M, points_face)[1:2, :]

        @show point_z_zero
        @show EV_mapped
        FT = Lar.triangulate2d(point_z_zero, EV_mapped)
        push!(FTs, map(x->idxs_verts[x],FT))
    end



    # for i in 1:rcopFE.m
    #     idxs = Lar.findnz(rcopFE[i,:])[1]
    #     edges = EV[idxs]
    #     verts = union(edges...)
    #     e1 = edges[1]
    #     p1 = e1[1]
    #     p2 = e1[2]
    #     t = findlast(x->p2 in x,edges)
    #     p3 = setdiff(edges[t],p2)[1]
    #     p4 = setdiff(verts,[p1,p2,p3])[1]
    #     push!(FVs,[[p1,p2,p3],[p1,p3,p4]])
    # end


    copFV = rcopFE * rcopEV
    FV = Lar.cop2lar(copFV)

    return V, EV, ETs, FV, FTs

end
