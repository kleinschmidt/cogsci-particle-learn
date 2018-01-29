module Experiments
using Particles, Distributions, DataFrames, Underscore

export Experiment,
    Result,
    run,
    run_gibbs,
    flatten,
    dictofarrays,
    experiments,
    results_summary


struct Experiment
    params::Dict{Symbol,Any}
    seed::UInt
end

Experiment(params::Dict) = Experiment(params, rand(UInt))



"""
    Result

Holds the result of an experiment:

* `K_modal` the modal number of clusters (highest posterior probability)
* `K_mean` expected number of clusters
* `K_map` number of clusters in particle with highest overall posterior
* `p_of_K` the posterior probability of each number of clusters ``p(K | x^(i), w^(i))``
    
"""
struct Result
    K_modal::Int
    K_mean::Float64
    K_map::Int
    p_of_K::Vector{Float64}
end

function Result(ps::ParticleFilter)
    K_dist = ncomponents_dist(ps)
    p_of_K = probs(K_dist)
    K_modal = findmax(p_of_K)[2]
    K_mean = mean(K_dist)
    
    ps = particles(ps)
    best = findmax(marginal_log_posterior(p) for p in ps)
    
    K_map = ncomponents(ps[best[2]])
    return Result(K_modal, K_mean, K_map, p_of_K)
end

import Base.run
function run(ex::Experiment)
    params = ex.params

    prior = NormalInverseChisq(params[:μ_0], params[:σ2_0], params[:κ_0], params[:ν_0])
    ps = ChenLiuParticles(params[:num_particle], prior, params[:α])

    results = Result[]
    srand(ex.seed)
    first = 1
    for k in sort(params[:num_obs])
        fit!(ps, view(ex.params[:data], first:k), false)
        first = k+1
        push!(results, Result(ps))
    end
    
    return results
end

function Result(gs::GibbsCRPSamples)
    K_dist = ncomponents_dist(gs)
    p_of_K = probs(K_dist)
    K_modal = findmax(p_of_K)[2]
    K_mean = mean(K_dist)

    MAP_components, i =
        findmax(marginal_log_posterior(cs, gs.g.logα) for cs in gs.components)

    K_map = length(MAP_components)
    Result(K_modal, K_mean, K_map, p_of_K)
end

function run_gibbs(ex::Experiment)
    params = ex.params

    prior = NormalInverseChisq(params[:μ_0], params[:σ2_0], params[:κ_0], params[:ν_0])
    samples = fit!(GibbsCRP(prior, params[:α], params[:data]), false,
                   samples=params[:num_particle], burnin=500)

    return Result(samples)
end

using Base.Iterators: product

# each experiment has multiple :num_obs, so we need to flatten...
"""
    flatten(d::Dict, k::Symbol)
    flatten(d::Dict)

Turn a dict of vectors (generally iterables) into an array of dicts.  Every
iterable value becomes a dimension in the resulting array
"""

flatten(d::Dict{K,V}, k::K) where {K,V} = (setindex!(copy(d), n, k) for n in d[k])
function flatten(d::Dict)
    (Dict(kv...) for kv in product([ (k=>s for s in v) for (k,v) in params ]...))
end

flatten(ex::Experiment, k::Symbol) = Experiment.(collect(flatten(ex.params, k)), ex.seed)



"""
    dictofarrays(ds::Array{Dict{K,V},N}) where {K,V,N}

The opposite of flatten: take an array of dicts and turn it into a dict of
arrays.

"""
function dictofarrays(ds::Array{Dict{K,V},N}) where {K,V,N}
    d = Dict{K,Any}()
    for k in keys(first(ds))
        d[k] = getindex.(ds, k)
    end
    return d
end


"""
    experiments(params::Dict)
    experiments(; kw...)

Construct an array of experiments from parameter values supplied as a Dict or
keyword arguments.  Each parameter value that's iterable will expand to a
"dimension" of the experiments array.

# Example

    experiments(μ = [-1, 0, 1],
                σ2 = [.1, 1.0, 10.0],
                x = ([1, 2, 3, 4], ))

Produces 9 `Experiment`s, one of each combination of μ and σ2.  Each of these
has the same value of `x`, since it was passed as a vector wrapped in a tuple.

"""
experiments(params::Dict) = [Experiment(d) for d in flatten(params)]
experiments(; kw...) = experiments(Dict(kw))


Dict(r::Result) = Dict([k=>getfield(r,k) for k in fieldnames(r)])
Dict(e::Experiment, r::Result) = merge(Dict(r), Dict(:seed=>e.seed), e.params)

flatten(es::Array{Experiment,N}, rs::Array{Vector{Result},N}, k::Symbol) where N =
    reduce(append!, [], (zip(flatten(e, k), r) for (e,r) in zip(es, rs)))

function results_summary(ers)
    @_ [Dict(er...) for er in ers] |>
    dictofarrays |>
    DataFrame |>
    by(_, [:num_particle, :num_obs, :α]) do d
        DataFrame(low = mean(d[:K_map] .< 2),
                  success = mean(d[:K_map] .== 2),
                  high = mean(d[:K_map] .> 2),
                  avg_K_map = mean(d[:K_map]),
                  avg_K_mean = mean(d[:K_mean]),
                  avg_p_K2 = mean(get.(d[:p_of_K], 2, 0)))
    end
end


end # module Experiments
