using Arrangement
using Common
using Visualization


# da inserire nel codice
function submanifold_mapping(vs)
    u1 = Common.normalize(vs[2,:] - vs[1,:])
    u2 = Common.normalize(vs[3,:] - vs[1,:])
    u3 = Common.normalize(Common.cross(u1, u2))
    # @show Common.norm(u1)
    # @show Common.norm(u2)
    # @show Common.norm(u3)
    T = Matrix{Float64}(Common.I, 4, 4)
    T[4, 1:3] = - vs[1,:]
    M = Matrix{Float64}(Common.I, 4, 4)
    M[1:3, 1:3] = [u1 u2 u3]
    return T*M
end


vs = [  0.0 0.0 2.0 2.0
        0.0 2.0 0.0 2.0
        0.0 0.0 0.0 0.0]

vs = rand(2,5)
vs = Common.add_zeta_coordinates(vs,0.0)
ROTO = Common.r(0,pi/3,0)
V = Common.apply_matrix(ROTO,vs)

M = submanifold_mapping(permutedims(V))

Common.apply_matrix(Common.inv(M),V)



Visualization.VIEW([Visualization.GLFrame,Visualization.points(V)])
Visualization.VIEW([Visualization.GLFrame,Visualization.points(V; color = Visualization.COLORS[3]),Visualization.points(Common.apply_matrix(Common.inv(M),V))])
