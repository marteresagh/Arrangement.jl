
function frag_face(V, EV, FE, sp_idx, sigma)

    vs_num = size(V, 1)

    # 2D transformation of sigma face
    sigmavs = (abs.(FE[sigma:sigma, :])*abs.(EV))[1, :].nzind
    sV = V[sigmavs, :]
    sEV = EV[FE[sigma, :].nzind, sigmavs]
    M = submanifold_mapping(sV)
    tV = ([V ones(vs_num)]*M)[:, 1:3]  # folle convertire *tutti* i vertici
    sV = tV[sigmavs, :]
    # sigma face intersection with faces in sp_idx[sigma]
    for i in sp_idx[sigma]
        # println("faccia che sta intersecando: $i")
        tmpV, tmpEV = face_int(tV, EV, FE[i, :])
        sV, sEV = skel_merge(sV, sEV, tmpV, tmpEV)
    end

    # computation of 2D arrangement of sigma face
    sV = sV[:, 1:2]
    nV, nEV, nFE = planar_arrangement(
        sV,
        sEV;
        sigma = Common.sparsevec(ones(Int8, length(sigmavs))),
    )

    if nV == nothing ## not possible !! ... (each original face maps to its decomposition)
        return [], Common.spzeros(Int8, 0, 0), Common.spzeros(Int8, 0, 0)
    end
    nvsize = size(nV, 1)
    nV = [nV zeros(nvsize) ones(nvsize)] * inv(M)[:, 1:3] ## ????

    return nV, nEV, nFE
end

function merge_vertices(
    V::Common.Points,
    EV::Common.ChainOp,
    FE::Common.ChainOp,
    err = 1e-4,
)
    vertsnum = size(V, 1)
    edgenum = size(EV, 1)
    facenum = size(FE, 1)
    newverts = zeros(Int, vertsnum)
    # KDTree constructor needs an explicit array of Float64
    V = Array{Float64,2}(V)
    W = permutedims(V)
    kdtree = KDTree(W)
    # remove vertices congruent to a single representative
    todelete = []
    i = 1
    for vi = 1:vertsnum
        if !(vi in todelete)
            nearvs = inrange(kdtree, V[vi, :], err)
            newverts[nearvs] .= i
            nearvs = setdiff(nearvs, vi)
            todelete = union(todelete, nearvs)
            i = i + 1
        end
    end
    nV = V[setdiff(collect(1:vertsnum), todelete), :]

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
    nEV = Common.spzeros(Int8, nedgenum, size(nV, 1))

    etuple2idx = Dict{Tuple{Int,Int},Int}()
    for ei = 1:nedgenum
        begin
            nEV[ei, collect(nedges[ei])] .= 1
            nEV
        end
        @show nedges[ei]
        etuple2idx[nedges[ei]] = ei
    end
    for e = 1:nedgenum
        v1, v2 = Common.findnz(nEV[e, :])[1]
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
    nFE = Common.spzeros(Int8, nfacenum, size(nEV, 1))


    for fi = 1:nfacenum
        for edge in nfaces[fi]

            ei = etuple2idx[Tuple{Int,Int}(sort(collect(edge)))]

            nFE[fi, ei] = sign(edge[2] - edge[1])
        end
    end

    return Common.Points(nV), nEV, nFE
end


function get_model_intersected(V, EV, FE)
    fs_num = size(FE, 1)
    sp_idx = spatial_index(V, EV, FE)

    rV = Common.Points(undef, 0, 3)
    rEV = Common.spzeros(Int8, 0, 0)
    rFE = Common.spzeros(Int8, 0, 0)

    depot_V = Array{Array{Float64,2},1}(undef, fs_num)
    depot_EV = Array{Common.ChainOp,1}(undef, fs_num)
    depot_FE = Array{Common.ChainOp,1}(undef, fs_num)
    # depot_V = Array{Array{Float64,2},1}()
    # depot_EV = Array{Common.ChainOp,1}()
    # depot_FE = Array{Common.ChainOp,1}()

    for sigma = 1:fs_num
        println(sigma, "/", fs_num)

            nV, nEV, nFE = frag_face(V, EV, FE, sp_idx, sigma)

            depot_V[sigma] = nV
            depot_EV[sigma] = nEV
            depot_FE[sigma] = nFE

    end

    rV = vcat(depot_V...)
    rEV = Common.blockdiag(depot_EV...)
    rFE = Common.blockdiag(depot_FE...)

    rV, rcopEV, rcopFE = merge_vertices(rV, rEV, rFE)
    return rV, rcopEV, rcopFE
end


function model_intersection(V, EV, FV) # V sempre in colonne

    get_centroid(points::Common.Points) =
        (sum(points, dims = 2)/size(points, 2))[:, 1]

    cop_EV = coboundary_0(EV)
    cop_FE = coboundary_1(V, FV, EV)

    rV, rcopEV, rcopFE = get_model_intersected(W, cop_EV, cop_FE)

    EV = cop2lar(rcopEV)
    FE = cop2lar(rcopFE)


    ETs = FV2EVs(rcopEV, rcopFE) # polygonal face fragments

    FTs = Vector{Vector{Int64}}[]

    for i = 1:length(ETs)
        ET = ETs[i]
        idxs_verts = union(ET...)
        points_face = V[:, idxs_verts]
        EV_mapped = [
            map(x -> findall(j -> j == x, idxs_verts)[1], ET[i])
            for i = 1:length(ET)
        ]


        baricentro = get_centroid(points_face)
        normal = Common.cross(
            baricentro - points_face[:, 1],
            points_face[:, 2] - points_face[:, 1],
        )

        centroid = points_face[:, 1]

        M = affine_transformation(normal, centroid)


        point_z_zero = Common.apply_matrix(M, points_face)[1:2, :]

        FT = triangulate2d(point_z_zero, EV_mapped)
        push!(FTs, map(x -> idxs_verts[x], FT))
    end

    copFV = rcopFE * rcopEV
    FV = cop2lar(copFV)

    return V, EV, ETs, FV, FTs

end
