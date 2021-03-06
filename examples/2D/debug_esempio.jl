using Arrangement
using Visualization
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

T, ETs, FTs = Arrangement.arrange2D(V,EV)
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.3,1.3,1.3,99,1));
Visualization.VIEW(Visualization.GLExplode(T,ETs,1.3,1.3,1.3,99,1));


V = [0. 4. 4. 0. 4. 3. 2. 1.;
         0. 0. 4. 4. 2. 3. 1. 1.]
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,5],[6,8],[7,8]]
Visualization.VIEW([ Visualization.GLLines(V,EV) ])

T, ETs, FTs = Arrangement.arrange2D(V,EV)
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.3,1.3,1.3,99,1));
Visualization.VIEW(Visualization.GLExplode(T,ETs,1.3,1.3,1.3,99,1));
