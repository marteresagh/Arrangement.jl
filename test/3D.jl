# ### gli input nel 3D devono essere già sistemati e non avere facce o spigoli doppi
#
# @testset "cubi intersecati" begin
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 1.0 1.0 1.0 1.0 3.0 3.0 3.0 3.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 1.0 1.0 3.0 3.0 1.0 1.0 3.0 3.0
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 1.0 3.0 1.0 3.0 1.0 3.0 1.0 3.0
#     ]
#
#     EV = [
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#         [9, 10],
#         [11, 12],
#         [13, 14],
#         [15, 16],
#         [9, 11],
#         [10, 12],
#         [13, 15],
#         [14, 16],
#         [9, 13],
#         [10, 14],
#         [11, 15],
#         [12, 16],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9, 10, 11, 12],
#         [13, 14, 15, 16],
#         [9, 10, 13, 14],
#         [11, 12, 15, 16],
#         [9, 11, 13, 15],
#         [10, 12, 14, 16],
#     ]
#
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1))
#     # @test size(T, 2) == 22
#     # @test length(FTs) == 18
#     # @test length(CTs) == 3
# end
#
# @testset "2 cubi un vertice comune" begin
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 2.0 2.0 2.0 3.0 3.0 3.0 3.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 2.0 3.0 3.0 2.0 2.0 3.0 3.0
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 3.0 2.0 3.0 2.0 3.0 2.0 3.0
#     ]
#     EV = [
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#         [8, 9],
#         [10, 11],
#         [12, 13],
#         [14, 15],
#         [8, 10],
#         [9, 11],
#         [12, 14],
#         [13, 15],
#         [8, 12],
#         [9, 13],
#         [10, 14],
#         [11, 15],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [8, 9, 10, 11],
#         [12, 13, 14, 15],
#         [8, 9, 12, 13],
#         [10, 11, 14, 15],
#         [8, 10, 12, 14],
#         [9, 11, 13, 15],
#     ]
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1))
#     # @test size(T, 2) == 15
#     # @test length(FTs) == 12
#     # @test length(CTs) == 2
# end
#
# @testset "2 cubi uno spigolo comune" begin
#
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 2.0 2.0 4.0 4.0 4.0 4.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 4.0 4.0 2.0 2.0 4.0 4.0
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0
#     ]
#     EV = [
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#         [9, 10],
#         [11, 12],
#         [13, 14],
#         [7, 9],
#         [8, 10],
#         [11, 13],
#         [12, 14],
#         [7, 11],
#         [8, 12],
#         [9, 13],
#         [10, 14],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [7, 8, 9, 10],
#         [11, 12, 13, 14],
#         [7, 8, 11, 12],
#         [9, 10, 13, 14],
#         [7, 9, 11, 13],
#         [8, 10, 12, 14],
#     ]
#
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, CTs, 1.3, 1.3, 1.3, 99, 1))
#     # @test size(T, 2) == 14
#     # @test length(FTs) == 12
#     # @test length(CTs) == 2
# end
#
# @testset "2 cubi una faccia comune" begin
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 4.0 4.0 4.0 4.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0
#     ]
#
#     EV = [
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#         [9, 10],
#         [11, 12],
#         [9, 11],
#         [10, 12],
#         [5, 9],
#         [6, 10],
#         [7, 11],
#         [8, 12],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9, 10, 11, 12],
#         [5, 6, 9, 10],
#         [7, 8, 11, 12],
#         [5, 7, 9, 11],
#         [6, 8, 10, 12],
#     ]
#
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, CTs, 1.3, 1.3, 1.3, 99, 1))
#     # @test size(T, 2) == 12
#     # @test length(FTs) == 11
#     # @test length(CTs) == 2
# end
#
# @testset "cubi adiacenti lungo la stessa faccia" begin
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 2.0 2.0 2.0 2.0 4.0 4.0 4.0 4.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 1.0 1.0 3.0 3.0 1.0 1.0 3.0 3.0
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0
#     ]
#
#     EV = [
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#         [9, 10],
#         [11, 12],
#         [13, 14],
#         [15, 16],
#         [9, 11],
#         [10, 12],
#         [13, 15],
#         [14, 16],
#         [9, 13],
#         [10, 14],
#         [11, 15],
#         [12, 16],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9, 10, 11, 12],
#         [13, 14, 15, 16],
#         [9, 10, 13, 14],
#         [11, 12, 15, 16],
#         [9, 11, 13, 15],
#         [10, 12, 14, 16],
#     ]
#
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1))
#     # @test size(T, 2) == 16
#     # @test length(FTs) == 13
#     # @test length(CTs) == 2
# end
#
# @testset "due componenti connesse" begin
#
#     V = [
#     0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 1.0 1.0 1.0 1.0 3.0 3.0 3.0 3.0 3.0 3.0 3.0 3.0 2.5 2.5 2.5 2.5
#     0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 1.0 1.0 3.0 3.0 1.0 1.0 3.0 3.0 0.0 0.0 0.5 0.5 0.0 0.0 0.5 0.5
#     0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 0.5 0.0 0.5 0.0 0.5 0.0 0.5
#     ]
#
#     EV = [
#     [1, 2],
#     [3, 4],
#     [5, 6],
#     [7, 8],
#     [1, 3],
#     [2, 4],
#     [5, 7],
#     [6, 8],
#     [1, 5],
#     [2, 6],
#     [3, 7],
#     [4, 8],
#     [9, 10],
#     [11, 12],
#     [13, 14],
#     [15, 16],
#     [9, 11],
#     [10, 12],
#     [13, 15],
#     [14, 16],
#     [9, 13],
#     [10, 14],
#     [11, 15],
#     [12, 16],
#     [17, 18],
#     [19, 20],
#     [21, 22],
#     [23, 24],
#     [17, 19],
#     [18, 20],
#     [21, 23],
#     [22, 24],
#     [17, 21],
#     [18, 22],
#     [19, 23],
#     [20, 24],
#     ]
#
#     FV = [
#     [1, 2, 3, 4],
#     [5, 6, 7, 8],
#     [1, 2, 5, 6],
#     [3, 4, 7, 8],
#     [1, 3, 5, 7],
#     [2, 4, 6, 8],
#     [9, 10, 11, 12],
#     [13, 14, 15, 16],
#     [9, 10, 13, 14],
#     [11, 12, 15, 16],
#     [9, 11, 13, 15],
#     [10, 12, 14, 16],
#     [17, 18, 19, 20],
#     [21, 22, 23, 24],
#     [17, 18, 21, 22],
#     [19, 20, 23, 24],
#     [17, 19, 21, 23],
#     [18, 20, 22, 24],
#     ]
#
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1))
#     # @test size(T, 2) == 28
#     # @test length(FTs) == 24
#     # @test length(CTs) == 4
# end
#
# @testset "due solidi con uno spigolo su faccia e 2 facce comuni" begin # [bug risolto con la nuova versione del planar]
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.0 0.0 1.5 1.5 1.0 1.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 1.0 1.0 1.0 1.0 1.5 1.5
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0
#     ]
#
#     EV = [
#         [11,13],
#         [12,14],
#         [9,10],
#         [11,12],
#         [13,14],
#         [9,11],
#         [9,13],
#         [10,12],
#         [10,14],
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9,10,11,12],
#         [9,10,13,14],
#         [9,11,13],
#         [10,12,14],
#         [11,12,13,14]
#
#     ]
#
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1))
# end
#
# @testset "cubo forato" begin
#
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.5 0.5 1.5 1.5 0.5 0.5 1.5 1.5
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 1.5 0.5 1.5 0.5 1.5 0.5 1.5
#     ]
#
#     VV = [[i] for i in 1:size(V,2)]
#
#     EV = [
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#         [9, 10],
#         [11, 12],
#         [13, 14],
#         [15, 16],
#         [9, 11],
#         [10, 12],
#         [13, 15],
#         [14, 16],
#         [9, 13],
#         [10, 14],
#         [11, 15],
#         [12, 16],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9, 10, 11, 12],
#         [13, 14, 15, 16],
#         [9, 10, 13, 14],
#         [11, 12, 15, 16],
#         [9, 11, 13, 15],
#         [10, 12, 14, 16],
#     ]
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1))
# end
#
# @testset "due solidi con spigolo comune" begin
#
#     @testset "uno dentro l'altro" begin # BUG loop nella ricerca dei 3 cicli minimi
#
#         V = [
#             0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.0 0.0 1.5 1.5 1.0 1.0
#             0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.0 0.0 1.0 1.0 1.5 1.5
#             0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 1.5 0.5 1.5 0.5 1.5
#         ]
#
#         EV = [
#             [11,13],
#             [12,14],
#             [9,10],
#             [11,12],
#             [13,14],
#             [9,11],
#             [9,13],
#             [10,12],
#             [10,14],
#             [1, 2],
#             [3, 4],
#             [5, 6],
#             [7, 8],
#             [1, 3],
#             [2, 4],
#             [5, 7],
#             [6, 8],
#             [1, 5],
#             [2, 6],
#             [3, 7],
#             [4, 8],
#         ]
#
#         FV = [
#             [1, 2, 3, 4],
#             [5, 6, 7, 8],
#             [1, 2, 5, 6],
#             [3, 4, 7, 8],
#             [1, 3, 5, 7],
#             [2, 4, 6, 8],
#             [9,10,11,12],
#             [9,10,13,14],
#             [9,11,13],
#             [10,12,14],
#             [11,12,13,14]
#
#         ]
#
#         GL.VIEW([GL.GLLines(V, EV)])
#         T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#         GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1))
#     end
#
#     @testset "esterno" begin # BUG loop sta nella ricerca dei 3 cicli minimi
#         V = [
#             0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.0 0.0 -1.5 -1.5 -1.0 -1.0
#             0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.0 0.0 -1.0 -1.0 -1.5 -1.5
#             0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 1.5 0.5 1.5 0.5 1.5
#         ]
#
#         EV = [
#             [11,13],
#             [12,14],
#             [9,10],
#             [11,12],
#             [13,14],
#             [9,11],
#             [9,13],
#             [10,12],
#             [10,14],
#             [1, 2],
#             [3, 4],
#             [5, 6],
#             [7, 8],
#             [1, 3],
#             [2, 4],
#             [5, 7],
#             [6, 8],
#             [1, 5],
#             [2, 6],
#             [3, 7],
#             [4, 8],
#         ]
#
#         FV = [
#             [1, 2, 3, 4],
#             [5, 6, 7, 8],
#             [1, 2, 5, 6],
#             [3, 4, 7, 8],
#             [1, 3, 5, 7],
#             [2, 4, 6, 8],
#             [9,10,11,12],
#             [9,10,13,14],
#             [9,11,13],
#             [10,12,14],
#             [11,12,13,14]
#
#         ]
#
#         GL.VIEW([GL.GLLines(V, EV)])
#         T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#         GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1))
#     end
# end
#
#
# @testset "cubo con incavo" begin # BUG la faccia esterna del buco non viene eliminata.
#
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.5 0.5 0.5 0.5 2.0 2.0 2.0 2.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.5 0.5 1.5 1.5 0.5 0.5 1.5 1.5
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 1.5 0.5 1.5 0.5 1.5 0.5 1.5
#     ]
#
#     VV = [[i] for i in 1:size(V,2)]
#
#     EV = [
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#         [9, 10],
#         [11, 12],
#         [13, 14],
#         [15, 16],
#         [9, 11],
#         [10, 12],
#         [13, 15],
#         [14, 16],
#         [9, 13],
#         [10, 14],
#         [11, 15],
#         [12, 16],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9, 10, 11, 12],
#         [13, 14, 15, 16],
#         [9, 10, 13, 14],
#         [11, 12, 15, 16],
#         [9, 11, 13, 15],
#         [10, 12, 14, 16],
#     ]
#
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1))
# end
#
# @testset "cubo + 2 facce" begin # BUG loop nella ricerca dei 3cicli minimi
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 -2.0 -2.0 3.0 3.0 1.0 1.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 -2.0 -2.0 1.0 1.0 3.0 3.0
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0  0.0  2.0 0.0 2.0 0.0 2.0
#     ]
#
#     EV = [
#         [9,10],
#         [11,12],
#         [13,14],
#         [9,11],
#         [9,13],
#         [10,12],
#         [10,14],
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9,10,11,12],
#         [9,10,13,14]
#
#     ]
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     # T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     # GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1))
#     # @test size(T, 2) == 16
#     # @test length(FTs) == 13
#     # @test length(CTs) == 2
# end
#
# @testset "2 cubi, uno nell'altro" begin # BUG l'algoritmo non buca ma va a termine
#
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.5 0.5 0.5 0.5 1.5 1.5 1.5 1.5
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.5 0.5 1.5 1.5 0.5 0.5 1.5 1.5
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 1.5 0.5 1.5 0.5 1.5 0.5 1.5
#     ]
#
#     EV = [
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#         [9, 10],
#         [11, 12],
#         [13, 14],
#         [15, 16],
#         [9, 11],
#         [10, 12],
#         [13, 15],
#         [14, 16],
#         [9, 13],
#         [10, 14],
#         [11, 15],
#         [12, 16],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9, 10, 11, 12],
#         [13, 14, 15, 16],
#         [9, 10, 13, 14],
#         [11, 12, 15, 16],
#         [9, 11, 13, 15],
#         [10, 12, 14, 16],
#     ]
#     GL.VIEW([GL.GLLines(V, EV)])
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1))
# end
#
# @testset "due cubi sovrapposti, ma con faccia comune" begin
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.5 0.5 0.5 0.5 2.0 2.0 2.0 2.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.5 0.5 1.5 1.5 0.5 0.5 1.5 1.5
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 1.5 0.5 1.5 0.5 1.5 0.5 1.5
#     ]
#
#     EV = [
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#         [9, 10],
#         [11, 12],
#         [13, 14],
#         [15, 16],
#         [9, 11],
#         [10, 12],
#         [13, 15],
#         [14, 16],
#         [9, 13],
#         [10, 14],
#         [11, 15],
#         [12, 16],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9, 10, 11, 12],
#         [13, 14, 15, 16],
#         [9, 10, 13, 14],
#         [11, 12, 15, 16],
#         [9, 11, 13, 15],
#         [10, 12, 14, 16],
#     ]
#     GL.VIEW([GL.GLLines(V, EV)])
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, ETs, 1.0, 1.0, 1.0, 99, 1))
# end  # non si crea il buco giusto
#
# @testset "2 solidi un punto comune" begin
#
#     V = [
#         0.0 0.0 0.0 0.0 2.0 2.0 2.0 2.0 0.0 1.5 1.5 1.0 1.0
#         0.0 0.0 2.0 2.0 0.0 0.0 2.0 2.0 0.0 1.0 1.0 1.5 1.5
#         0.0 2.0 0.0 2.0 0.0 2.0 0.0 2.0 0.5 0.5 1.5 0.5 1.5
#     ]
#
#     EV = [
#         [10,12],
#         [11,13],
#         [10,11],
#         [12,13],
#         [9,10],
#         [9,12],
#         [9,13],
#         [9,11],
#         [1, 2],
#         [3, 4],
#         [5, 6],
#         [7, 8],
#         [1, 3],
#         [2, 4],
#         [5, 7],
#         [6, 8],
#         [1, 5],
#         [2, 6],
#         [3, 7],
#         [4, 8],
#     ]
#
#     FV = [
#         [1, 2, 3, 4],
#         [5, 6, 7, 8],
#         [1, 2, 5, 6],
#         [3, 4, 7, 8],
#         [1, 3, 5, 7],
#         [2, 4, 6, 8],
#         [9,10,11],
#         [9,12,13],
#         [9,10,12],
#         [9,11,13],
#         [10,11,12,13]
#
#     ]
#
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.Lar_arrangement3D(V, EV, FV)
#     GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1))
# end # non si crea il buco interno
#
#
# @testset "facce che si intersecano in una forma aperta" begin
#     V = [
#         0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0
#         0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 1.0 1.0 1.0 1.0 2.0 2.0 2.0 2.0
#         1.0 1.0 1.0 1.0 2.0 2.0 2.0 2.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0
#     ]
#
#     EV = [
#         [1, 2],
#         [2, 3],
#         [3, 4],
#         [4, 1],
#         [5, 6],
#         [6, 7],
#         [7, 8],
#         [8, 5],
#         [9, 10],
#         [10, 11],
#         [11, 12],
#         [12, 9],
#         [13, 14],
#         [14, 15],
#         [15, 16],
#         [16, 13],
#     ]
#
#     FV = [
#         [1, 2, 4, 3],
#         [5, 6, 8, 7],
#         [9, 10, 12, 11],
#         [13, 14, 16, 15],
#     ]
#
#     GL.VIEW([GL.GLGrid(V, FV)])
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.arrange3D(V, EV, FV)
#
#     GL.VIEW(GL.GLExplode(T, ETs, 1.1, 1.1, 1.1, 99, 1));
#     GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1));
#     for i = 1:length(CTs)
#         GL.VIEW(GL.GLExplode(T, [CTs[i]], 1.1, 1.1, 1.1, 99, 0.2))
#     end
# end
#
#
# @testset "facce che si intersecano in una forma chiusa" begin
#     V = [
#         0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 1.0 1.0 1.0 1.0 2.0 2.0 2.0 2.0
#         0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 1.0 1.0 1.0 1.0 2.0 2.0 2.0 2.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0
#         1.0 1.0 1.0 1.0 2.0 2.0 2.0 2.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0 0.0 0.0 3.0 3.0
#     ]
#
#     EV = [
#         [1, 2],
#         [2, 3],
#         [3, 4],
#         [4, 1],
#         [5, 6],
#         [6, 7],
#         [7, 8],
#         [8, 5],
#         [9, 10],
#         [10, 11],
#         [11, 12],
#         [12, 9],
#         [13, 14],
#         [14, 15],
#         [15, 16],
#         [16, 13],
#         [17, 18],
#         [18, 19],
#         [19, 20],
#         [20, 17],
#         [21, 22],
#         [22, 23],
#         [23, 24],
#         [24, 21]
#     ]
#
#     FV = [
#         [1, 2, 4, 3],
#         [5, 6, 8, 7],
#         [9, 10, 12, 11],
#         [13, 14, 16, 15],
#         [17, 18, 20, 19],
#         [21, 22, 24, 23]
#     ]
#
#     GL.VIEW([GL.GLGrid(V, FV)])
#     GL.VIEW([GL.GLLines(V, EV)])
#
#     T, ETs, FTs, CTs = TGW.arrange3D(V, EV, FV)
#
#     GL.VIEW(GL.GLExplode(T, ETs, 1.1, 1.1, 1.1, 99, 1));
#     GL.VIEW(GL.GLExplode(T, FTs, 1.1, 1.1, 1.1, 99, 1));
#     for i = 1:length(CTs)
#         GL.VIEW(GL.GLExplode(T, [CTs[i]], 1.1, 1.1, 1.1, 99, 0.2))
#     end
# end
