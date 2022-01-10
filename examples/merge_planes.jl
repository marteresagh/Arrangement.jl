using Common
using Detection

function refine_planes!(hyperplanes)
    n_segments = length(hyperplanes)

    avg_max_dist = 0
    for i = 1:n_segments
        s = hyperplanes[i]
        max_dist = -Inf
        for j = 1:s.inliers.n_points
            point = s.inliers.coordinates[:, j]
            dist = Common.distance_point2plane(s.centroid, s.direction)(point)
            max_dist = max(max_dist, dist)
        end
        avg_max_dist += max_dist
    end

    avg_max_dist /= n_segments
    # avg_max_dist /= 2.0

    theta = pi * 10 / 180

    merged = true
    while merged
        sort!(hyperplanes, by = x -> x.inliers.n_points) #sort! hyperplanes according to their size
        n_segments = length(hyperplanes)
        @show "nuovo loop"
        @show  n_segments
        merged = false
        for i = 1:n_segments
            s1 = hyperplanes[i]
            n1 = s1.direction
            num_threshold = s1.inliers.n_points / 5.0

            for j = i+1:n_segments
                s2 = hyperplanes[j]
                n2 = s2.direction

                if Common.abs(Common.dot(n1, n2)) > Common.cos(theta)
                    set1on2 = number_of_points_on_plane(s1, s2, avg_max_dist)
                    set2on1 = number_of_points_on_plane(s2, s1, avg_max_dist)
                    if set1on2 > num_threshold || set2on1 > num_threshold
                        merge(hyperplanes, i, j)
                        merged = true
                        break
                    end

                end

            end
            if merged
                break
            end
        end

    end

end


function number_of_points_on_plane(hyperplane, plane, dist_threshold)
    count = 0
    n_points = hyperplane.inliers.n_points
    for i = 1:n_points
        point = hyperplane.inliers.coordinates[:, i]
        dist =
            Common.distance_point2plane(plane.centroid, plane.direction)(point)
        if dist < dist_threshold
            count += 1
        end
    end

    return count
end


function merge(hyperplanes, indx_s1, indx_s2)

    hyperplane_1 = hyperplanes[indx_s1]
    hyperplane_2 = hyperplanes[indx_s2]

    inliers_merged = PointCloud(
        hcat(
            hyperplane_1.inliers.coordinates,
            hyperplane_2.inliers.coordinates,
        ),
        hcat(hyperplane_1.inliers.rgbs, hyperplane_2.inliers.rgbs),
    )

    dir, cent = Common.LinearFit(inliers_merged.coordinates)
    hyperplane_merged = Detection.Hyperplane(inliers_merged, dir, cent)

    push!(hyperplanes, hyperplane_merged)
    deleteat!(hyperplanes, [indx_s1, indx_s2])
end



# function prova(a)
#     l = length(a)
#     i = 1
#     merged = []
#     while i <= l
#         if !(i in merged)
#             println("indice i corrente $i = $(a[i])")
#             for j = i+1:l
#                 if !(j in merged)
#                     println("indice j corrente  $j = $(a[j])")
#                     if a[i] == a[j]
#                         push!(a, 30 * (i + j))
#                         push!(merged, i)
#                         push!(merged, j)
#                     end
#                     @show merged
#                 end
#             end
#         end
#         println("a = $a")
#         i += 1
#         l = length(a)
#     end
#
#     @show merged
#     total = collect(1:l)
#     return a[setdiff(total, merged)]
# end
#
#
# a = [1, 2, 3, 1, 2, 3, 4, 5, 6, 4, 5, 6]
#
# a = prova(a)
