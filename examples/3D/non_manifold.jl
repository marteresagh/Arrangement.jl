using TGW

### Esempio cubo con componente non_manifold
### intersezione va a buon fine
### la ricerca nella base di cicli va in loop

V = [
    0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.0 0.0 1.5 1.5 1.0 1.0
    0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.0 0.0 1.0 1.0 1.5 1.5
    0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 1.5 0.5 1.5 0.5 1.5
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
VV = [[i] for i in 1:size(V,2)]

GL.VIEW([
    GL.GLFrame,
    GL.GLLines(V,EV),
]);


##############  calcolo delle intersezioni
cop_EV = Lar.coboundary_0(EV)
cop_FE = Lar.coboundary_1(V, FV, EV)
W = permutedims(V)
T,ET,FE = TGW.get_model_intersected(W, cop_EV, cop_FE)

larTT = [[i] for i in 1:size(T,1)]
larET = Lar.cop2lar(ET)
larFE = Lar.cop2lar(FE)


model = (permutedims(T), [larTT, larET]);
meshes = GL.numbering(1.0)(model, GL.COLORS[1], 0.1);
GL.VIEW(meshes)


############ spigoli per ogni faccia
ETs = Lar.FV2EVs(ET, FE)
GL.VIEW(GL.GLExplode(permutedims(T), ETs, 1.1, 1.1, 1.1, 99, 1));


########## base di cicli
bicon = TGW.biconnected_components(ET)
CF = TGW.minimal_3cycles(T,ET,FE) # va in loop perche non le cerca per componenti biconnesse separate perche questa è una unica componente in effetti
#### come si risolve questa cosa?

################### faccia per ogni cella
FTs = Lar.FV2EVs(FE, CF)


T0, CVs, FVs, EVs = Lar.pols2tria(permutedims(T), ET, FE, rcopCF[[1,3],:]) # whole assembly
GL.VIEW(GL.GLExplode(T0, CVs, 1.1, 1.1, 1.1, 99, 1));
