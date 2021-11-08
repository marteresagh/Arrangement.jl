using TGW
function randombubbles()
	store = []
	mycircle(r,n) = Lar.circle(r)([n])
	for k=1:10
		r = rand(1:20)
		n = abs(rand(Int8)+1)
		scale = Lar.s(0.25,0.25)
		transl = Lar.t(5*rand(2)...)
		s = Lar.Struct([ transl, scale, mycircle(r,n) ])
		push!(store, Lar.struct2lar(s))
	end
	s = Lar.Struct(store)
	V,EV = Lar.struct2lar(s)
	# V = GL.normalize2(V)
	GL.VIEW([ GL.GLLines(V,EV) ])

	return V,EV
end

# ////////////////////////////////////////////////////////////
# generation of 2D arrangement
V,EV = randombubbles()

# W,EW = Lar.fragmentlines((V,EV))
T,ETs,FTs = TGW.arrange2D(V,EV)

# native OpenGL visualization
GL.VIEW(GL.GLExplode(T,FTs,1.2,1.2,1.2,99,1));
