using Arrangement
using Visualization

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

Visualization.VIEW([Visualization.GLLines(V, EV)])

T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)


Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));

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

Visualization.VIEW([Visualization.GLGrid(V, FV)])
Visualization.VIEW([Visualization.GLLines(V, EV)])
T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)


Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));
