include("../VOTs.jl")
using VOTs

@everywhere bp_mix = $bp_mix

# created an actual package for this...
# include(joinpath(dir, "..", "Experiments.jl"))
@everywhere using Distributions
@everywhere using Experiments

n_replication = 50

params = Dict(:μ_0 => mean(bp_mix),
              :σ2_0 => var(bp_mix),
              :κ_0 => 0.05,
              :ν_0 => 2.0,
              :num_particle => [1, 10, 100, 1000],
              :α => [0.01, 0.1, 1., 10.],
              :num_obs => ([10, 50, 100, 500, 1000, 5000],),
              :data => [ex -> (srand(ex.params[:iter]);
                               rand(bp_mix, maximum(ex.params[:num_obs])))],
              :iter => [1:n_replication;]
              )

worker_pool = CachingPool(workers())

exs = experiments(params)
results = pmap(worker_pool,
               ex -> run(ex, Experiments.result_entropy),
               exs)

using JLD2
@save joinpath(@__DIR__, "..", "results", "run4-$(DateTime(now())).jld2") exs results
