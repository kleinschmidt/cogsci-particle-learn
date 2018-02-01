# run a three-component mixture

include(joinpath(@__DIR__, "..", "VOTs.jl"))
include(joinpath(@__DIR__, "..", "Experiments.jl"))

@everywhere using Distributions
@everywhere using VOTs
@everywhere using Experiments

n_replication = 100
bp3_mix = MixtureModel([Normal(-100., 25.), components(bp_mix)...])

params = Dict(:μ_0 => mean(bp_mix),
              :σ2_0 => var(bp_mix),
              :κ_0 => 0.05,
              :ν_0 => 2.0,
              :num_particle => [1, 10, 100, 1000],
              :α => [0.01, 0.1, 1., 10.],
              :num_obs => ([10, 100, 1000, 5000],),
              :data => [rand(bp3_mix, 5000) for _ in 1:n_replication])

exs = experiments(params)
length(exs)
results = pmap(run, exs)

using JLD2
@save joinpath(@__DIR__, "..", "results", "run3-$(DateTime(now())).jld2") exs results
