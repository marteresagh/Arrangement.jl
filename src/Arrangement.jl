module Arrangement

    using Common
    using Triangulate
    using IntervalTrees
    using DataStructures
    using NearestNeighbors
    # using LinearAlgebraicRepresentation
    # Lar = LinearAlgebraicRepresentation
    # using ViewerGL
    # GL = ViewerGL
    #
    include("utils/bbox.jl")
    include("utils/boundary.jl")
    include("utils/build.jl")
    include("utils/triangulate.jl")
    include("utils/utilities.jl")
    # include("visualization.jl")
    #
    #
    # 2D
    include("2D/biconnected_components.jl")
    include("2D/component_graph.jl")
    include("2D/cycle_basis.jl")
    include("2D/main.jl")
    include("2D/planar_graph.jl")
    include("2D/point_in_face.jl")
    include("2D/cell_merging.jl")
    include("2D/clean_decomposition.jl")
    #
    #
    # # 3D
    # include("3D/main.jl")
    # include("3D/intersection.jl")
    # include("3D/cycle_basis.jl")
    #
    #
    # export Lar, GL
end # module
