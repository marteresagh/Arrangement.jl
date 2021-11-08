using TGW

V = [
        1.0 0.0 9.0 4.0 2.0 7.0 11.0 16.0 15.0 25.0 9.0 14.0 12.0 19.0 23.0 27.0 29.0 33.0 33.0 37.0 33.0 41.0 41.0 35.0 39.0 38.0 32.0 28.0 25.0 26.0 23.0
        17.0 10.0 10.0 12.0 11.0 16.0 18.0 10.0 16.0 17.0 5.0 5.0 11.0 4.0 6.0 3.0 14.0 17.0 10.0 18.0 4.0 4.0 10.0 5.0 5.0 9.0 11.0 11.0 14.0 12.0 13.0
]

VV = [[k] for k = 1:size(V, 2)]

EV = [
        [1, 2],
        [2, 3],
        [3, 4],
        [4, 5],
        [3, 6],
        [1, 6],
        [6, 7],
        [7, 9],
        [8, 9],
        [8, 10],
        [9, 10],
        [11, 12],
        [12, 13],
        [11, 13],
        [8, 19],
        [19, 18],
        [17, 18],
        [10, 17],
        [10, 29],
        [29, 30],
        [30, 31],
        [29, 31],
        [17, 28],
        [27, 28],
        [17, 27],
        [20, 19],
        [18, 20],
        [14, 15],
        [15, 16],
        [19, 21],
        [21, 22],
        [22, 23],
        [23, 19],
        [21, 24],
        [24, 25],
        [25, 26],
        [24, 26],
]

model = (V, [VV, EV]);
meshes = GL.numbering(2.0)(model, GL.COLORS[1], 0.1);
GL.VIEW(meshes)

T, ETs, FTs = TGW.arrange2D(V,EV)

GL.VIEW(GL.GLExplode(T,FTs,1.7,1.7,1.7,99,1));

##### CODICE PAOLUZZI
copEV = Lar.lar2cop(EV)
copV = permutedims(V)
bicon_comps = TGW.biconnected_components(copEV)

n_of_comps,containment_graph, T, ETs, boundaries, shells, shell_bboxes = TGW.componentgraph(copV, copEV, bicon_comps)
@time TGW.componentgraph(copV, copEV, bicon_comps)
cop_EV, cop_FE = TGW.cell_merging(
                                n_of_comps,
                                containment_graph,
                                T,
                                ETs,
                                boundaries,
                                shells,
                                shell_bboxes,
                                )

@time T,copET,CopFE = TGW.planar_tgw(copV, copEV, bicon_comps)


##### CODICE GRAPH
T, ET = TGW.get_planar_graph(V, EV)
TT = [[k] for k = 1:size(T, 2)]
model = (T, [TT, ET]);
meshes = GL.numbering(2.0)(model, GL.COLORS[1], 0.1);
GL.VIEW(meshes)

graph = TGW.model2graph(T,ET)
cyc_bas = TGW.cycle_basis(graph)
