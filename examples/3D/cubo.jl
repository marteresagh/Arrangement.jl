using TGW

V = [
    0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0
    0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0
    0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0
]

EV = [
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
    [4, 8]
]

FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [1, 2, 5, 6],
    [3, 4, 7, 8],
    [1, 3, 5, 7],
    [2, 4, 6, 8]
]

GL.VIEW([GL.GLLines(V, EV)])

### codice riga per riga

cop_EV = Lar.coboundary_0(EV)
cop_FE = Lar.coboundary_1(V, FV, EV)
W = permutedims(V)

rV, rcopEV, rcopFE = TGW.get_model_intersected(W, cop_EV, cop_FE)


larTT = [[i] for i = 1:size(rV, 1)]
larET = Lar.cop2lar(rcopEV)
larFE = Lar.cop2lar(rcopFE)


model = (permutedims(rV), [larTT, larET,FV]);
meshes = GL.numbering(1.0)(model, GL.COLORS[1], 0.1);
GL.VIEW(meshes)

rcopCF = TGW.minimal_3cycles(rV, rcopEV, rcopFE)

######################################################
# T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV);
T, ETs, FTs, CTs = TGW.arrange3D(V, EV, FV)
GL.VIEW(GL.GLExplode(T, ETs, 1.1, 1.1, 1.1, 99, 1));
GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1));
for i = 1:length(CTs)
    GL.VIEW(GL.GLExplode(T, [CTs[i]], 1.1, 1.1, 1.1, 99, 0.2))
end

##############################   facce intersecate in un cubo
V = [
    0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 1.0 1.0 1.0 1.0 2.0 2.0 2.0 2.0
    0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 1.0 1.0 1.0 1.0 2.0 2.0 2.0 2.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0
    1.0 1.0 1.0 1.0 2.0 2.0 2.0 2.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0
]

EV = [
    [1, 2],
    [2, 3],
    [3, 4],
    [4, 1],
    [5, 6],
    [6, 7],
    [7, 8],
    [8, 5],
    [9, 10],
    [10, 11],
    [11, 12],
    [12, 9],
    [13, 14],
    [14, 15],
    [15, 16],
    [16, 13],
    [17, 18],
    [18, 19],
    [19, 20],
    [20, 17],
    [21, 22],
    [22, 23],
    [23, 24],
    [24, 21]
]

FV = [
    [1, 2, 4, 3],
    [5, 6, 8, 7],
    [9, 10, 12, 11],
    [13, 14, 16, 15],
    [17, 18, 20, 19],
    [21, 22, 24, 23]
]

GL.VIEW([GL.GLGrid(V, FV)])
GL.VIEW([GL.GLLines(V, EV)])

### codice riga per riga

cop_EV = Lar.coboundary_0(EV)
cop_FE = Lar.coboundary_1(V, FV, EV)
W = permutedims(V)

rV, rcopEV, rcopFE = TGW.get_model_intersected(W, cop_EV, cop_FE)


larTT = [[i] for i = 1:size(rV, 1)]
larET = Lar.cop2lar(rcopEV)
larFE = Lar.cop2lar(rcopFE)


model = (permutedims(rV), [larTT, larET]);
meshes = GL.numbering(1.0)(model, GL.COLORS[1], 0.1);
GL.VIEW(meshes)



copCF = TGW.minimal_3cycles(rV, rcopEV, rcopFE)

######################################################
T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV);
# T, ETs, FTs, CTs = TGW.arrange3D(V, EV, FV)
GL.VIEW(GL.GLExplode(T, ETs, 1.1, 1.1, 1.1, 99, 1));
GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1));
for i = 1:length(CTs)
    GL.VIEW(GL.GLExplode(T, [CTs[i]], 1.1, 1.1, 1.1, 99, 0.2))
end


TGW.biconnected_components(rcopFE)
