using Arrangement
using FileManager
using Common


pointcloud =
    FileManager.load_points(raw"C:\Users\marte\Documents\Julia_package\TGW.jl\examples\3D\esempio_pratico\stanza_ideale_pc.txt")
ROTO = Common.r(0,0,pi/3)

ROTATE_PC = Common.apply_matrix(ROTO, pointcloud)
Visualization.VIEW([Visualization.GLFrame,Visualization.points(ROTATE_PC)])

PC = FileManager.source2pc(raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\stanza_ideale.las")

# FileManager.save_points_txt(raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\pc.txt",PC.coordinates)

# txt prima riga   normal
# 	 seconda riga  centroid

CORNICI = raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\PLANES\CORNICI"
INTERNO = raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\PLANES\INTERNO"
ESTERNO = raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\PLANES\ESTERNO"
output_folder_cornici = raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\ROTATE\CORNICI"
output_folder_interno = raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\ROTATE\INTERNO"
output_folder_esterno = raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\ROTATE\ESTERNO"


function rotate_planes(path_folder::String, output_folder::String)
	ROTO = Common.r(0,0,pi/3)
	files = readdir(path_folder)
	for file in files
		if endswith(file,".txt")
			fname = Base.split(splitdir(file)[2], ".")[1]
			las_file = joinpath(path_folder,fname*".las")
			txt_file = joinpath(path_folder,fname*".txt")
			PC = FileManager.las2pointcloud(las_file)
			V = Common.apply_matrix(ROTO, PC.coordinates)
			plane = Common.Plane(V)
			ROTATE_PC = Common.PointCloud(V, PC.rgbs)
			FileManager.save_pointcloud(joinpath(output_folder,fname*".las"),ROTATE_PC,"rotate")
			open(joinpath(output_folder,fname*".txt"),"w") do s
				write(s, "$(plane.normal[1]) $(plane.normal[2]) $(plane.normal[3])\n")
				write(s, "$(plane.centroid[1]) $(plane.centroid[2]) $(plane.centroid[3])")
			end
		end
	end
end

rotate_planes(ESTERNO,output_folder_esterno)



########################################  ROTATE
using Detection
function get_planes(path_folder::String)
	files = readdir(path_folder)
	hyperplanes = Detection.Hyperplane[]
	planes = Plane[]
	for file in files
		if endswith(file,".txt")
			fname = Base.split(splitdir(file)[2], ".")[1]
			las_file = joinpath(path_folder,fname*".las")
			txt_file = joinpath(path_folder,fname*".txt")
			vectors_string = readlines(txt_file)
			vectors = [tryparse.(Float64,split(vectors_string[i], " ")) for i in 1:length(vectors_string)]
			PC = FileManager.las2pointcloud(las_file)
			push!(hyperplanes, Detection.Hyperplane(PC, vectors[1], vectors[2]))
			push!(planes, Plane(vectors[1],vectors[2]))
		end
	end
	return hyperplanes, planes
end

cornici_hyperplanes, cornici_planes = get_planes(output_folder_cornici)

interno_hyperplanes, interno_planes = get_planes(output_folder_interno)

esterno_hyperplanes, esterno_planes = get_planes(output_folder_esterno)

hyperplanes = union(cornici_hyperplanes,interno_hyperplanes,esterno_hyperplanes)

planes = union(cornici_planes,interno_planes,esterno_planes)

aabb =  Common.AABB(ROTATE_PC)
V,EV,FV = Common.DrawPlanes(planes,aabb)

aabbs = [AABB(hyperplane.inliers.coordinates) for hyperplane in hyperplanes]
u = 0.02
for aabb in aabb
	 aabb.x_max += u
	 aabb.x_min  -= u
	 aabb.y_max  += u
	 aabb.y_min  -= u
	 aabb.z_max  += u
	 aabb.z_min -= u
end
aabbs = [aabb for i in 1:length(planes)]
V,EV,FV = Common.DrawPatches(planes,aabbs)
Visualization.VIEW([Visualization.GLGrid(V,EV)])

EV = unique(EV)
FV = unique(FV)
open(raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\lar_model_planes_rotate.jl","w") do f
          write(f,"V = $V\n\n")
          write(f,"EV = $EV\n\n")
          write(f,"FV = $FV\n\n")
end
