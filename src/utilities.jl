function lar2cop(CV::Common.Cells)::Common.ChainOp
	I = Int64[]; J = Int64[]; Value = Int8[];
	for k=1:size(CV,1)
		n = length(CV[k])
		append!(I, k * ones(Int64, n))
		append!(J, CV[k])
		append!(Value, ones(Int64, n))
	end
	return SparseArrays.sparse(I,J,Value)
end


function cop2lar(cop::Common.ChainOp)::Common.Cells
	[findnz(cop[k,:])[1] for k=1:size(cop,1)]
end


function FV2EVs(copEV::Common.ChainOp, copFE::Common.ChainOp)
	EV = [findnz(copEV[k,:])[1] for k=1:size(copEV,1)]
	FE = [findnz(copFE[k,:])[1] for k=1:size(copFE,1)]
	EVs = [[EV[e] for e in fe] for fe in FE]
	return EVs
end
