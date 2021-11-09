"""
	quads2triangles(quads::Cells)::Cells
Convert an array of *quads* with type `::Lar.Cells` into an array of *triangles*
with the same type.
# Examples
The transformation from quads to triangles works for any 2-complex, embedded in any dimensional space
## 2D example
```
V,FV = Lar.cuboidGrid([4,5])
triangles = Lar.quads2triangles(FV::Lar.Cells)::Lar.Cells
using Plasm
Plasm.view((V,[triangles]))
```
## 3D example
```
V,(VV,EV,FV,CV) = Lar.cuboidGrid([4,5,3],true)
triangles = Lar.quads2triangles(FV::Lar.Cells)::Lar.Cells
using Plasm
Plasm.view((V,[triangles]))
```
"""

function quads2triangles(quads::Common.Cells)::Lar.Cells
	pairs = [[ Int[v1,v2,v3], Int[v3,v4,v1]] for (v1,v2,v3,v4) in quads ]
	return CAT(pairs)
end

function CAT(args)
	return reduce( (x,y) -> append!(x,y), args; init=[] )
end


function get_FVs(quads::Lar.Cells)
	pairs = [[ Int[v1,v2,v3], Int[v3,v4,v1]] for (v1,v2,v3,v4) in quads ]
	return pairs
end



function affine_transformation(
    normal::Array{Float64,1},
    centroid::Array{Float64,1},
)

    function matrix4(m::Matrix)
        return vcat(hcat(m,[0,0,0]),[0.,0.,0.,1.]')
    end

    function orthonormal_basis(a, b, c)
        # https://www.mathworks.com/matlabcentral/answers/72631-create-orthonormal-basis-from-a-given-vector
        w = [a, b, c]

        if a == 0.0 && c == 0.0
            v = [0, -c, b]
        else
            v = [-c, 0, a]
        end

        u = Lar.cross(v, w)

        # @assert LinearAlgebra.dot(w,v) ≈ 0. "Dot product = $(LinearAlgebra.dot(w,v))"
        # @assert LinearAlgebra.dot(w,u) ≈ 0. "Dot product = $(LinearAlgebra.dot(w,u))"
        # @assert LinearAlgebra.dot(u,v) ≈ 0. "Dot product = $(LinearAlgebra.dot(u,v))"

        u /= Lar.norm(u)
        v /= Lar.norm(v)
        w /= Lar.norm(w)
        return hcat(u, v, w) # by column
    end


    normal /= Lar.norm(normal)
    a, b, c = normal
    d = Lar.dot(normal, centroid)
    basis = orthonormal_basis(normal...)
    rot = Lar.inv(basis)
    matrix = matrix4(rot)
    matrix[1:3, 4] = rot * -centroid #apply_matrix(matrix,-centroid)
    return matrix
end

function apply_matrix(affineMatrix::Matrix, V::Lar.Points)
    m, n = size(V)
    W = [V; fill(1.0, (1, n))]
    T = (affineMatrix*W)[1:m, 1:n]
    return T
end





#
#
# function remove_empty_faces_2(pointcloud, model)
#     centroid(points::Lar.Points) = (sum(points,dims=2)/size(points,2))[:,1]
#     kdtree = Lar.KDTree(pointcloud)
#     T,ET,FT,FTs = model
#     tokeep = Int64[]
#
# 	n_faces = length(FT)
# 	counters = zeros(n_faces)
# 	n_p = 1
# 	for point in eachcol(pointcloud)
# 		if n_p % 1000 == 0
# 			println("$n_p of $(size(pointcloud,2))")
# 		end
# 		n_p+=1
#
#     	for i in 1:n_faces
# 			if counters[i] > 20
# 				continue
# 			else
# 	            for triangle in FTs[i]
# 					tri = T[:, triangle]
# 	                if point_in_3D_triangle(point,tri)
# 	                    counters[i]+=1
# 						break
# 	                end
# 	            end
# 			end
#         end
#     end
#
# 	for i in 1:n_faces
# 		if counters[i] > 20
# 			push!(tokeep,i)
# 		end
# 	end
#     return T,ET,FT[tokeep],FTs[tokeep]
# end
#
# # triangle = [p1,p2,p3]
# function point_in_3D_triangle(point,triangle)
#     a = triangle[:, 1]
#     b = triangle[:, 2]
#     c = triangle[:, 3]
#     areaABC = Lar.norm(Lar.cross(b-a,c-a))/2
#     alpha = Lar.norm(Lar.cross(b-point,c-point))/(2*areaABC)
#     beta = Lar.norm(Lar.cross(c-point,a-point))/(2*areaABC)
#     gamma = 1-alpha+beta
#
#     # @show (alpha >= 0 && alpha <= 1)
#     # @show (beta >= 0 && beta <= 1)
#     # @show (gamma >= 0 && gamma <= 1)
#     # @show gamma = 1-alpha+beta
#     return (alpha >= 0 && alpha <= 1) && (beta >= 0 && beta <= 1) && (gamma >= 0 && gamma <= 1)
# end
#
