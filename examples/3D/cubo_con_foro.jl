using Arrangement
using Visualization

### Esempio cubo con foro sulla faccia
### la base di cicli viene calcolata bene ma il programma sembra non essere concluso

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

T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)


Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.4, 1.4, 1.4, 99, 1));
