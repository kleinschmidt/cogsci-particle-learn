# Learning your language as it comes

Using sequential monte carlo (aka particle filter) approximations of
nonparametric Bayesian clustering models for language acquisition.

## Why

Babies need to learn how many phonetic categories their language has from un- or
weakly-labeled inputs.  Distributional learning theories say that you can treat
this as a clustering problem: detect how many "clusters" or "clumps" of sounds
there are in your acoustic input.

There are many types of models and algorithms for doing this.  One family is
Bayesian non-parametrics.

Pros:
* Potentially infinite number of clusters
* Flexibility in what kinds of clusters you allow (any probability distribution
  will do)
* Treating the problem as statistical inference provides a natural and
  principled way combine with other sources of information [e.g., learn lexicon
  at the same time; @Feldman2013]
* Tight link between _acquisition_ of a new language and _adaptation_ to new
  talkers of a familiar language.
* As computational-level: clearly and explicitly stated inductive biases, allow
  us to explore how the structure of the data available to infants provides
  _in-principle_ constraints on what can be learned (and what inductive biases
  are necessary to do so).

Cons:
* Can't do exact inference in these models, requires approximations (even to
  simulate on a computer)
* Psychological implausibility 1: standard MCMC approximations are "batch"
  algorithms, which require that you see all the data at once, and perform
  multiple sweeps through it.
* Psychological implausibility 2: optimal inference requires keeping track of
  _every possible combination_ of the ways that each sound you heard could be
  categorized.  Even when the number of clusters is _known_, this has
  exponential complexity (there are $2^n$ ways to categorize $n$ sounds into two
  different categories).

Address these using a second family of approximate algorithms: sequential
monte-carlo.  These are _online_ algorithms, which update their beliefs about
the sturcture of the data as each observation comes in.  Furthermore, they
provide a natural way to explore limits on the amount of uncertainty that the
agent can track, and thus provide a potential bridge between the computational
and algorithmic levels of analysis [@Sanborn2010].


## What

### Samples vs. particles

MCMC: sweep once through data, get one hypothesis about how clustered.  Sweep
again, and revise that hypothesis to get a new sample.  Eventually, collection
of samples approximates the probability of ways of clustering the given data.
Qualit of approximation depends on how many samples you can get (so, time)

SMC: Start with $N$ "particles", each of which is one hypothesis.  Sweep once
through the data, updating each particle as you go, one observation at a time.
Each particle has a _weight_, which is how plausible it is given all the data
seen so far, and the whole set of (weighted) particles provides an approximation
of the probability of each possible clustering.  The quality of the approxmation
depends in large part on the number of particles (analogously to the number of
samples from the MCMC algorithm), as well as on the weights (more uniform
weights are better).








  


Bayesian nonparametrics provide a principled framework for understanding
distributional learning: they don't impose a maximum number of categories, and
only have an inductive bias towards simplicity.  
