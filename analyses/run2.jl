# copied from kleinschmidt/adapt-particle#3e9f5d5

include(joinpath(@__FILE__, "..", "VOTs.jl"))
include(joinpath(@__FILE__, "..", "Experiments.jl"))

@everywhere using Distributions
@everywhere using VOTs
@everywhere using Experiments

n_replication = 200

params = Dict(:μ_0 => mean(bp_mix),
              :σ2_0 => var(bp_mix),
              :κ_0 => 0.05,
              :ν_0 => 2.0,
              :num_particle => [1, 10, 100, 1000],
              :α => [0.01, 0.1, 1., 10.],
              :num_obs => ([10, 100, 1000, 10_000],),
              :data => [rand(bp_mix, 10000) for _ in 1:n_replication])

exs = experiments(params)
length(exs)
results = pmap(run, exs)

using JLD2
@save joinpath(@__FILE__, "..", "results", "run2-$(DateTime(now())).jld2") exs results
