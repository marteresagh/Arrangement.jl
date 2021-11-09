using PyCall
using Arrangement

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

Visualization.VIEW([Visualization.GLGrid(V,EV)])

T,ETs,FTs = Arrangement.arrange2D(V,EV)

Visualization.VIEW(Visualization.GLExplode(T,ETs,1.,1.,1.,99,1));

Visualization.VIEW(Visualization.GLExplode(T,FTs,1.,1.,1.,99,1));
