using Arrangement
using FileManager
using Common

function remove_empty_faces(pointcloud, model)
    centroid(points::Common.Points) =
        (sum(points, dims = 2)/size(points, 2))[:, 1]
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

include("lar_model_planes_rotate.jl")
include("lar_model_planes_limited_rotate.jl")
V = Common.approxVal(2).(V)
Visualization.VIEW([Visualization.GLGrid(V, EV)])
Visualization.VIEW([Visualization.GLGrid(V, FV)])

T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)


Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));

# Visualization.VIEW(Visualization.GLExplode(T, ETs[200:234], 1.0, 1.0, 1.0, 99, 1));
# Visualization.VIEW(Visualization.GLExplode(T, [ETs[110]], 1.0, 1.0, 1.0, 99, 1));


model = (T, ET, ETs, FT, FTs)
pointcloud =
    FileManager.load_points(raw"C:\Users\marte\Documents\Julia_package\TGW.jl\examples\3D\esempio_pratico\stanza_ideale_pc.txt")

ROTO = Common.r(0, 0, pi / 3)
ROTATE_PC = Common.apply_matrix(ROTO, pointcloud)
W, EW, EWs, FW, FWs = remove_empty_faces(ROTATE_PC, model)
Visualization.VIEW(Visualization.GLExplode(T, FWs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW([
    Visualization.GLPoints(permutedims(ROTATE_PC), Visualization.COLORS[1]),
    Visualization.GLExplode(T, FWs, 1.0, 1.0, 1.0, 99, 1)...,
]);
