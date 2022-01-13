using Common
using Visualization
using Arrangement


V = [
        1.0 0.0 9.0 4.0 2.0 7.0 11.0 16.0 15.0 25.0 9.0 14.0 12.0 19.0 23.0 27.0 29.0 33.0 33.0 37.0 33.0 41.0 41.0 35.0 39.0 38.0 32.0 28.0 25.0 26.0 23.0
        17.0 10.0 10.0 12.0 11.0 16.0 18.0 10.0 16.0 17.0 5.0 5.0 11.0 4.0 6.0 3.0 14.0 17.0 10.0 18.0 4.0 4.0 10.0 5.0 5.0 9.0 11.0 11.0 14.0 12.0 13.0
]
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


Visualization.VIEW([ Visualization.GLLines(V,EV) ])

T,ET,FTs = Arrangement.find_cycles(V,EV)
Visualization.VIEW([ Visualization.GLLines(T,ET) ])
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.2,1.2,1.2,99,1));

V = [1 6. 14 11  3 20  19 24 27 28 30;
     6 1  7  11 11  1  11  1  5  1  2]

EV = [[1,2],[2,3],[3,4],[4,5],[1,5],[2,6],[6,7],[7,4],[8,10],[8,9],[9,10], [10,11]]
Visualization.VIEW([ Visualization.GLLines(V,EV) ])
T,ET,FTs = Arrangement.find_cycles(V,EV)
Visualization.VIEW([ Visualization.GLLines(T,ET) ])
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.2,1.2,1.2,99,1));


######################### intersezioni facce nel 3D

V = [
    0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.5 0.5 0.5 0.5 3.0 3.0 3.0 3.0
    0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.5 0.5 1.5 1.5 0.5 0.5 1.5 1.5
    0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 1.5 0.5 1.5 0.5 1.5 0.5 1.5
]

VV = [[i] for i in 1:size(V,2)]

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
    [4, 8],
    [9, 10],
    [11, 12],
    [13, 14],
    [15, 16],
    [9, 11],
    [10, 12],
    [13, 15],
    [14, 16],
    [9, 13],
    [10, 14],
    [11, 15],
    [12, 16],
]

FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [1, 2, 5, 6],
    [3, 4, 7, 8],
    [1, 3, 5, 7],
    [2, 4, 6, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16],
    [9, 10, 13, 14],
    [11, 12, 15, 16],
    [9, 11, 13, 15],
    [10, 12, 14, 16],
]

Visualization.VIEW([
    Visualization.GLFrame,
    Visualization.GLLines(V,EV),
]);

rV, rcopEV, rcopFE = Arrangement.my_arrangement_3D(V,EV,FV)
T, ET, ETs, FTs = Arrangement.get_topology3D(rV, rcopEV, rcopFE)

Visualization.VIEW([ Visualization.GLLines(T,ET) ])
Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.4, 1.4, 1.4, 99, 1));
