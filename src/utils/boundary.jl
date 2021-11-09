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

coboundary_0(EV::Common.Cells) = convert(Common.ChainOp,transpose(Common.boundary_1(EV)))
