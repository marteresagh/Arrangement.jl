using Common
using FileManager
using Visualization
using Detection
using Arrangement


"""
"""
function DrawPlanes(
    planes::Array{Detection.Hyperplane,1};
    box_oriented = true,
)::Common.LAR
    out = Array{Common.Struct,1}()
    for obj in planes
        plane = Common.Plane(obj.direction, obj.centroid)
        if box_oriented
            box = Common.ch_oriented_boundingbox(obj.inliers.coordinates)
        else
            box = Common.AABB(obj.inliers.coordinates)
        end
        cell = Common.getmodel(plane, box)
        push!(out, Common.Struct([cell]))
    end
    out = Common.Struct(out)
    V, EV, FV = Common.struct2lar(out)
    return V, EV, FV
end

"""
"""
function get_planes(hyperplanes)
    planes = Plane[]
    for hyperplane in hyperplanes
        push!(planes, Plane(hyperplane.direction, hyperplane.centroid))
    end
    return planes
end


function planes(
    PLANES::Array{Detection.Hyperplane,1},
    box_oriented = true;
    affine_matrix = Matrix(Common.I, 4, 4),
)

    mesh = []
    for plane in PLANES
        pc = plane.inliers
        V, EV, FV = DrawPlanes([plane]; box_oriented = box_oriented)
        col = Visualization.COLORS[3]
        push!(
            mesh,
            Visualization.GLGrid(
                Common.apply_matrix(affine_matrix, V),
                FV,
                col,
                0.5,
            ),
        )
        # push!(
        #     mesh,
        #     Visualization.points(
        #         Common.apply_matrix(affine_matrix, pc.coordinates);
        #         color = col,
        #         alpha = 0.8,
        #     ),
        # )
    end

    return mesh
end


###########################
source = raw"C:\Users\marte\Documents\potreeDirectory\pointclouds\STANZA_CASALETTO";
folder_proj = raw"C:\Users\marte\Documents\GEOWEB\PROGETTI\CASALETTO"

INPUT_PC = FileManager.source2pc(source, -1)
centroid = Common.centroid(INPUT_PC.coordinates)

my_planes =  Plane[]
# aabbs = AABB[]
# for i in 1:30
#     points = FileManager.load_points(joinpath(folder_proj,"plane_$i.txt"))
#     push!(aabbs,AABB(points))
#     plane = Plane(points)
#     push!(my_planes,plane)
# end

aabb = AABB(INPUT_PC.coordinates)
aabbs = [aabb for i = 1:length(my_planes)]


V, EV, FV = Common.DrawPatches(my_planes, aabbs)
unique!(EV)
unique!(FV)
Visualization.VIEW([
    # Visualization.points(INPUT_PC.coordinates, INPUT_PC.rgbs),
    Visualization.GLGrid(V, EV)
])

# open(raw"C:\Users\marte\Documents\GEOWEB\PROGETTI\CASALETTO\lar_model_planes.jl","w") do f
#           write(f,"V = $V\n\n")
#           write(f,"EV = $EV\n\n")
#           write(f,"FV = $FV\n\n")
# end

# include(raw"C:\Users\marte\Documents\GEOWEB\PROGETTI\CASALETTO\lar_model_planes.jl")

V = Common.approxVal(2).(V)
T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)
@time rV, rcopEV, rcopFE = Arrangement.my_arrangement_3D(V,EV,FV)
@time T, ET, ETs, FTs = Arrangement.get_topology3D(rV, rcopEV, rcopFE)

Visualization.VIEW([ Visualization.GLLines(T,ET) ])
Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.4, 1.4, 1.4, 99, 1));


Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));


############################### riga per riga
# cop_EV = Arrangement.coboundary_0(EV)
# cop_FE = Arrangement.coboundary_1(V, FV, EV)
# W = permutedims(V)
#
# # rV, rcopEV, rcopFE = get_model_intersected(W, cop_EV, cop_FE)
# fs_num = size(cop_FE, 1)
# sp_idx = Arrangement.spatial_index(W, cop_EV, cop_FE)
#
# rV = Common.Points(undef, 0, 3)
# rEV = Common.spzeros(Int8, 0, 0)
# rFE = Common.spzeros(Int8, 0, 0)
#
# depot_V = Array{Array{Float64,2},1}(undef, fs_num)
# depot_EV = Array{Common.ChainOp,1}(undef, fs_num)
# depot_FE = Array{Common.ChainOp,1}(undef, fs_num)
# sigma = 13
# # nV, nEV, nFE = Arrangement.frag_face(W, cop_EV, cop_FE, sp_idx, sigma)
#
# vs_num = size(W, 1)
#
# # 2D transformation of sigma face
# sigmavs = (abs.(cop_FE[sigma:sigma, :])*abs.(cop_EV))[1, :].nzind
# sV = W[sigmavs, :]
# sEV = cop_EV[cop_FE[sigma, :].nzind, sigmavs]
# M = Arrangement.submanifold_mapping(sV)
# tV = ([W ones(vs_num)]*M)[:, 1:3]  # folle convertire *tutti* i vertici
# sV = tV[sigmavs, :]
#
# # sigma face intersection with faces in sp_idx[sigma]
# for i in sp_idx[sigma]
#     global sV, sEV
#     println("faccia che sta intersecando: $i")
#     tmpV, tmpEV = Arrangement.face_int(tV, cop_EV, cop_FE[i, :])
#     sV, sEV = Arrangement.skel_merge(sV, sEV, tmpV, tmpEV)
# end
#
# # computation of 2D arrangement of sigma face
# sV = sV[:, 1:2]
#
# Visualization.VIEW([Visualization.GLGrid(permutedims(sV),Arrangement.cop2lar(sEV))])
#
# nV, nEV, nFE = Arrangement.planar_arrangement(
#     sV,
#     sEV;
#     sigma = Common.sparsevec(ones(Int8, length(sigmavs))),
# )

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

model = (T, ET, ETs, FT, FTs)
W, EW, EWs, FW, FWs = remove_empty_faces(INPUT_PC.coordinates, model)
Visualization.VIEW(Visualization.GLExplode(T, EWs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW([
    # Visualization.GLPoints(permutedims(INPUT_PC.coordinates), Visualization.COLORS[1]),
    Visualization.GLExplode(T, FWs, 1.0, 1.0, 1.0, 99, 1)...,
]);
