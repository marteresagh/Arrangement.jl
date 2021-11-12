using Arrangement
using FileManager
using Common
using Visualization

function remove_empty_faces(pointcloud, model)
    centroid(points::Common.Points) = (sum(points, dims = 2)/size(points, 2))[:, 1]
    kdtree = Arrangement.KDTree(pointcloud)
    T, ET, ETs, FT, FTs = model
    tokeep = Int64[]

    for i = 1:length(FT)
        baricentro = centroid(T[:, FT[i]])
        NN = Arrangement.inrange(kdtree, baricentro, 0.05)
        if length(NN) > 0
            push!(tokeep, i)
        end
    end

    return T, ET, ETs, FT[tokeep], FTs[tokeep]
end


include("planes/lar_model_planes_closed_limited.jl")
V = Common.approxVal(2).(V)
# V[3,130] = 3.22
# V[3,144] = 3.22
# V[3,138] = 3.22
# V[3,142] = 3.22
# V[3,134] = 3.22
# V[3,140] = 3.22
# V[3,136] = 3.22
# V[3,132] = 3.22
#
# V[3,129] = -0.52
# V[3,143] = -0.52
# V[3,141] = -0.52
# V[3,137] = -0.52
# V[3,135] = -0.52
# V[3,131] = -0.52
# V[3,133] = -0.52
# V[3,139] = -0.52
#
# V[:,151] = [5.30, -0.08, 3.2]
# V[:,130] = [5.30, -0.08, 3.2]
# V[:,144] = [5.30, -0.08, 3.2]
#
# V[:,142] = [-0.08, -0.08, 3.2]
# V[:,138] = [-0.08, -0.08, 3.2]
# V[:,149] = [-0.08, -0.08, 3.2]
#
# V[:,152] = [5.30, 8.08, 3.2]
# V[:,132] = [5.30, 8.08, 3.2]
# V[:,136] = [5.30, 8.08, 3.2]
#
# V[:,134] = [-0.08, 8.08, 3.2]
# V[:,140] = [-0.08, 8.08, 3.2]
# V[:,150] = [-0.08, 8.08, 3.2]
#
#
#
# V[:,143] = [5.30, -0.08, -0.5]
# V[:,129] = [5.30, -0.08, -0.5]
# V[:,147] = [5.30, -0.08, -0.5]
#
# V[:,131] = [5.30, 8.08, -0.5]
# V[:,135] = [5.30, 8.08, -0.5]
# V[:,148] = [5.30, 8.08, -0.5]
#
# V[:,133] = [-0.08, 8.08, -0.5]
# V[:,139] = [-0.08, 8.08, -0.5]
# V[:,146] = [-0.08, 8.08, -0.5]
#
# V[:,141] = [-0.08, -0.08, -0.5]
# V[:,137] = [-0.08, -0.08, -0.5]
# V[:,145] = [-0.08, -0.08, -0.5]
#
# open(raw"tmp.jl","w") do f
#           write(f,"V = $V\n\n")
# end

Visualization.VIEW([Visualization.GLGrid(V, EV)])
Visualization.VIEW([Visualization.GLGrid(V, FV)])
model = (V,[[[i] for i in 1:size(V,2)],EV,FV])
meshes = Visualization.numbering(.3)(model, Visualization.COLORS[1], 0.1);
Visualization.VIEW(meshes)

T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)


Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));

# Visualization.VIEW(Visualization.GLExplode(T, ETs[200:234], 1.0, 1.0, 1.0, 99, 1));
# Visualization.VIEW(Visualization.GLExplode(T, [ETs[110]], 1.0, 1.0, 1.0, 99, 1));


model = (T, ET, ETs, FT, FTs)
PC =
    FileManager.source2pc(raw"C:\Users\marte\Documents\Julia_package\UTILS\STANZA_IDEALE\stanza_chiusa.las")
pointcloud = PC.coordinates

W, EW, EWs, FW, FWs = remove_empty_faces(pointcloud, model)
Visualization.VIEW(Visualization.GLExplode(T, FWs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW([
    Visualization.GLPoints(permutedims(pointcloud), Visualization.COLORS[1]),
    Visualization.GLExplode(T, FWs, 1.0, 1.0, 1.0, 99, 1)...,
]);
