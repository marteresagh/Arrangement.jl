using TGW

function load_points(filename::String)::Lar.Points
    io = open(filename, "r")
    point = readlines(io)
    close(io)

    b = [tryparse.(Float64, split(point[i], " ")) for i = 1:length(point)]
    V = hcat(b...)
    return V
end


function remove_empty_faces(pointcloud, model)
    centroid(points::Lar.Points) = (sum(points, dims = 2)/size(points, 2))[:, 1]
    kdtree = Lar.KDTree(pointcloud)
    T, ET, ETs, FT, FTs = model
    tokeep = Int64[]

    for i = 1:length(FT)
        p1, p2, p3, p4 = FT[i]
        baricentro = centroid(T[:, FT[i]])
        NN = Lar.inrange(kdtree, baricentro, 0.05)
        if length(NN) > 0
            push!(tokeep, i)
        end
    end

    return T, ET, ETs, FT[tokeep], FTs[tokeep]
end


include("lar_model_planes.jl")
include("lar_model_planes_limited.jl")
include("lar_model_planes_limited_esterno_cornici.jl")
include("lar_model_planes_limited_esterno.jl")

V = Lar.approxVal(2).(V)
GL.VIEW([GL.GLGrid(V, EV)])
GL.VIEW([GL.GLGrid(V, FV)])

T, ET, ETs, FT, FTs = TGW.model_intersection(V, EV, FV)


GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
GL.VIEW(GL.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));

GL.VIEW(GL.GLExplode(T, ETs[200:234], 1.0, 1.0, 1.0, 99, 1));
GL.VIEW(GL.GLExplode(T, [ETs[110]], 1.0, 1.0, 1.0, 99, 1));


model = (T, ET, ETs, FT, FTs)
pointcloud =
    load_points(raw"C:\Users\marte\Documents\Julia_package\TGW.jl\examples\3D\esempio_pratico\stanza_ideale_pc.txt")


W, EW, EWs, FW, FWs = remove_empty_faces(pointcloud, model)
GL.VIEW(GL.GLExplode(T, FWs, 1.0, 1.0, 1.0, 99, 1));
GL.VIEW([
    GL.GLPoints(permutedims(pointcloud), GL.COLORS[1]),
    GL.GLExplode(T, FWs, 1.0, 1.0, 1.0, 99, 1)...,
]);


GL.VIEW([GL.GLFrame, GL.GLPoints(permutedims(pc))]);






# DEBUG
# 2 facce, attenzione!!!!

V = [
    0 1 1 0 0.2 0.2 0.2 0.2
    0 0 1 1 0.1 1.2 1.2 0.1
    0 0 0 0 -0.1 -0.1 1 1
]
EV = [
    [1, 2],
    [2, 3],
    [3, 4],
    [1, 4],
    [5, 6],
    [6, 7],
    [7, 8],
    [8, 5],
]
FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
]

GL.VIEW([GL.GLGrid(V, EV), GL.GLFrame])
GL.VIEW([GL.GLGrid(V, FV), GL.GLFrame])
T, ET, ETs, FT, FTs = TGW.model_intersection(V, EV, FV)

GL.VIEW(GL.GLExplode(T, [ETs[1]], 1.0, 1.0, 1.0, 99, 1));

GL.VIEW(GL.GLExplode(T, [FTs[1]], 1.0, 1.0, 1.0, 99, 1));
GL.VIEW(GL.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));


# 1 foro
V = [
    0 1 1 0 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1
    0 0 1 1 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8
    0 0 0 0 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1
]
EV = [
    [1, 2],
    [2, 3],
    [3, 4],
    [1, 4],
    [5, 6],
    [6, 7],
    [7, 8],
    [8, 5],
    [9, 10],
    [10, 11],
    [11, 12],
    [12, 9],
    [13, 14],
    [14, 15],
    [15, 16],
    [16, 13],
    [17, 18],
    [18, 19],
    [19, 20],
    [20, 17],
]
FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16],
    [17, 18, 19, 20],
]

GL.VIEW([GL.GLGrid(V, EV), GL.GLFrame])
GL.VIEW([GL.GLGrid(V, FV), GL.GLFrame])
T, ET, ETs, FT, FTs = TGW.model_intersection(V, EV, FV)

GL.VIEW(GL.GLExplode(T, [ETs[1]], 1.0, 1.0, 1.0, 99, 1));

GL.VIEW(GL.GLExplode(T, [FTs[1]], 1.0, 1.0, 1.0, 99, 1));
GL.VIEW(GL.GLExplode(T, FTs, 1.0, 1.0, 1.0, 99, 1));



# 2 fori
V = [
    0 1 1 0 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0 1 1 0
    0 0 3 3 0.1 0.9 0.9 0.1 0.1 0.9 0.9 0.1 0.2 0.2 0.2 0.2 0.8 0.8 0.8 0.8 2.1 2.9 2.9 2.1 2.1 2.9 2.9 2.1 2.2 2.2 2.2 2.2 2.8 2.8 2.8 2.8 0 0 3 3
    0 0 0 0 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 -0.1 -0.1 1 1 0.8 0.8 0.8 0.8
]
EV = [
    [1, 2],
    [2, 3],
    [3, 4],
    [1, 4],
    [5, 6],
    [6, 7],
    [7, 8],
    [8, 5],
    [9, 10],
    [10, 11],
    [11, 12],
    [12, 9],
    [13, 14],
    [14, 15],
    [15, 16],
    [16, 13],
    [17, 18],
    [18, 19],
    [19, 20],
    [20, 17],
    [21, 22],
    [22, 23],
    [23, 24],
    [24, 21],
    [25, 26],
    [26, 27],
    [27, 28],
    [28, 25],
    [29, 30],
    [30, 31],
    [31, 32],
    [32, 29],
    [37, 38],
    [38, 39],
    [39, 40],
    [40, 37],
]
FV = [
    [1, 2, 3, 4],
    [5, 6, 7, 8],
    [9, 10, 11, 12],
    [13, 14, 15, 16],
    [17, 18, 19, 20],
    [21, 22, 23, 24],
    [25, 26, 27, 28],
    [29, 30, 31, 32],
    [37, 38, 39, 40],
]


GL.VIEW([GL.GLGrid(V, EV), GL.GLFrame])
GL.VIEW([GL.GLGrid(V, FV), GL.GLFrame])
T, ET, ETs, FT, FTs = TGW.model_intersection(V, EV, FV)

GL.VIEW(GL.GLExplode(T, [ETs[52]], 1.0, 1.0, 1.0, 99, 1));

GL.VIEW(GL.GLExplode(T, [FTs[2]], 1.0, 1.0, 1.0, 99, 1));
GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1));
