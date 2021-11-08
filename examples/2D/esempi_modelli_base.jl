using TGW

# TEST 1
V = [0. 2 2 0 1 3 3 1;
	 1. 1 3 3 0 0 2 2]
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
GL.VIEW([ GL.GLLines(V,EV) ])
T,ET = TGW.get_intersection(V,EV)
W,EW = TGW.get_intersection_old(V,EV)
WW = [[k] for k=1:size(W,2)]
model = (W, [WW,EW]);
meshes = GL.numbering(1.5)(model, GL.COLORS[1], 0.1);
GL.VIEW(meshes)
# W, EWs, FWs =
n, containment_graph, Z, EZs, boundaries, shells, shell_bboxes = TGW.arrange2D(W,EW)
GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));

T, FTs, ETs, copET, copFE = TGW.arrange2D(V,EV)
W, FWs, EWs, copET, copFE = TGW.tgw2d(V,EV)

# TEST 2
V = [0. 3 3 0 3 6 6 ;
	 3. 3 6 6 0 0 3 ]
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,2],[2,5]]
GL.VIEW([ GL.GLLines(V,EV) ])
T,ET = TGW.get_intersection(V,EV)
W,EW = TGW.get_intersection_old(V,EV)

T, FTs, ETs, copET, copFE = TGW.arrange2D(V,EV)
W, FWs, EWs, copET, copFE = TGW.tgw2d(V,EV)
GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));



# TEST 3
V = [0. 3 6 6 3 0 3 3;
	 0. 0 0 3 3 3 0 3]
EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],[5,2],[7,8]]
GL.VIEW([ GL.GLLines(V,EV) ])
T,ET = TGW.get_intersection(V,EV)
W,EW = TGW.get_intersection_old(V,EV)

T, FTs, ETs, copET, copFE = TGW.arrange2D(V,EV)
W, FWs, EWs, copET, copFE = TGW.tgw2d(V,EV)
GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));

# TEST 4
V = [0. 3 6 6 3 0 0. 3 6;
	 0. 0 0 3 3 3 6  6 6]
EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],[5,2],[4,9],[9,8],[8,7],[7,6],[8,5]]
GL.VIEW([ GL.GLLines(V,EV) ])
T,ET = TGW.get_intersection(V,EV)
W,EW = TGW.get_intersection_old(V,EV)

T, FTs, ETs, copET, copFE = TGW.arrange2D(V,EV)
W, FWs, EWs, copET, copFE = TGW.tgw2d(V,EV)
GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));

# TEST 5
V = [0. 2 2 0 1 3 3 1;
	 1. 1 3 3 -1 -1 1 1]
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
GL.VIEW([ GL.GLLines(V,EV) ])

T,ET = TGW.get_intersection(V,EV)
W,EW = TGW.get_intersection_old(V,EV)
GL.VIEW([ GL.GLLines(T,ET) ])

T, FTs, ETs, copET, copFE = TGW.arrange2D(V,EV)
W, FWs, EWs, copET, copFE = TGW.tgw2d(V,EV)

GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));

# TEST 6
V = [0. 2 2 0 1 2.3 1.3 -1;
	 1. 1 3 3 0 3 0 3]
EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[7,8]]
GL.VIEW([ GL.GLLines(V,EV) ])

T,ET = TGW.get_intersection(V,EV)
W,EW = TGW.get_intersection_old(V,EV)

T, FTs, ETs, copET, copFE = TGW.arrange2D(V,EV)
W, FWs, EWs, copET, copFE = TGW.tgw2d(V,EV)
GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));



function randombubbles(n_shapes)
	store = []
	mycircle(r,n) = Lar.circle(r)([n])
	for k=1:n_shapes
		r = rand(1:20)
		n = rand(3:4)#abs(rand(Int8)+1)
		scale = Lar.s(0.25,0.25)
		transl = Lar.t(5*rand(2)...)
		s = Lar.Struct([ transl, scale, mycircle(r,n) ])
		push!(store, Lar.struct2lar(s))
	end
	s = Lar.Struct(store)
	V,EV = Lar.struct2lar(s)
	# V = GL.normalize2(V)
	# GL.VIEW([ GL.GLLines(V,EV) ])
	return V,EV
end

# //////////////////////////// #
# generation of 2D arrangement #
# //////////////////////////// #
V,EV = randombubbles(10)

open("examples/problem_model.jl","w") do s
	write(s,"V = $V\n\n")
	write(s,"EV = $EV\n\n")
end
# include("../problem_model.jl")
V = vcat(V,zeros(size(V,2))')

T, ETs, FTs = TGW.arrange2D(V,EV)
GL.VIEW([GL.GLExplode(T,FTs,1.2,1.2,1.2,1,0.5)...,GL.GLExplode(W,FWs,1.2,1.2,1.2,2,1)...]);
