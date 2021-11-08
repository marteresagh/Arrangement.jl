using PyCall
using TGW

function read_DXF(filename::String)
    py"""
	import ezdxf
	import numpy as np

	def read(filename):
		doc = ezdxf.readfile(filename)
		msp = doc.modelspace()
		lines = msp.query('LINE[layer=="Lines"]')
		list=[]
		for line in lines:
			lin = []
			lin.append(np.array(line.dxf.start))
			lin.append(np.array(line.dxf.end))
			list.append(np.array(lin))

		return list

	"""

	LINES = py"read"(filename)
    V = permutedims(vcat(hcat.(LINES)...))[1:2,:]
    EV = [[i,i+1] for i in range(1, size(V,2), step=2)]
	return V,EV

end

filename = raw"C:\Users\marte\Documents\GEOWEB\TEST\sezione_casaletto_pianoterra_poligoni_chiusi.dxf"
filename = raw"C:\Users\marte\Documents\GEOWEB\TEST\sezione_stanza.dxf"

V,EV = read_DXF(filename)

GL.VIEW([GL.GLGrid(V,EV)])

W,EW = Lar.fragmentlines((V,EV))
WW = [[k] for k=1:size(W,2)]
GL.VIEW( GL.numbering(1.)((W,[WW, EW]),GL.COLORS[1]) )

T,FTs,ETs = TGW.arrange2D(V,EV)

GL.VIEW(GL.GLExplode(T,ETs,1.,1.,1.,99,1));

GL.VIEW(GL.GLExplode(T,FTs,1.,1.,1.,99,1));
