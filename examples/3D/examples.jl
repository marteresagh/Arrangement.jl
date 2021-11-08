using TGW

# store = [];
# V1, (VV1, EV1, FV1, CV1) = Lar.cuboid([2.0, 2.0, 2.0], true, [0.0, 0.0, 0.0]);
# V2, (VV2, EV2, FV2, CV2) = Lar.cuboid([2.0, 1.5, 1.5], true, [0.5, 0.5, 0.5]);
# # V3, (VV3, EV3, FV3, CV3) = Lar.cuboid([2.5, 0.5, 0.5], true, [3.0, 0.0, 0.0]);
# str = Lar.Struct([(V1, CV1, FV1, EV1)])
# obj = Lar.struct2lar(str)
# push!(store, obj)
#
# str = Lar.Struct([(V2, CV2, FV2, EV2)])
# obj = Lar.struct2lar(str)
# push!(store, obj)
# #
# # str = Lar.Struct([(V3, CV3, FV3, EV3)])
# # obj = Lar.struct2lar(str)
# # push!(store, obj)
#
#
# str = Lar.Struct(store);
# V, CV, FV, EV = Lar.struct2lar(str);
#

# model = (V, [VV, EV, FV]);
# meshes = GL.numbering(1.0)(model, GL.COLORS[1], 0.1);
# GL.VIEW(meshes)

V = [
    0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.0 0.0 1.5 1.5 1.0 1.0
    0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 1.0 1.0 1.0 1.0 1.5 1.5
    0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0
]

EV = [
    [11,13],
    [12,14],
    [9,10],
    [11,12],
    [13,14],
    [9,11],
    [9,13],
    [10,12],
    [10,14],
    [1, 2],
    [3, 4],
    [5, 6],
    [7, 8],
    [1, 3],
    [2, 4],
    [5, 7],
    [6, 8],
    [1, 5],
    [2, 6],
    [3, 7],
    [4, 8],
]

FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [1, 2, 5, 6],
    [3, 4, 7, 8],
    [1, 3, 5, 7],
    [2, 4, 6, 8],
    [9,10,11,12],
    [9,10,13,14],
    [9,11,13],
    [10,12,14],
    [11,12,13,14]

]



cop_EV = Lar.coboundary_0(EV)
cop_FE = Lar.coboundary_1(V, FV, EV)
W = permutedims(V)

T,ET,FE = TGW.get_model_intersected(W, cop_EV, cop_FE)

larET = Lar.cop2lar(ET)
larFE = Lar.cop2lar(FE)
ETs = Lar.FV2EVs(ET, FE)
GL.VIEW([
    GL.GLFrame,
    GL.GLExplode(permutedims(T), ETs, 1.1, 1.1, 1.1, 99, 1)...,
]);








T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV);

GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1));
GL.VIEW(GL.GLExplode(T, ETs, 1.5, 1.5, 1.5, 99, 1));
GL.VIEW(GL.GLExplode(T, [CTs[4]], 1.2, 1.2, 1.2, 99, 0.8));



T, ETs, FTs, CTs = TGW.arrange3D(V, EV, FV)
GL.VIEW(GL.GLExplode(T, ETs, 1.1, 1.1, 1.1, 99, 1));
GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1));
GL.VIEW(GL.GLExplode(T, CTs, 1.1, 1.1, 1.1, 99, 1));
