
"""
    buildFV(EV::Cells, face::Cell)
The list of vertex indices that expresses the given `face`.
The returned list is made of the vertex indices ordered following the traversal order to keep a coherent face orientation.
The edges are need to understand the topology of the face.
In this method the input face must be expressed as a `Cell`(=`SparseVector{Int8, Int}`) and the edges as `Cells`.
"""
function buildFV(EV::Common.Cells, face::Common.Cell)
    return buildFV(build_copEV(EV), face)
end

"""
    buildFV(copEV::ChainOp, face::Cell)
The list of vertex indices that expresses the given `face`.
The returned list is made of the vertex indices ordered following the traversal order to keep a coherent face orientation.
The edges are need to understand the topology of the face.
In this method the input face must be expressed as a `Cell`(=`SparseVector{Int8, Int}`) and the edges as `ChainOp`.
"""
function buildFV(copEV::Common.ChainOp, face::Common.Cell)
    startv = -1
    nextv = 0
    edge = 0

    vs = Array{Int64, 1}()

    while startv != nextv
        if startv < 0
            edge = face.nzind[1]
            startv = copEV[edge,:].nzind[face[edge] < 0 ? 2 : 1]
            push!(vs, startv)
        else
            edge = setdiff(intersect(face.nzind, copEV[:, nextv].nzind), edge)[1]
        end
        nextv = copEV[edge,:].nzind[face[edge] < 0 ? 1 : 2]
        push!(vs, nextv)

    end

    return vs[1:end-1]
end

"""
    buildFV(copEV::ChainOp, face::Array{Int, 1})
The list of vertex indices that expresses the given `face`.
The returned list is made of the vertex indices ordered following the traversal order to keep a coherent face orientation.
The edges are need to understand the topology of the face.
In this method the input face must be expressed as a list of vertex indices and the edges as `ChainOp`.
"""
function buildFV(copEV::Common.ChainOp, face::Array{Int, 1})
    startv = face[1]
    nextv = startv

    vs = []
    visited_edges = []

    while true
        curv = nextv
        push!(vs, curv)

        edge = 0

        for edgeEx in copEV[:, curv].nzind
            nextv = setdiff(copEV[edgeEx, :].nzind, curv)[1]
            if nextv in face && (nextv == startv || !(nextv in vs)) && !(edgeEx in visited_edges)
                edge = edgeEx
                break
            end
        end

        push!(visited_edges, edge)

        if nextv == startv
            break
        end
    end

    return vs
end


"""
    build_copFE(FV::Cells, EV::Cells)
The signed `ChainOp` from 1-cells (edges) to 2-cells (faces)
"""
function build_copFE(FV::Common.Cells, EV::Common.Cells)
	copFE = u_coboundary_1(FV, EV) # unsigned
	faceedges = [findnz(copFE[f,:])[1] for f=1:size(copFE,1)]

	f_edgepairs = Array{Array{Int64,1}}[]
	for f=1:size(copFE,1)
		edgepairs = Array{Int64,1}[]
		for v in FV[f]
			push!(edgepairs, [e for e in faceedges[f] if v in EV[e]])
		end
		push!(f_edgepairs, edgepairs)
	end
	for f=1:size(copFE,1)
		for (e1,e2) in f_edgepairs[f]
			v = intersect(EV[e1], EV[e2])[1]
			copFE[f,e1] = EV[e1][2]==v ? 1 : -1
			copFE[f,e2] = EV[e2][1]==v ? 1 : -1
		end
	end
	return copFE
end



"""
    build_copEV(EV::Cells, signed=true)
The signed (or not) `ChainOp` from 0-cells (vertices) to 1-cells (edges)
"""
function build_copEV(EV::Common.Cells, signed=true)
    setValue = [-1, 1]
    if signed == false
        setValue = [1, 1]
    end

    maxv = max(map(x->max(x...), EV)...)
    copEV = Common.SparseArrays.spzeros(Int8, length(EV), maxv)

    for (i,e) in enumerate(EV)
        e = sort(collect(e))
        copEV[i, e] = setValue
    end

    return copEV
end
