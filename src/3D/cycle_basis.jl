function minimal_3cycles(V::Lar.Points, EV::Lar.ChainOp, FE::Lar.ChainOp)

    triangulated_faces = Array{Any,1}(undef, FE.m)

    function face_angle(e::Int, f::Int)
        if !isassigned(triangulated_faces, f)
            vs_idxs = Array{Int64,1}()
            edges_idxs = FE[f, :].nzind
            edge_num = length(edges_idxs)
            edges = zeros(Int64, edge_num, 2)

            for (i, ee) in enumerate(edges_idxs)
                edge = EV[ee, :].nzind
                edges[i, :] = edge
                vs_idxs = union(vs_idxs, edge)
            end

            #vs = V[vs_idxs, :]
            fv, edges = vcycle(EV, FE, f)

            vs = V[fv, :]


            v1 = Lar.LinearAlgebra.normalize(vs[2, :] - vs[1, :])
            v2 = [0 0 0]# added for debug
            v3 = [0 0 0]
            err = 1e-8
            i = 3
            while -err < Lar.LinearAlgebra.norm(v3) < err
                v2 = Lar.LinearAlgebra.normalize(vs[i, :] - vs[1, :])
                v3 = Lar.LinearAlgebra.cross(v1, v2)
                i = i + 1
            end
            M = reshape([v1; v2; v3], 3, 3)

            #vs = vs*M
            vs = (vs*M)[:, 1:2]

            # triangulated_faces[f] = Triangle.constrained_triangulation(
            #     Array{Float64,2}(vs), vs_idxs, edges, fill(true, edge_num))
            v = convert(Lar.Points, vs'[1:2, :])
            vmap = Dict(zip(fv, 1:length(fv))) # vertex map
            mapv = Dict(zip(1:length(fv), fv)) # inverse vertex map
            trias = Lar.triangulate2d(v, edges)
            triangulated_faces[f] = [[mapv[v] for v in tria] for tria in trias]
        end
        edge_vs = EV[e, :].nzind

        t = findfirst(
            x -> edge_vs[1] in x && edge_vs[2] in x,
            triangulated_faces[f],
        )

        v1 = Lar.LinearAlgebra.normalize(V[edge_vs[2], :] - V[edge_vs[1], :])

        if abs(v1[1]) > abs(v1[2])
            invlen = 1.0 / sqrt(v1[1] * v1[1] + v1[3] * v1[3])
            v2 = [-v1[3] * invlen, 0, v1[1] * invlen]
        else
            invlen = 1.0 / sqrt(v1[2] * v1[2] + v1[3] * v1[3])
            v2 = [0, -v1[3] * invlen, v1[2] * invlen]
        end

        v3 = Lar.LinearAlgebra.cross(v1, v2)

        M = reshape([v1; v2; v3], 3, 3)

        triangle = triangulated_faces[f][t]
        third_v = setdiff(triangle, edge_vs)[1]
        vs = V[[edge_vs..., third_v], :] * M

        v = vs[3, :] - vs[1, :]
        angle = Lar.LinearAlgebra.atan(v[2], v[3])
        return angle
    end

    #EF = FE'
    EF = convert(Lar.ChainOp, Lar.LinearAlgebra.transpose(FE))

    FC = minimal_cycles(face_angle)(V, EF)  # , EV)

    #FC'
    return -convert(Lar.ChainOp, Lar.LinearAlgebra.transpose(FC))
end
