using Arrangement
using Visualization


# DEBUG
# 2 facce, attenzione!!!!

V = [
    0 1 1 0 0.2 0.2 0.2 0.2
    0 0 1 1 0.1 1.2 1.2 0.1
    0 0 0 0 -0.1 -0.1 1 1
]
EV = [
    [1, 2],
    [2, 3],
    [3, 4],
    [1, 4],
    [5, 6],
    [6, 7],
    [7, 8],
    [8, 5],
]
FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
]

Visualization.VIEW([Visualization.GLGrid(V, EV), Visualization.GLFrame])
Visualization.VIEW([Visualization.GLGrid(V, FV), Visualization.GLFrame])
T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)

Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));


# 1 foro
V = [
    0 1 1 0 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1
    0 0 1 1 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8
    0 0 0 0 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1
]
EV = [
    [1, 2],
    [2, 3],
    [3, 4],
    [1, 4],
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
]
FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16],
    [17, 18, 19, 20],
]

Visualization.VIEW([Visualization.GLGrid(V, EV), Visualization.GLFrame])
Visualization.VIEW([Visualization.GLGrid(V, FV), Visualization.GLFrame])
T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)

Visualization.VIEW(Visualization.GLExplode(T, [ETs[1]], 1.0, 1.0, 1.0, 99, 1));

Visualization.VIEW(Visualization.GLExplode(T, [FTs[1]], 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));



# 2 fori
V = [
    0 1 1 0 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0 1 1 0
    0 0 3 3 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8 2.1 2.9 2.9 2.1 2.1 2.9 2.9 2.1 2.2 2.2 2.2 2.2 2.8 2.8 2.8 2.8 0 0 3 3
    0 0 0 0 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 0.8 0.8 0.8 0.8
]
EV = [
    [1, 2],
    [2, 3],
    [3, 4],
    [1, 4],
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
    [24, 21],
    [25, 26],
    [26, 27],
    [27, 28],
    [28, 25],
    [29, 30],
    [30, 31],
    [31, 32],
    [32, 29],
    [37, 38],
    [38, 39],
    [39, 40],
    [40, 37],
]
FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16],
    [17, 18, 19, 20],
    [21, 22, 23, 24],
    [25, 26, 27, 28],
    [29, 30, 31, 32],
    [37, 38, 39, 40],
]


Visualization.VIEW([Visualization.GLGrid(V, EV), Visualization.GLFrame])
Visualization.VIEW([Visualization.GLGrid(V, FV), Visualization.GLFrame])
T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)

Visualization.VIEW(Visualization.GLExplode(T, [ETs[52]], 1.0, 1.0, 1.0, 99, 1));

Visualization.VIEW(Visualization.GLExplode(T, [FTs[2]], 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
