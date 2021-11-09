function boundingbox(vertices::Common.Points)
   minimum = mapslices(x->min(x...), vertices, dims=2)
   maximum = mapslices(x->max(x...), vertices, dims=2)
   return minimum, maximum
end

"""
    bbox(vertices::Points)
The axis aligned bounding box of the provided set of n-dim `vertices`.
The box is returned as the couple of `Points` of the two opposite corners of the box.
"""
function bbox(vertices::Common.Points)
    minimum = mapslices(x->min(x...), vertices, dims=1)
    maximum = mapslices(x->max(x...), vertices, dims=1)
    minimum, maximum
end

"""
    bbox_contains(container, contained)
Check if the axis aligned bounding box `container` contains `contained`.
Each input box must be passed as the couple of `Points` standing on the opposite corners of the box.
"""
function bbox_contains(container, contained)
    b1_min, b1_max = container
    b2_min, b2_max = contained
    all(map((i,j,k,l)->i<=j<=k<=l, b1_min, b2_min, b2_max, b1_max))
end


function boxcovering(bboxes, index, tree)
	covers = [[] for k=1:length(bboxes)]
	for (i,boundingbox) in enumerate(bboxes)
		extent = bboxes[i][index,:]
		iterator = IntervalTrees.intersect(tree, tuple(extent...))
		for x in iterator
			append!(covers[i],x.value)
		end
	end
	return covers
end
