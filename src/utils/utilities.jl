function lar2cop(CV::Common.Cells)::Common.ChainOp
    I = Int64[]
    J = Int64[]
    Value = Int8[]
    for k = 1:size(CV, 1)
        n = length(CV[k])
        append!(I, k * ones(Int64, n))
        append!(J, CV[k])
        append!(Value, ones(Int64, n))
    end
    return Common.sparse(I, J, Value)
end


function cop2lar(cop::Common.ChainOp)::Common.Cells
    [Common.findnz(cop[k, :])[1] for k = 1:size(cop, 1)]
end


function FV2EVs(copEV::Common.ChainOp, copFE::Common.ChainOp)
    EV = [Common.findnz(copEV[k, :])[1] for k = 1:size(copEV, 1)]
    FE = [Common.findnz(copFE[k, :])[1] for k = 1:size(copFE, 1)]
    EVs = [[EV[e] for e in fe] for fe in FE]
    return EVs
end


"""
    face_area(V::Points, EV::Cells, face::Cell)
The area of `face` given a geometry `V` and an edge topology `EV`.
"""
function face_area(V::Common.Points, EV::Common.Cells, face::Common.Cell)
    return face_area(V, build_copEV(EV), face)
end

function face_area(V::Common.Points, EV::Common.ChainOp, face::Common.Cell)
    function triangle_area(triangle_points::Common.Points)
        ret = ones(3,3)
        ret[:, 1:2] = triangle_points
        return .5*Common.det(ret)
    end

    area = 0

    fv = buildFV(EV, face)

    verts_num = length(fv)
    v1 = fv[1]

    for i in 2:(verts_num-1)

        v2 = fv[i]
        v3 = fv[i+1]

        area += triangle_area(V[[v1, v2, v3], :])
    end

    return area
end

"""
    skel_merge(V1::Points, EV1::ChainOp, V2::Points, EV2::ChainOp)
Merge two **1-skeletons**
"""
function skel_merge(V1::Common.Points, EV1::Common.ChainOp, V2::Common.Points, EV2::Common.ChainOp)
    V = [V1; V2]
    EV = Common.blockdiag(EV1,EV2)
    return V, EV
end

"""
    skel_merge(V1::Points, EV1::ChainOp, FE1::ChainOp, V2::Points, EV2::ChainOp, FE2::ChainOp)
Merge two **2-skeletons**
"""
function skel_merge(V1::Common.Points, EV1::Common.ChainOp, FE1::Common.ChainOp,
					V2::Common.Points, EV2::Common.ChainOp, FE2::Common.ChainOp)
    FE = Common.blockdiag(FE1,FE2)
    V, EV = skel_merge(V1, EV1, V2, EV2)
    return V, EV, FE
end

"""
    delete_edges(todel, V::Points, EV::ChainOp)
Delete edges and remove unused vertices from a **2-skeleton**.
Loop over the `todel` edge index list and remove the marked edges from `EV`.
The vertices in `V` which remained unconnected after the edge deletion are deleted too.
"""
function delete_edges(todel, V::Common.Points, EV::Common.ChainOp)
    tokeep = setdiff(collect(1:EV.m), todel)
    EV = EV[tokeep, :]

    vertinds = 1:EV.n
    todel = Array{Int64, 1}()
    for i in vertinds
        if length(EV[:, i].nzind) == 0
            push!(todel, i)
        end
    end

    tokeep = setdiff(vertinds, todel)
    EV = EV[:, tokeep]
    V = V[tokeep, :]

    return V, EV
end

function coordintervals(coord,bboxes)
	boxdict = OrderedDict{Array{Float64,1},Array{Int64,1}}()
	for (h,box) in enumerate(bboxes)
		key = box[coord,:]
		if haskey(boxdict,key) == false
			boxdict[key] = [h]
		else
			push!(boxdict[key], h)
		end
	end
	return boxdict
end
