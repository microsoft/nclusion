ENV["GKSwstype"] = "100"

using Logging,LoggingExtras
using Random
using Distributions
using Flux
using StatsBase, StatsFuns, StatsModels, StatsPlots, Statistics, LinearAlgebra, HypothesisTests
using Test
using CSV,DataFrames
using JSON, JSON3
using Dates
using TSne, MultivariateStats, Clustering
using LaTeXStrings, TypedTables, PrettyTables
using Gnuplot, Colors, ColorSchemes
using SpecialFunctions
using Optim
using BenchmarkTools
using Profile
using JLD2,FileIO
using OrderedCollections
using HDF5
using ClusterValidityIndices
using StaticArrays
using Pkg
using Distributed

curr_dir = ENV["PWD"]
src_dir = "/src/"

include(curr_dir*src_dir*"nclusion.jl")
using .nclusion


logger = FormatLogger() do io, args
    println(io, args._module, " | ", "[", args.level, "] ", args.message)
end;

datafilename1 = "/users/cnwizu/data/cnwizu/SCoOP-sc/data/pdac-biopsy/5000hvgs_pdac_biopsy_preprocessed2.h5ad" # 
alpha1 = 1 * 10^(-7.0)
gamma1 = 1 * 10^(-7.0)
KMax = 25
seed = 12345
elbo_ep = 10^(-0.0)
dataset = "pdac_biopsy"
outdir = "$curr_dir"

outputs_dict = run_nclusion(datafilename1,KMax,alpha1,gamma1,seed,elbo_ep,dataset,outdir; logger = logger)
filepath = outputs_dict[:filepath]
filename = "$filepath/output.jld2"

jldsave(filename,true;outputs_dict=outputs_dict)

