## grafo planare: intersezioni degli spigoli.
function create_planar_graph(V, copEV)

    # V_by_row
    # data structures initialization
    edgenum = size(copEV, 1)
    edge_map = Array{Array{Int,1},1}(undef, edgenum)
    rV = Common.Points(zeros(0, 2))
    rEV = Common.SparseArrays.spzeros(Int8, 0, 0)
    finalcells_num = 0

    # spaceindex computation TODO questo lo porterei fuori
    model = (permutedims(V), cop2lar(copEV))
    bigPI = spaceindex(model)

    for i = 1:edgenum
        v, ev = frag_edge(V, copEV, i, bigPI)
        newedges_nums = map(x -> x + finalcells_num, collect(1:size(ev, 1)))
        edge_map[i] = newedges_nums
        finalcells_num += size(ev, 1)
        rV = convert(Lar.Points, rV)
        rV, rEV = Lar.skel_merge(rV, rEV, v, ev)
    end

    # merging of close vertices and edges (2D congruence)
    V, copEV = rV, rEV
    V, copEV = merge_vertices!(V, copEV, edge_map)
    return V, copEV, edge_map
end


"""
    frag_edge(V::Lar.Points, EV::Lar.ChainOp, edge_idx::Int, bigPI::Array)
Fragment the edge of index `edge_idx` using the edges indicized in `bigPI`.
"""
function frag_edge(V, EV::Lar.ChainOp, edge_idx::Int, bigPI)
    alphas = Dict{Float64,Int}()
    edge = EV[edge_idx, :]
    verts = V[edge.nzind, :]
    for i in bigPI[edge_idx]
        if i != edge_idx
            intersection = intersect_edges(V, edge, EV[i, :])
            for (point, alpha) in intersection
                verts = [verts; point]
                alphas[alpha] = size(verts, 1)
            end
        end
    end
    alphas[0.0], alphas[1.0] = [1, 2]
    alphas_keys = sort(collect(keys(alphas)))
    edge_num = length(alphas_keys) - 1
    verts_num = size(verts, 1)
    ev = Common.SparseArrays.spzeros(Int8, edge_num, verts_num)
    for i = 1:edge_num
        ev[i, alphas[alphas_keys[i]]] = 1
        ev[i, alphas[alphas_keys[i+1]]] = 1
    end
    return verts, ev
end


"""
    intersect_edges(V::Lar.Points, edge1::Lar.Cell, edge2::Lar.Cell)
Intersect two 2D edges (`edge1` and `edge2`).
"""
function intersect_edges(V::Common.Points, edge1::Common.Cell, edge2::Common.Cell)
    err = 10e-8

    x1, y1, x2, y2 = vcat(map(c -> V[c, :], edge1.nzind)...)
    x3, y3, x4, y4 = vcat(map(c -> V[c, :], edge2.nzind)...)
    ret = Array{Tuple{Lar.Points,Float64},1}()

    v1 = [x2 - x1, y2 - y1]
    v2 = [x4 - x3, y4 - y3]
    v3 = [x3 - x1, y3 - y1]
    ang1 = Common.dot(LinearAlgebra.normalize(v1), LinearAlgebra.normalize(v2))
    ang2 = Common.dot(LinearAlgebra.normalize(v1), LinearAlgebra.normalize(v3))
    parallel = 1 - err < abs(ang1) < 1 + err
    colinear =
        parallel && (1 - err < abs(ang2) < 1 + err || -err < Lar.norm(v3) < err)
    if colinear
        o = [x1 y1]
        v = [x2 y2] - o
        alpha = 1 / Lar.dot(v, v')
        ps = [x3 y3; x4 y4]
        for i = 1:2
            a = alpha * Common.dot(v', (reshape(ps[i, :], 1, 2) - o))
            if 0 < a < 1
                push!(ret, (ps[i:i, :], a))
            end
        end
    elseif !parallel
        denom = (v2[2]) * (v1[1]) - (v2[1]) * (v1[2])
        a = ((v2[1]) * (-v3[2]) - (v2[2]) * (-v3[1])) / denom
        b = ((v1[1]) * (-v3[2]) - (v1[2]) * (-v3[1])) / denom

        if -err < a < 1 + err && -err <= b <= 1 + err
            p = [(x1 + a * (x2 - x1)) (y1 + a * (y2 - y1))]
            push!(ret, (p, a))
        end
    end
    return ret
end


"""
    merge_vertices!(V::Lar.Points, EV::Lar.ChainOp, edge_map, err=1e-4)
Merge congruent vertices and edges in `V` and `EV`.
"""
function merge_vertices!(V::Common.Points, EV::Common.ChainOp, edge_map, err = 1e-4)
    vertsnum = size(V, 1)
    edgenum = size(EV, 1)
    newverts = zeros(Int, vertsnum)
    # KDTree constructor needs an explicit array of Float64
    V = Array{Float64,2}(V)
    kdtree = KDTree(permutedims(V))

    # merge congruent vertices
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

    # merge congruent edges
    edges = Array{Tuple{Int,Int},1}(undef, edgenum)
    oedges = Array{Tuple{Int,Int},1}(undef, edgenum)
    for ei = 1:edgenum
        v1, v2 = EV[ei, :].nzind
        edges[ei] = Tuple{Int,Int}(sort([newverts[v1], newverts[v2]]))
        oedges[ei] = Tuple{Int,Int}(sort([v1, v2]))
    end
    nedges = union(edges)
    nedges = filter(t -> t[1] != t[2], nedges)
    nedgenum = length(nedges)
    nEV = Lar.spzeros(Int8, nedgenum, size(nV, 1))
    # maps pairs of vertex indices to edge index
    etuple2idx = Dict{Tuple{Int,Int},Int}()
    # builds `edge_map`
    for ei = 1:nedgenum
        nEV[ei, collect(nedges[ei])] .= 1
        etuple2idx[nedges[ei]] = ei
    end
    for i = 1:length(edge_map)
        row = edge_map[i]
        row = map(x -> edges[x], row)
        row = filter(t -> t[1] != t[2], row)
        row = map(x -> etuple2idx[x], row)
        edge_map[i] = row
    end
    # return new vertices and new edges
    return Common.Points(nV), nEV
end



"""
	spaceindex(model::Lar.LAR)::Array{Array{Int,1},1}
Generation of *space indexes* for all ``(d-1)``-dim cell members of `model`.
*Spatial index* made by ``d`` *interval-trees* on
bounding boxes of ``sigma in S_{d−1}``. Spatial queries solved by
intersection of ``d`` queries on IntervalTrees generated by
bounding-boxes of geometric objects (LAR cells).
The return value is an array of arrays of `int`s, indexing cells whose
containment boxes are intersecting the containment box of the first cell.
According to Hoffmann, Hopcroft, and Karasick (1989) the worst-case complexity of
Boolean ops on such complexes equates the total sum of such numbers.
# Examples 2D
```
julia> V = hcat([[0.,0],[1,0],[1,1],[0,1],[2,1]]...);
julia> EV = [[1,2],[2,3],[3,4],[4,1],[1,5]];
julia> Sigma = Lar.spaceindex((V,EV))
5-element Array{Array{Int64,1},1}:
 [4, 5, 2]
 [1, 3, 5]
 [4, 5, 2]
 [1, 3, 5]
 [4, 1, 3, 2]
```
From `model2d` value, available in `?input_collection` docstring:
```julia
julia> Sigma =  spaceindex(model2d);
```
# Example 3D
```julia
model = model3d
Sigma =  spaceindex(model3d);
Sigma
```
"""
function spaceindex(model::Common.LAR)::Array{Array{Int,1},1}
    V, CV = model[1:2]
    dim = size(V, 1)
    cellpoints = [V[:, CV[k]]::Lar.Points for k = 1:length(CV)]
    #----------------------------------------------------------
    bboxes = [hcat(Lar.boundingbox(cell)...) for cell in cellpoints]
    xboxdict = Lar.coordintervals(1, bboxes)
    yboxdict = Lar.coordintervals(2, bboxes)
    # xs,ys are IntervalTree type
    xs = IntervalTrees.IntervalMap{Float64,Array}()
    for (key, boxset) in xboxdict
        xs[tuple(key...)] = boxset
    end
    ys = IntervalTrees.IntervalMap{Float64,Array}()
    for (key, boxset) in yboxdict
        ys[tuple(key...)] = boxset
    end
    xcovers = Lar.boxcovering(bboxes, 1, xs)
    ycovers = Lar.boxcovering(bboxes, 2, ys)
    covers = [intersect(pair...) for pair in zip(xcovers, ycovers)]

    if dim == 3
        zboxdict = coordintervals(3, bboxes)
        zs = IntervalTrees.IntervalMap{Float64,Array}()
        for (key, boxset) in zboxdict
            zs[tuple(key...)] = boxset
        end
        zcovers = Lar.boxcovering(bboxes, 3, zs)
        covers = [intersect(pair...) for pair in zip(zcovers, covers)]
    end
    # remove each cell from its cover
    for k = 1:length(covers)
        covers[k] = setdiff(covers[k], [k])
    end
    return covers
end
