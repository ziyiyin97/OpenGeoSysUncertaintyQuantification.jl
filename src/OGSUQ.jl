module OGSUQ

using XMLParser
import DistributedSparseGrids: AdaptiveHierarchicalSparseGrid
import Distributions: Normal, Uniform, UnivariateDistribution
import VTUFileHandler: VTUFile
import Ogs6InputFileHandler: Ogs6ModelDef, getAllPathesbyTag!
import DistributedSparseGrids: AdaptiveHierarchicalSparseGrid

mutable struct OGS6ProjectParams
	projectfile::String
	simcall::String
	additionalprojecfilespath::String
	outputpath::String
	postprocfiles::Vector{String}
end

mutable struct StochasticOGS6Parameter
	path::String
	valspec::Int
	dist::UnivariateDistribution
	lower_bound::Float64
	upper_bound::Float64
end

mutable struct StochasticOGSModelParams
	ogsparams::OGS6ProjectParams
	stochparams::Vector{StochasticOGS6Parameter}
	samplemethod::Type
	num_local_workers::Int
	#remote_workers::Vector{Tuple{String,Int}}
	file::String
end
filename(a::StochasticOGSModelParams) = a.file

abstract type SampleMethodParams end 
mutable struct SparseGridParams <: SampleMethodParams
	N::Int
	CT::Type
	RT::Type
	pointprobs::Vector{Int}
	init_lvl::Int
	maxlvl::Int
	tol::Float64
	userfunctionfile::String
	file::String
end
#mutable struct MCAnalysis{DIM,MCT,RT} <: StochasticAnalysis
#	mc::Union{Nothing,MonteCarlo{DIM,MCT,RT}}
#	nshots::Int
#	funfile::String
#	file::Union{Nothing,String}
#end
filename(a::SampleMethodParams) = a.file

mutable struct OGSUQParams
	stochasticmodelparams::StochasticOGSModelParams
	samplemethodparams::SampleMethodParams
end

function OGSUQParams(file_stochasticmodelparams::String, file_samplemethodparams::String)
	stochasticmodelparams = XML2Julia(read(XMLElement, file_stochasticmodelparams))
	samplemethodparams = XML2Julia(read(XMLElement, file_samplemethodparams))
	return OGSUQParams(stochasticmodelparams, samplemethodparams)
end

mutable struct OGSUQASG
	params::OGSUQParams
	asg::AdaptiveHierarchicalSparseGrid
end

#mutable struct OGSUQMC
#	params::OGSUQParams
#	
#end


#function init()

include("./OGSUQ/utils.jl")

export OGS6ProjectParams, StochasticOGS6Parameter, StochasticOGSModelParams, SampleMethodParams, SparseGridParams, OGSUQParams, generateStochasticOGSModell, generateSampleMethodModel, loadStochasticParameters, OGSUQASG, AdaptiveHierarchicalSparseGrid, Normal, Uniform, Ogs6ModelDef, getAllPathesbyTag!, VTUFile

end # module