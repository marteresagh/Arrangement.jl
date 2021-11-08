using TGW

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

######### per ogni faccia eliminare quelle con almeno un bordo
for i in 1:size(rcopFE,1)
    println("ciclo for: i $i")
    c_ld = Lar.spzeros(Int8, size(rcopFE,1))
    c_ld[i] = 1
    c_lld = rcopFE'* c_ld
    # trovato il bordo, per ogni elemento del bordo verificare che ci sia almeno un cobordo
    for tau in c_lld.nzind
        println("       ciclo for: tau $tau")
        # tau è il vertice
        # pivot è lo spigolo
        b_ld = rcopFE'[tau, :]
        if  length(b_ld.nzind) ==1 &&  b_ld.nzind[1] == i
            println("           eliminare questa faccia $i")
            break
        end
    end
end

rcopCF = TGW.minimal_3cycles(rV, rcopEV, rcopFE)


######################################################
T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV);
T, ETs, FTs, CTs = TGW.arrange3D(V, EV, FV)
GL.VIEW(GL.GLExplode(T, ETs, 1.1, 1.1, 1.1, 99, 1));
GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1));
for i = 1:length(CTs)
    GL.VIEW(GL.GLExplode(T, [CTs[i]], 1.1, 1.1, 1.1, 99, 0.2))
end
