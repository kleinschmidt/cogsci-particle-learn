module VOTs
using RCall, DataFrames, DataFramesMeta, JLD2, Underscore, Distributions
export bp_mix, vot_dists, vot

if !isfile("buckeye_bp_mix.jld2")
    # requires that R package votcorpora be installed
    # R"devtools::install_github(kleinschmidt/votcorpora)"
    vot = @_ R"votcorpora::vot" |> DataFrame |> @where(_, :source .== "buckeye")
    vot_dists = by(vot, [:phoneme, :place, :voicing], @_ Normal(mean(_[:vot]), std(_[:vot])))
    bp_mix = MixtureModel(@where(vot_dists, :place .== "lab")[:x1])
    @save "buckeye_bp_mix.jld2" bp_mix vot_dists vot
end

@load "buckeye_bp_mix.jld2" bp_mix vot_dists vot

end
