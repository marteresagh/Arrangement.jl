@testset "quadrati intersecati" begin
	V = [0. 2 2 0 1 3 3 1;
		 1. 1 3 3 0 0 2 2]
	EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(T,FTs,1.,1.,1.,99,1));
	@test size(T,2) == 10
	@test length(ETs) == 3
	@test length(FTs) == 3
	@test sort(length.(ETs)) == [4,6,6]

end

@testset "un vertice comune" begin
	V = [0. 3 3 0 3 6 6 ;
		 3. 3 6 6 0 0 3 ]
	EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,2],[2,5]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));
	@test size(T,2) == 7
	@test length(ETs) == 2
	@test length(FTs) == 2
	@test sort(length.(ETs)) == [4,4]
end

@testset "uno spigolo comune" begin
	V = [0. 3 6 6 3 0 3 3;
		 0. 0 0 3 3 3 0 3]
	EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],[5,2],[7,8]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));
	@test size(T,2) == 6
	@test length(ETs) == 2
	@test length(FTs) == 2
	@test sort(length.(ETs)) == [4,4]
end

@testset "4 quadrati adiacenti" begin
	V = [0. 3 6 6 3 0 0. 3 6;
		 0. 0 0 3 3 3 6  6 6]
	EV = [[1,2],[2,3],[3,4],[4,5],[5,6],[6,1],[5,2],[4,9],[9,8],[8,7],[7,6],[8,5]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));
	@test size(T,2) == 9
	@test length(ETs) == 4
	@test length(FTs) == 4
	@test sort(length.(ETs)) == [4,4,4,4]
end

@testset "quadrati adiacenti lungo lo stesso spigolo" begin
	V = [0. 2 2 0 1 3 3 1;
		 1. 1 3 3 -1 -1 1 1]
	EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));
	@test size(T,2) == 8
	@test length(ETs) == 2
	@test length(FTs) == 2
	@test sort(length.(ETs)) == [5,5]
end

@testset "poligono chiuso + 2 segmenti" begin
	V = [0. 2 2 0 1 2.3 1.3 -1;
		 1. 1 3 3 0 3 0 3]
	EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[7,8]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(T,ETs,1.,1.,1.,99,1));
	@test size(T,2) == 13 # sono 9 vertici utilizzati però TODO da modificare ??
	@test length(ETs) == 4
	@test length(FTs) == 4
	@test sort(length.(ETs)) == [3,3,3,6]
end

@testset "due componenti biconnesse" begin
	V = [0. 2 2 0 1 3 3 1 0 0.5 0.5 0;
		 1. 1 3 3 0 0 2 2 0 0   0.5 0.5]
	EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5], [9,10],[10,11],[11,12],[12,9]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(T,FTs,1.,1.,1.,99,1));
	@test size(T,2) == 14
	@test length(ETs) == 4
	@test length(FTs) == 4
	@test sort(length.(ETs)) == [4,4,6,6]
end

@testset "due componenti biconnesse sovrapposte" begin
	V = [0. 4. 4. 0. 1. 3. 3. 1.;
		 0. 0. 4. 4. 1. 1. 3. 3.]
	EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5],[5,7]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(T,FTs,1.5,1.5,1.5,99,1));
	@test size(T,2) == 8
	@test length(ETs) == 3
	@test length(FTs) == 3
	@test sort(length.(ETs)) == [3,3,8]
end

@testset "due componenti biconnesse sovrapposte ma con vertice su spigolo" begin

	@testset "origine in prune_containement è il vertice" begin
		V = [0. 4. 4. 0. 4. 3. 2. 1.;
			 0. 0. 4. 4. 2. 3. 1. 1.]
		EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,5],[6,8],[7,8]]
		# GL.VIEW([ GL.GLLines(V,EV) ])

		T, ETs, FTs = Arrangement.arrange2D(V,EV)
		# GL.VIEW(GL.GLExplode(T,FTs,1.5,1.5,1.5,99,1));
		@test size(T,2) == 8
		@test length(ETs) == 3
		@test length(FTs) == 3
		@test sort(length.(ETs)) == [3,3,9]
	end

	@testset "origine in prune non è più il vertice" begin
		V = [0. 4. 4. 0. 4. 2. 3. ;
			 0. 0. 4. 4. 2. 1. 3. ]
		EV = [[1,2],[2,3],[3,4],[4,1],[7,6],[6,5],[7,5]]

		# GL.VIEW([ GL.GLLines(V,EV) ])

		T, ETs, FTs = Arrangement.arrange2D(V,EV)
		# GL.VIEW(GL.GLExplode(T,FTs,1.,1.,1.,99,1));
		@test size(T,2) == 7
		@test length(ETs) == 2
		@test length(FTs) == 2
		@test sort(length.(ETs)) == [3,8]
	end

	@testset "ulteriore problema" begin
		V = [0. 4. 4. 0. 3. 2. 4. ;
		     0. 0. 4. 4. 3. 1. 2. ]
		EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,5]]

		# GL.VIEW([ GL.GLLines(V,EV) ])

		T, ETs, FTs = Arrangement.arrange2D(V,EV)
		# GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));
		@test size(T,2) == 7
		@test length(ETs) == 2
		@test length(FTs) == 2
		@test FTs[1] != FTs[2]
		@test sort(length.(ETs)) == [3,8]
	end

	@testset "vertice comune ma componenti non sovrapposte" begin
		V = [0. 3. 6. 3. 2. 1. 1;
		     3. 0. 3. 6. 1. 1. 1.2]
		EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,5]]
		# GL.VIEW([ GL.GLLines(V,EV) ])

		T, ETs, FTs = Arrangement.arrange2D(V,EV)
		# GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));
		@test size(T,2) == 7
		@test length(ETs) == 2
		@test length(FTs) == 2
		@test FTs[1] != FTs[2]
		@test sort(length.(ETs)) == [3,5]
	end

end


@testset "due componenti biconnesse sovrapposte ma con spigolo comune" begin
	V = [0. 4. 4. 0. 1. 4. 4. 1.;
		 0. 0. 4. 4. 1. 1. 3. 3.]
	EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));
	@test size(T,2) == 8
	@test length(ETs) == 2
	@test length(FTs) == 2
	@test sort(length.(ETs)) == [4, 8]
end


@testset "planar graph" begin

	V = [
	        1.0 0.0 9.0 4.0 2.0 7.0 11.0 16.0 15.0 25.0 9.0 14.0 12.0 19.0 23.0 27.0 29.0 33.0 33.0 37.0 33.0 41.0 41.0 35.0 39.0 38.0 32.0 28.0 25.0 26.0 23.0
	        17.0 10.0 10.0 12.0 11.0 16.0 18.0 10.0 16.0 17.0 5.0 5.0 11.0 4.0 6.0 3.0 14.0 17.0 10.0 18.0 4.0 4.0 10.0 5.0 5.0 9.0 11.0 11.0 14.0 12.0 13.0
	]
	EV = [
	        [1, 2],
	        [2, 3],
	        [3, 4],
	        [4, 5],
	        [3, 6],
	        [1, 6],
	        [6, 7],
	        [7, 9],
	        [8, 9],
	        [8, 10],
	        [9, 10],
	        [11, 12],
	        [12, 13],
	        [11, 13],
	        [8, 19],
	        [19, 18],
	        [17, 18],
	        [10, 17],
	        [10, 29],
	        [29, 30],
	        [30, 31],
	        [29, 31],
	        [17, 28],
	        [27, 28],
	        [17, 27],
	        [20, 19],
	        [18, 20],
	        [14, 15],
	        [15, 16],
	        [19, 21],
	        [21, 22],
	        [22, 23],
	        [23, 19],
	        [21, 24],
	        [24, 25],
	        [25, 26],
	        [24, 26],
	]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(W,FWs,1.,1.,1.,99,1));
	@test size(T,2) == 31
	@test length(ETs) == 9
	@test length(FTs) == 9
	@test sort(length.(ETs)) == [3,3,3,3,3,3,4,7,11]
end


@testset "3 componenti sovrapposte" begin
	V = [0. 10 10 0. 1. 9. 9. 1. 2. 8. 8. 2.;
		 0. 0. 10 10 1. 1. 9. 9. 2. 2. 8. 8.]
	EV = [[1,2],[2,3],[3,4],[4,1],[5,6],[6,7],[7,8],[8,5],[9,10],[10,11],[11,12],[12,9]]
	# GL.VIEW([ GL.GLLines(V,EV) ])

	T, ETs, FTs = Arrangement.arrange2D(V,EV)
	# GL.VIEW(GL.GLExplode(T,[FTs[3]],1.5,1.5,1.5,99,1));
	@test size(T,2) == 12
	@test length(ETs) == 3
	@test length(FTs) == 3
	@test sort(length.(ETs)) == [4,8,8]

end
