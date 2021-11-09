using Arrangement
using Visualization

include("problem_model.jl")

T, ETs, FTs = Arrangement.arrange2D(V,EV)
Visualization.VIEW(Visualization.GLExplode(T,FTs,1.2,1.2,1.2,99,1));
