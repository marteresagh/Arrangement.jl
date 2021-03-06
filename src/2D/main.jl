# Arrangement per il 2D
# input vertici e spigoli.
function arrange2D(V, EV)
    copEW = lar2cop(EV)
    V_by_row = permutedims(V)

    # da qui in poi i vertici sono per righe
    T, copET, copFE = planar_arrangement(V_by_row, copEW)

    ETs, FTs = get_topology(permutedims(T),copET,copFE)
    return permutedims(T), ETs, FTs
end

"""
    planar_arrangement(V::Points, EV::ChainOp, [sigma::Chain], [return_edge_map::Bool], [multiproc::Bool])
Compute the arrangement on the given cellular complex 1-skeleton in 2D.
A cellular complex is arranged when the intersection of every possible pair of cell
of the complex is empty and the union of all the cells is the whole Euclidean space.
The basic method of the function without the `sigma`, `return_edge_map` and `multiproc` arguments
returns the full arranged complex `V`, `EV` and `FE`.
## Additional arguments:
- `sigma::Chain`: if specified, `planar_arrangement` will delete from the output every edge and face outside this cell. Defaults to an empty cell.
- `return_edge_map::Bool`: makes the function return also an `edge_map` which maps the edges of the imput to the one of the output. Defaults to `false`.
- `multiproc::Bool`: Runs the computation in parallel mode. Defaults to `false`.
"""
function planar_arrangement(V::Common.Points, copEV::Common.ChainOp; sigma::Common.Chain=SparseArrays.spzeros(Int8, 0))
    # V_by_row

    # planar graph
    V, copEV, edge_map = create_planar_graph(V, copEV)

    # cleandecomposition

    if sigma.n > 0
        V,copEV = cleandecomposition(V, copEV, sigma, edge_map)
    end



    # biconnected components
    bicon_comps = biconnected_components(copEV)

    if !isempty(bicon_comps)

        # component graph
        EVs, shells, boundaries = cycle_basis(V, copEV, bicon_comps)

        containment_graph, shell_bboxes =
            componentgraph(V, EVs, bicon_comps, shells, boundaries)


        copEV, copFE = cell_merging(
            containment_graph,
            V,
            EVs,
            boundaries,
            shells,
            shell_bboxes,
        )


        return V, copEV, copFE
    else
        println("No biconnected components found.")
        return nothing, nothing, nothing
    end
end


"""
get topology
"""
function get_topology(T,copET, copFE)

    ETs = FV2EVs(copET, copFE) # polygonal face fragments

    FTs = []
    for i = 1:length(ETs)
        EV = ETs[i]
        FV = triangulate2d(T, EV)
        push!(FTs, FV)
    end

    return ETs, FTs
end


"""
get_planar_graph
"""
function get_planar_graph(V, EV)
    cop_EV = coboundary_0(EV)
    copEW = convert(Common.ChainOp, cop_EV)
    W = permutedims(V)

    T, copET = create_planar_graph(W, copEW)
    ET = cop2lar(copET)

    return permutedims(T), ET
end
