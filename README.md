# Learning distributions as they come: Particle filter models for online distributional learning of phonetic categories 

This contains the a Julia-markdown source for the paper "Learning distributions
as they come: Particle filter models for online distributional learning of
phonetic categories" (submitted to CogSci2018).

## Weaving the paper

Cached results from the actual simulations are in the [`results` folder in the
OSF project](https://osf.io/fv3gp/files/).  Once these are inplace, to generate
the PDF from the `.jmd` source, run

```shell
make cogsci-particle-learn.pdf
```

In addition to the cached results files, you'll need:
  * Julia 0.6.2
  * Weave.jl (`Pkg.add("Weave.jl")`) and all the packages loaded with `using` in
    the `.jmd` document.
  * `pandoc`
  * `pandoc-crossref`
  * a LaTeX installation, and biber (I have TeXlive 2017, from the Archlinux
    `texlive-most` package)

## Reproducing analyses

The scripts to run the analyses are in `analyses/`.  Note that they were extract
from an Jupyter notebook and so might not run without some tweaking.  If this is
important to you please open an issue to let me know what goes wrong.

Additional dependencies:
  * [Particles.jl](https://github.com/kleinschmidt/Particles.jl) ---
    Implementations of the Gibbs sampler and particle filter.
  * [Experiments.jl](https://github.com/kleinschmidt/Experiments.jl) ---
    helper functions to reproducibly run these computational experiments.  This
    is just the contents of the Experiments.jl file in this repository, but
    Julia did not like it when it was included from file when run from a script.

The analysis scripts assume that you're running things in parallel.  Invoke
Julia with `julia -p N` to use N cores, or `julia -p auto` to use all available
cores.
