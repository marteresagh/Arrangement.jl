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
function planes(
    PLANES::Array{Detection.Hyperplane,1},
    box_oriented = true;
    affine_matrix = Matrix(Common.I, 4, 4),
)

    mesh = []
    for plane in PLANES
        pc = plane.inliers
        V, EV, FV = DrawPlanes([plane]; box_oriented = box_oriented)
        col = Visualization.COLORS[rand(1:12)]
        push!(
            mesh,
            Visualization.GLGrid(
                Common.apply_matrix(affine_matrix, V),
                FV,
                col,
                0.5,
            ),
        )
        push!(
            mesh,
            Visualization.points(
                Common.apply_matrix(affine_matrix, pc.coordinates);
                color = col,
                alpha = 0.8,
            ),
        )
    end

    return mesh
end

"""
"""
function load_connected_components(filename::String)::Common.Cells
    EV = Array{Int64,1}[]
    io = open(filename, "r")
    string_conn_comps = readlines(io)
    close(io)

    conn_comps = [
        tryparse.(Float64, split(string_conn_comps[i], " "))
        for i = 1:length(string_conn_comps)
    ]
    for comp in conn_comps
        for i = 1:(length(comp)-1)
            push!(EV, [comp[i], comp[i+1]])
        end
        push!(EV, [comp[end], comp[1]])
    end
    return EV
end

"""
"""
function get_boundary_models(folders)
    n_planes = length(folders)
    boundary = Common.LAR[]
    for i = 1:n_planes
        #println("$i of $n_planes")
        if isfile(joinpath(folders[i], "execution.probe"))
            V = FileManager.load_points(joinpath(
                folders[i],
                "boundary_points3D.txt",
            ))
            EV = load_connected_components(joinpath(
                folders[i],
                "boundary_edges.txt",
            ))
            if length(EV) == 0
                @show i, folders[i]
            else
                model = (V, EV)
                push!(boundary, model)
            end
        end
    end
    return boundary
end

###########################
NAME_PROJ = "STANZA_CASALETTO_LOD3";
source = raw"C:\Users\marte\Documents\potreeDirectory\pointclouds\STANZA_CASALETTO";
folder_proj = raw"C:\Users\marte\Documents\GEOWEB\PROGETTI\CASALETTO"

INPUT_PC = FileManager.source2pc(source, 2)
centroid = Common.centroid(INPUT_PC.coordinates)

folders = Detection.get_plane_folders(folder_proj, NAME_PROJ)

hyperplanes, _ = Detection.get_hyperplanes(folders)

# V, EV, FV = DrawPlanes(hyperplanes[1:50]; box_oriented = false)
#
# Visualization.VIEW([
#     Visualization.points(
#         Common.apply_matrix(Common.t(-centroid...), INPUT_PC.coordinates),
#         INPUT_PC.rgbs,
#     ),
#     Visualization.GLGrid(
#         Common.apply_matrix(Common.t(-centroid...), V),
#         FV,
#         Visualization.COLORS[1],
#         0.8,
#     ),
# ])

# Visualization.VIEW([
#     planes(hyperplanes, false; affine_matrix = Common.t(-centroid...))...,
# ])
#

function get_planes(hyperplanes)
    planes = Plane[]
    for hyperplane in hyperplanes
        push!(planes, Plane(hyperplane.direction, hyperplane.centroid))
    end
    return planes
end

my_planes = get_planes(hyperplanes)

aabb = AABB(INPUT_PC.coordinates)

# aabbs = [AABB(hyperplane.inliers.coordinates) for hyperplane in hyperplanes]
# u = 0.2
# for aabb in aabbs
# 	 aabb.x_max += u
# 	 aabb.x_min  -= u
# 	 aabb.y_max  += u
# 	 aabb.y_min  -= u
# 	 aabb.z_max  += u
# 	 aabb.z_min -= u
# end


# la faccia 13 intersecata con le altre va in loop
INDS = [
    13
    25
    67
    53
    94
    93
    9
    22
    59
    47
    78
    16
    91
    20
    18
    90
    62
    80
    85
    56
    79
    96
    89
    72
    14
    48
    33
    45
    49
    34
    35
    50
    29
    37
    7
    6
    31
    77
    74
    66
    51
    2
    97
    38
    71
    76
    82
    23
    87
    63
    86
    28
    54
    57
    98
    100
    12
    26
    19
    46
    99
    27
    69
    73
    32
    64
    52
    5
    3
    61
    95
    30
    10
    92
    43
    39
    60
    83
    24
    8
    70
    58
    40
    44
    81
    41
    88
    65
    75
    21
    84
    36
    55
    11
    4
]

aabbs = [aabb for i = 1:length(my_planes[INDS])]
V, EV, FV = Common.DrawPatches(my_planes[INDS], aabbs)
EV = unique(EV)
FV = unique(FV)
Visualization.VIEW([
    Visualization.GLGrid(V, FV)
    Visualization.GLGrid(V, [FV[1]], Visualization.COLORS[2])
])

# open(raw"C:\Users\marte\Documents\GEOWEB\PROGETTI\CASALETTO\lar_model_planes.jl","w") do f
#           write(f,"V = $V\n\n")
#           write(f,"EV = $EV\n\n")
#           write(f,"FV = $FV\n\n")
# end

# include(raw"C:\Users\marte\Documents\GEOWEB\PROGETTI\CASALETTO\lar_model_planes.jl")

V = Common.approxVal(2).(V)
T, ET, ETs, FT, FTs = Arrangement.model_intersection(V, EV, FV)


Visualization.VIEW(Visualization.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
Visualization.VIEW(Visualization.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));
