
"""
    point_in_face(point, V::Points, copEV::ChainOp)
Check if `point` is inside the area of the face bounded by the edges in `copEV`
"""
function point_in_face(point, V::Common.Points, copEV::Common.ChainOp)
    return pointInPolygonClassification(V, copEV)(point) == "p_in"
end


function pointInPolygonClassification(V, EV)

    function crossingTest(new, old, status, count)
        if status == 0
            status = new
            return status, (count + 0.5)
        else
            if status == old
                return 0, (count + 0.5)
            else
                return 0, (count - 0.5)
            end
        end
    end

    function setTile(box)
        tiles = [[9, 1, 5], [8, 0, 4], [10, 2, 6]]
        b1, b2, b3, b4 = box
        function tileCode(point)
            x, y = point
            code = 0
            if y > b1
                code = code | 1
            end
            if y < b2
                code = code | 2
            end
            if x > b3
                code = code | 4
            end
            if x < b4
                code = code | 8
            end
            return code
        end
        return tileCode
    end

    function pointInPolygonClassification0(pnt)
        x, y = pnt
        xmin, xmax, ymin, ymax = x, x, y, y
        tilecode = setTile([ymax, ymin, xmax, xmin])
        count, status = 0, 0

        for k = 1:EV.m
            edge = EV[k, :]
            p1, p2 = V[edge.nzind[1], :], V[edge.nzind[2], :]
            (x1, y1), (x2, y2) = p1, p2
            c1, c2 = tilecode(p1), tilecode(p2)
            c_edge, c_un, c_int = xor(c1, c2), c1 | c2, c1 & c2

            if (c_edge == 0) & (c_un == 0)
                return "p_on"
            elseif (c_edge == 12) & (c_un == c_edge)
                return "p_on"
            elseif c_edge == 3
                if c_int == 0
                    return "p_on"
                elseif c_int == 4
                    count += 1
                end
            elseif c_edge == 15
                x_int = ((y - y2) * (x1 - x2) / (y1 - y2)) + x2
                if x_int > x
                    count += 1
                elseif x_int == x
                    return "p_on"
                end
            elseif (c_edge == 13) & ((c1 == 4) | (c2 == 4))
                status, count = crossingTest(1, 2, status, count)
            elseif (c_edge == 14) & ((c1 == 4) | (c2 == 4))
                status, count = crossingTest(2, 1, status, count)
            elseif c_edge == 7
                count += 1
            elseif c_edge == 11
                count = count
            elseif c_edge == 1
                if c_int == 0
                    return "p_on"
                elseif c_int == 4
                    status, count = crossingTest(1, 2, status, count)
                end
            elseif c_edge == 2
                if c_int == 0
                    return "p_on"
                elseif c_int == 4
                    status, count = crossingTest(2, 1, status, count)
                end
            elseif (c_edge == 4) & (c_un == c_edge)
                return "p_on"
            elseif (c_edge == 8) & (c_un == c_edge)
                return "p_on"
            elseif c_edge == 5
                if (c1 == 0) | (c2 == 0)
                    return "p_on"
                else
                    status, count = crossingTest(1, 2, status, count)
                end
            elseif c_edge == 6
                if (c1 == 0) | (c2 == 0)
                    return "p_on"
                else
                    status, count = crossingTest(2, 1, status, count)
                end
            elseif (c_edge == 9) & ((c1 == 0) | (c2 == 0))
                return "p_on"
            elseif (c_edge == 10) & ((c1 == 0) | (c2 == 0))
                return "p_on"
            end
        end

        if (round(count) % 2) == 1
            return "p_in"
        else
            return "p_out"
        end
    end
    return pointInPolygonClassification0
end
