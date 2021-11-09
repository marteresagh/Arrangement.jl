"""
    constrained_triangulation2D(V::Common.Points, EV::Common.Cells) -> Common.Cells
"""
function constrained_triangulation2D(V::Common.Points, EV::Common.Cells)
    triin = Triangulate.TriangulateIO()
    triin.pointlist = V
    triin.segmentlist = hcat(EV...)
    (triout, vorout) = Triangulate.triangulate("pQ", triin)
    trias = Array{Int64,1}[c[:] for c in eachcol(triout.trianglelist)]
    return trias
end


"""
 	triangulate2d(V::Common.Points, EV::Common.Cells)
"""
function triangulate2d(V::Common.Points, EV::Common.Cells)
    # data for Constrained Delaunay Triangulation (CDT)
    points = permutedims(V)
    # points_map = Array{Int64,1}(collect(1:1:size(points)[1]))
    # edges_list = convert(Array{Int64,2}, hcat(EV...)')
    # edge_boundary = [true for k=1:size(edges_list,1)] ## dead code !!
    trias = constrained_triangulation2D(V, EV)

    #Triangle.constrained_triangulation(points,points_map,edges_list)
    innertriangles = Array{Int64,1}[]
    for (u, v, w) in trias
        point = (points[u, :] + points[v, :] + points[w, :]) ./ 3
        copEV = lar2cop(EV)
        inner = point_in_face(point, points, copEV)
        if inner
            push!(innertriangles, [u, v, w])
        end
    end
    return innertriangles
end
