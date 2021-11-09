function fix_redundancy(target_mat, cscFV,cscEV) # incidence numbers > 2#E
	nfixs = 0
	faces2fix = []
	edges2fix = []
	# target_mat and cscFV (ref_mat) should have same length per row !
	for face = 1:size(target_mat,1)
		nedges = sum(findnz(target_mat[face,:])[2])
		nverts = sum(findnz(cscFV[face,:])[2])
		if nedges != nverts
			nfixs += nedges - nverts
			#println("face $face, nedges=$nedges, nverts=$nverts")
			push!(faces2fix,face)
		end
	end
	for edge = 1:size(target_mat,2)
		nfaces = sum(findnz(target_mat[:,edge])[2])
		if nfaces > 2
			#println("edge $edge, nfaces=$nfaces")
			push!(edges2fix,edge)
		end
	end
	#println("nfixs=$nfixs")
	pairs2fix = []
	for fh in faces2fix		# for each face to fix
		for ek in edges2fix		# for each edge to fix
			if target_mat[fh, ek]==1	# edge to fix \in face to fix
				v1,v2 = findnz(cscEV[ek,:])[1]
				weight(v) = length( intersect(
							findnz(cscEV[:,v])[1], findnz(target_mat[fh,:])[1] ))
				if weight(v1)>2 && weight(v2)>2
					#println("(fh,ek) = $((fh,ek))")
					push!( pairs2fix, (fh,ek) )
				end
			end
		end
	end
	for (fh,ek) in pairs2fix
		target_mat[fh, ek] = 0
	end
	cscFE = dropzeros(target_mat)
	@assert nnz(cscFE) == 2*size(cscFE,2)
	return cscFE
end


function u_coboundary_1( FV::Common.Cells, EV::Common.Cells, convex=true::Bool)::Common.ChainOp
	cscFV = Common.characteristicMatrix(FV)
	cscEV = Common.characteristicMatrix(EV)
	out = u_coboundary_1( cscFV, cscEV, convex)
	return out
end

function u_coboundary_1( cscFV::Common.ChainOp, cscEV::Common.ChainOp, convex=true::Bool)::Common.ChainOp
	temp = cscFV * cscEV'
	I,J,Val = Int64[],Int64[],Int8[]
	for j=1:size(temp,2)
		for i=1:size(temp,1)
			if temp[i,j] == 2
				push!(I,i)
				push!(J,j)
				push!(Val,1)
			end
		end
	end
	cscFE = SparseArrays.sparse(I,J,Val)
	if !convex
		cscFE = fix_redundancy(cscFE,cscFV,cscEV)
	end
	return cscFE
end


function boundary_1( EV::Common.Cells )::Common.ChainOp
	out = Common.characteristicMatrix(EV)'
	for e = 1:length(EV)
		out[EV[e][1],e] = -1
	end
	return out
end

coboundary_0(EV::Common.Cells) = convert(Common.ChainOp,transpose(boundary_1(EV)))



"""
	coboundary_1( FV::Cells, EV::Cells)::ChainOp
Generate the *unsigned* sparse matrix of the coboundary_1 operator.
For each row, start with the first incidence number positive (i.e. assign the orientation of the first edge to the 1-cycle of the face), then bounce back and forth between vertex columns/rows of EV and FE.
# Example
```
julia> copFE = coboundary_1(FV::Common.Cells, EV::Common.Cells)
julia> Matrix(cscFE)
5×20 Array{Int8,2}:
 1  1  1  1  1  0  0  0  1  0  0  0  0  0  0  0  1  0  0  1
 1  0  1  0  1  1  1  1  0  1  1  1  0  1  1  1  0  1  1  0
 0  0  0  1  0  0  0  1  1  0  0  0  1  0  1  1  1  1  1  1
 0  1  0  0  0  1  1  0  0  1  0  0  0  0  0  0  0  0  0  0
 0  0  0  0  0  0  0  0  0  0  1  1  1  1  0  0  0  0  0  0
```
"""
function coboundary_1(FV::Array{Array{Int64,1},1}, EV::Array{Array{Int64,1},1}) # (::Cells, ::Cells)
	copFV = lar2cop(FV)
	I,J,Val = Common.findnz(lar2cop(EV))
	copVE = Common.sparse(J,I,Val)
	triples = hcat([[i,j,1]  for (i,j,v)  in zip(Common.findnz(copFV * copVE)...) if v==2]...)
	I,J,Val = triples[1,:], triples[2,:], triples[3,:]
	Val = convert(Array{Int8,1},Val)
	copFE = Common.sparse(I,J,Val)
	return copFE
end

function coboundary_1( V::Common.Points, FV::Common.Cells, EV::Common.Cells, convex=true::Bool, exterior=false::Bool)::Common.ChainOp
	# generate unsigned operator's sparse matrix
	cscFV = Common.characteristicMatrix(FV)
	cscEV = Common.characteristicMatrix(EV)
	##if size(V,1) == 3
		##copFE = u_coboundary_1( FV::Cells, EV::Cells )
	##elseif size(V,1) == 2
		# greedy generation of incidence number signs
		copFE = coboundary_1( V, cscFV, cscEV, convex, exterior)
	##end
	return copFE
end

function coboundary_1( V::Common.Points, cscFV::Common.ChainOp, cscEV::Common.ChainOp, convex=true::Bool, exterior=false::Bool )::Common.ChainOp

	cscFE = u_coboundary_1( cscFV, cscEV, convex)
	EV = [Common.findnz(cscEV[k,:])[1] for k=1:size(cscEV,1)]
	cscEV = Common.sparse(coboundary_0(EV))
	for f=1:size(cscFE,1)
		chain = Common.findnz(cscFE[f,:])[1]	#	dense
		cycle = Common.spzeros(Int8,cscFE.n)	#	sparse

		edge = Common.findnz(cscFE[f,:])[1][1]; sign = 1
		cycle[edge] = sign
		chain = setdiff( chain, edge )
		while chain != []
			boundary = Common.sparse(cycle') * cscEV
			_,vs,vals = Common.findnz(Common.dropzeros(boundary))

			rindex = vals[1]==1 ? vf = vs[1] : vf = vs[2]
			r_boundary = Common.spzeros(Int8,cscEV.n)	#	sparse
			r_boundary[rindex] = 1
			r_coboundary = cscEV * r_boundary
			r_edge = intersect(Common.findnz(r_coboundary)[1],chain)[1]
			r_coboundary = Common.spzeros(Int8,cscEV.m)	#	sparse
			r_coboundary[r_edge] = EV[r_edge][1]<EV[r_edge][2] ? 1 : -1

			lindex = vals[1]==-1 ? vi = vs[1] : vi = vs[2]
			l_boundary = Common.spzeros(Int8,cscEV.n)	#	sparse
			l_boundary[lindex] = -1
			l_coboundary = cscEV * l_boundary
			l_edge = intersect(Common.findnz(l_coboundary)[1],chain)[1]
			l_coboundary = Common.spzeros(Int8,cscEV.m)	#	sparse
			l_coboundary[l_edge] = EV[l_edge][1]<EV[l_edge][2] ? -1 : 1

			if r_coboundary != -l_coboundary  # false iff last edge
				# add edge to cycle from both sides
				rsign = rindex == EV[r_edge][1] ? 1 : -1
				lsign = lindex == EV[l_edge][2] ? -1 : 1
				cycle = cycle + rsign * r_coboundary + lsign * l_coboundary
			else
				# add last (odd) edge to cycle
				rsign = rindex==EV[r_edge][1] ? 1 : -1
				cycle = cycle + rsign * r_coboundary
			end
			chain = setdiff(chain, Common.findnz(cycle)[1])
		end
		for e in Common.findnz(cscFE[f,:])[1]
			cscFE[f,e] = cycle[e]
		end
	end
	if exterior && size(V,1)==2
		# put matrix in form: first row outer cell; with opposite sign )
		V = convert(Array{Float64,2},transpose(V))
		EV = convert(Common.ChainOp, Common.transpose(boundary_1(EV)))

		outer = get_external_cycle(V, cscEV,
			cscFE)
		copFE = [ -cscFE[outer:outer,:];  cscFE[1:outer-1,:];  cscFE[outer+1:end,:] ]
		# induce coherent orientation of matrix rows (see examples/orient2d.jl)
		for k=1:size(copFE,2)
			spcolumn = Common.findnz(copFE[:,k])
			if sum(spcolumn[2]) != 0
				row = spcolumn[1][2]
				sign = spcolumn[2][2]
				copFE[row,:] = -sign * copFE[row,:]
			end
		end
		return copFE
	else
		return cscFE
	end
end
