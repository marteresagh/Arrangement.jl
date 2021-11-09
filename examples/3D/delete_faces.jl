using Arrangement
using Visualization

V = [
    0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 -2.0 -2.0 3.0 3.0 1.0 1.0
    0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 -2.0 -2.0 1.0 1.0 3.0 3.0
    0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0
]

EV = [
    [9, 10],
    [11, 12],
    [13, 14],
    [9, 11],
    [9, 13],
    [10, 12],
    [10, 14],
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
    [9, 10, 11, 12],
    [9, 10, 13, 14],
]
Visualization.VIEW([Visualization.GLLines(V, EV)])
#
# V = [
#     0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 -2.0 -2.0 3.0 3.0 1.0 1.0
#     0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 -2.0 -2.0 1.0 1.0 3.0 3.0
#     0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0  0.0  2.0 0.0 2.0 0.0 2.0
# ]
#
# EV = [
#     [9,10],
#     [11,12],
#     [13,14],
#     [9,11],
#     [9,13],
#     [10,12],
#     [10,14],
#     [1, 2],
#     [3, 4],
#     [5, 6],
#     [7, 8],
#     [1, 3],
#     [2, 4],
#     [5, 7],
#     [6, 8],
#     [1, 5],
#     [2, 6],
#     [3, 7],
#     [4, 8],
# ]
#
# FV = [
#     [1, 2, 3, 4],
#     [5, 6, 7, 8],
#     [1, 2, 5, 6],
#     [3, 4, 7, 8],
#     [1, 3, 5, 7],
#     [2, 4, 6, 8],
#     [9,10,11,12],
#     [9,10,13,14]
#
# ]
Visualization.VIEW([Visualization.GLLines(V, EV)])
########################################################
### codice riga per riga

cop_EV = Lar.coboundary_0(EV)
cop_FE = Lar.coboundary_1(V, FV, EV)
W = permutedims(V)

rV, rcopEV, rcopFE = TGW.get_model_intersected(W, cop_EV, cop_FE)


larTT = [[i] for i = 1:size(rV, 1)]
larET = Lar.cop2lar(rcopEV)
larFE = Lar.cop2lar(rcopFE)


model = (permutedims(rV), [larTT, larET]);
meshes = Visualization.numbering(1.0)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)
#
# FV = [[1, 3, 5, 7]
#  [2, 4, 6, 7]
#  [8, 10, 12, 14]
#  [9, 11, 13, 14]
#  [1, 15, 17, 19]
#  [8, 16, 18, 19]
#  [2, 20, 22, 24]
#  [9, 21, 23, 24]
#  [3, 11, 15, 21, 25, 26]
#  [4, 20, 25]
#  [10, 16, 26]
#  [5, 13, 17, 23, 27, 28]
#  [6, 22, 27]
#  [12, 18, 28]
#  [19, 29, 31, 33]
#  [14, 30, 32, 34]
#  [14, 19, 26, 28]
#  [7, 29, 36, 38]
#  [24, 35, 37, 39]
#  [7, 24, 25, 27]
# #
# # angles = [
# #     1:[1, 5],
# #     2:[7, 2],
# #     3:[9, 1],
# #     4:[2, 10],
# #     5:[1, 12],
# #     6:[13, 2],
# #     7:[2, 20, 1, 18],
# #     8:[3, 6],
# #     9:[4, 8],
# #     10:[3, 11],
# #     11:[4, 9],
# #     12:[3, 14],
# #     13:[4, 12],
# #     14:[4, 16, 3, 17],
# #     15:[5, 9],
# #     16:[6, 11],
# #     17:[5, 12],
# #     18:[6, 14],
# #     19:[17, 6, 15, 5],
# #     20:[10, 7],
# #     21:[8, 9],
# #     22:[7, 13],
# #     23:[12, 8],
# #     24:[19, 8, 20, 7],
# #     25:[9, 20, 10],
# #     26:[17, 11, 9],
# #     27:[20, 12, 13],
# #     28:[14, 17, 12],
# #     29:[18, 15],
# #     30:[16],
# #     31:[15],
# #     32:[16],
# #     33:[15],
# #     34:[16],
# #     35:[19],
# #     36:[18],
# #     37:[19],
# #     38:[18],
# #     39:[19],
# # ]
# #

######### per ogni faccia eliminare quelle con almeno un bordo
for i in 1:20
    println("ciclo for: i $i")
    c_ld = Lar.spzeros(Int8, 20)
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


rcopFV = rcopFE * rcopFE'

M_1 = characteristicMatrix(EV)
M_2 = characteristicMatrix(FV)

∂_2 = (rcopEV * rcopFE) .÷ 2

S1 = sum(∂_2,dims=2)

outer = [k for k=1:length(S1) if S1[k]==1]
return EV[outer]




rcopCF = TGW.minimal_3cycles(rV, rcopEV, rcopFE)

######################################################
T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV);
T, ETs, FTs, CTs = TGW.arrange3D(V, EV, FV)
Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.1, 1.1, 1.1, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1));
for i = 1:length(CTs)
    Visualization.VIEW(Visualization.GLExplode(T, [CTs[i]], 1.1, 1.1, 1.1, 99, 0.2))
end


# TODO quale ciclo chiude e quale va in loop ????
