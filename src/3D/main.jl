function arrange3D(V, EV, FV)
    cop_EV = coboundary_0(EV)
    cop_FE = coboundary_1(V, FV, EV)
    W = permutedims(V)

    T, copET, copFE, copCF = space_arrangement(W, cop_EV, cop_FE)

    T = permutedims(T)
    T, CVs, FVs, EVs = Lar.pols2tria(T, copET, copFE, copCF) # whole assembly
    return T, EVs, FVs, CVs
end


function space_arrangement(V::Common.Points, EV::Common.ChainOp, FE::Common.ChainOp)

    println("======= START ==============")
    rV, rcopEV, rcopFE = get_model_intersected(V, EV, FE)
    println("======= Intersection DONE ==============")

    rcopCF = minimal_3cycles(rV, rcopEV, rcopFE)
    println("======= Cycle BASIS FOUNDED ==============")

    return rV, rcopEV, rcopFE, rcopCF
end


# function Lar_arrangement3D(V, EV,FV)
#     cop_EV = Lar.coboundary_0(EV::Lar.Cells)
#     cop_FE = Lar.coboundary_1(V, FV::Lar.Cells, EV::Lar.Cells)
#     W = convert(Lar.Points, V')
#
#     V, copEV, copFE, copCF = Lar.space_arrangement(
#         W::Lar.Points,
#         cop_EV::Lar.ChainOp,
#         cop_FE::Lar.ChainOp,
#     )
#
#     V = convert(Lar.Points, V')
#     V, CVs, FVs, EVs = Lar.pols2tria(V, copEV, copFE, copCF) # whole assembly
#     return V, EVs, FVs, CVs
# end
