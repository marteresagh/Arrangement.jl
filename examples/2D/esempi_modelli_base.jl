using Arrangement
using Visualization


# TEST 1
V = [0. 2 2 0 1 3 3 1;
	 1. 1 3 3 0 0 2 2]
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
Visualization.VIEW([ Visualization.GLLines(V,EV) ])
T,ET = Arrangement.get_planar_graph(V,EV)
TT = [[k] for k=1:size(T,2)]
model = (T, [TT,ET]);
meshes = Visualization.numbering(1.5)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)
T, ETs, FTs = Arrangement.arrange2D(V,EV)
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.,1.,1.,99,1));

# TEST 2
V = [0. 3 3 0 3 6 6 ;
	 3. 3 6 6 0 0 3 ]
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,2],[2,5]]
Visualization.VIEW([ Visualization.GLLines(V,EV) ])
T,ET = Arrangement.get_planar_graph(V,EV)
TT = [[k] for k=1:size(T,2)]
model = (T, [TT,ET]);
meshes = Visualization.numbering(1.5)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)
T, ETs, FTs = Arrangement.arrange2D(V,EV)
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.,1.,1.,99,1));

# TEST 3
V = [0. 3 6 6 3 0 3 3;
	 0. 0 0 3 3 3 0 3]
EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],[5,2],[7,8]]
Visualization.VIEW([ Visualization.GLLines(V,EV) ])
T,ET = Arrangement.get_planar_graph(V,EV)
TT = [[k] for k=1:size(T,2)]
model = (T, [TT,ET]);
meshes = Visualization.numbering(1.5)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)
T, ETs, FTs = Arrangement.arrange2D(V,EV)
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.,1.,1.,99,1));

# TEST 4
V = [0. 3 6 6 3 0 0. 3 6;
	 0. 0 0 3 3 3 6  6 6]
EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],[5,2],[4,9],[9,8],[8,7],[7,6],[8,5]]
Visualization.VIEW([ Visualization.GLLines(V,EV) ])
T,ET = Arrangement.get_planar_graph(V,EV)
TT = [[k] for k=1:size(T,2)]
model = (T, [TT,ET]);
meshes = Visualization.numbering(1.5)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)
T, ETs, FTs = Arrangement.arrange2D(V,EV)
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.,1.,1.,99,1));

# TEST 5
V = [0. 2 2 0 1 3 3 1;
	 1. 1 3 3 -1 -1 1 1]
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
Visualization.VIEW([ Visualization.GLLines(V,EV) ])
T,ET = Arrangement.get_planar_graph(V,EV)
TT = [[k] for k=1:size(T,2)]
model = (T, [TT,ET]);
meshes = Visualization.numbering(1.5)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)
T, ETs, FTs = Arrangement.arrange2D(V,EV)
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.,1.,1.,99,1));

# TEST 6
V = [0. 2 2 0 1 2.3 1.3 -1;
	 1. 1 3 3 0 3 0 3]
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[7,8]]
Visualization.VIEW([ Visualization.GLLines(V,EV) ])
T,ET = Arrangement.get_planar_graph(V,EV)
TT = [[k] for k=1:size(T,2)]
model = (T, [TT,ET]);
meshes = Visualization.numbering(1.5)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)
T, ETs, FTs = Arrangement.arrange2D(V,EV)
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.,1.,1.,99,1));
