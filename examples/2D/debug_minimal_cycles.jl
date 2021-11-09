using Arrangement
using Visualization

V = [
    0.0 2 2 0 1 3 3 1
    1.0 1 3 3 0 0 2 2
]
# V = [
#     0.0 4.0 4.0 0.0 4.0 3.0 2.0
#     0.0 0.0 4.0 4.0 2.0 3.0 1.0
# ]
VV = [[k] for k = 1:size(V, 2)]
EV = [[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 8], [8, 5]]
# EV = [[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 5]]
T, ET = Arrangement.get_planar_graph(V, EV)
TT = [[k] for k = 1:size(T, 2)]
model = (T, [TT, ET]);
meshes = Visualization.numbering(2.0)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)
####### algoritmo

##################### altri esempi da verificare la verità dell'algoritmo
V = [
    0.0 4.0 4.0 0.0 4.0 3.0 2.0
    0.0 0.0 4.0 4.0 2.0 3.0 1.0
]

VV = [[k] for k = 1:size(V, 2)]

EV = [[1, 2], [2, 3], [3, 4], [4, 1], [5, 6], [6, 7], [7, 5]]

V = [
    0.0 10 10 0.0 1.0 9.0 9.0 1.0 2.0 8.0 8.0 2.0
    0.0 0.0 10 10 1.0 1.0 9.0 9.0 2.0 2.0 8.0 8.0
]
VV = [[k] for k = 1:size(V, 2)]

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
]
# model = (V, [VV, EV]);
# meshes = GL.numbering(2.0)(model, GL.COLORS[1], 0.1);
# GL.VIEW(meshes)

T, ET = Arrangement.get_planar_graph(V, EV)

TT = [[k] for k = 1:size(T, 2)]

model = (T, [TT, ET]);
meshes = Visualization.numbering(2.0)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)
