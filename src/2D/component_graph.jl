"""
Return containment graph of components:
 - row: contained
 - column: container
"""
function componentgraph(V, EVs, bicon_comps, shells, boundaries)

    function containment_test(V, EVs, shells, bboxes)
        n = length(bboxes)
        containment_graph = SparseArrays.spzeros(Int8, n, n)

        # si potrebbe migliorare questa parte mettendo in colonna tutti i cicli e in riga tutte le componenti biconnesse
        # così per il prossimo passaggio già so la componente in quale ciclo ricade
        for i = 1:n
            shell = shells[i]
            EV = EVs[i]
            for j = 1:n
                if i != j && bbox_contains(bboxes[j], bboxes[i])
                    containment_graph[i, j] = 1
                    shell_edge_indexes = shells[j].nzind
                    ev = EVs[j][shell_edge_indexes, :]
                    for an_edge in shell.nzind
                        origin_index = EV[an_edge, :].nzind[1]
                        origin = V[origin_index, :]
                        if pointInPolygonClassification(V, ev)(origin) ==
                           "p_out"
                            containment_graph[i, j] = 0
                            break
                        end
                    end
                end
            end
        end


        return containment_graph
    end

    # eliminare elementi per transitività
    function transitive_reduction!(graph)
        n = size(graph, 1)
        for j = 1:n
            for i = 1:n
                if graph[i, j] > 0
                    for k = 1:n
                        if graph[j, k] > 0
                            graph[i, k] = 0
                        end
                    end
                end
            end
        end
        SparseArrays.dropzeros!(graph)
    end

    #  calcola il grafo di contenimento tra componenti biconnesse
    # conoscendo la cella esterna di ogni componente

    # arrangement of isolated components
    n_of_comps = length(bicon_comps)

    # computation of bounding boxes of isolated components
    shell_bboxes = []
    for i = 1:n_of_comps
        vs_indexes = (abs.(EVs[i]') * abs.(shells[i])).nzind
        push!(shell_bboxes, bbox(V[vs_indexes, :]))
    end

    # computation and reduction of containment graph
    containment_graph = containment_test(V, EVs, shells, shell_bboxes)

    # containment_graph =
    #     prune_containment_graph(n_of_comps, V, EVs, shells, containment_graph)

    transitive_reduction!(containment_graph)

    return containment_graph, shell_bboxes
end
