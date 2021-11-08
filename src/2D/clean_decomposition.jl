function cleandecomposition(V, copEV, sigma, edge_map)
    # Deletes edges outside sigma area
    todel = []
    new_edges = []
    map(i->new_edges=union(new_edges, edge_map[i]), sigma.nzind)
    ev = copEV[new_edges, :]
    for e in 1:copEV.m
        if !(e in new_edges)

            vidxs = copEV[e, :].nzind
            v1, v2 = map(i->V[vidxs[i], :], [1,2])
            centroid = .5*(v1 + v2)

            if ! Lar.point_in_face(centroid, V, ev)
                push!(todel, e)
            end
        end
    end

    for i in reverse(todel)
        for row in edge_map

            filter!(x->x!=i, row)

            for j in 1:length(row)
                if row[j] > i
                    row[j] -= 1
                end
            end
        end
    end

    V, copEV = Lar.delete_edges(todel, V, copEV)
	return V,copEV
end
