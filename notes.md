# Learning your language as it comes

Using sequential monte carlo (aka particle filter) approximations of
nonparametric Bayesian clustering models for language acquisition.


Explore a method for approximate inference that's more psychologically
plausible: learns from one data point at a time, efficiently.  Doesn't require
an unlimited tolerance of uncertainty.


## Why

Babies need to learn how many phonetic categories their language has from un- or
weakly-labeled inputs.  Distributional learning theories say that you can treat
this as a clustering problem: detect how many "clusters" or "clumps" of sounds
there are in your acoustic input.

We know babies (and adults) pick up on the statistical structure of language
input.  Basically two ways this has been modeled: normative/computational-level
models and cognitive/algorithmic-level models [@Marr1972].

Normative models like Bayesian nonparametric models are
theoretically/conceptually elegent.  Define/describe how much you can learn
given the statistical structure of the world and a model of how it works.
Establish what it's _possible_ to learn starting from certain, clearly stated
assumptions.

They've provided lots of insight (that it's
_possible_ to learn from distributions, that learning at multiple levels
simulatneously helps all around, that there's a link between acquisition and
adaptation).  Normative models are useful to put broad constraints on what's
_possible_, to set the boundaries (or to evaluate different ways of
conceptualizing a problem), but they are _computational level_ models, not
_cognitive (algorithmic) models_.



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

### Bayesian non-parametric models

Have some data points $x_{1:N}$.  We know that these data were generated from
some number of clusters $K$, where $K$ could be (in principle) anywhere between
1 and $N$ (the number of data points).  A complete clustering of these data
points has two parts: the cluster each data point is assigned to (denoted
$c_{1:N}$), and the properties of the clusters themselves (which in the example
below are the mean $\mu_k$ and variance $\sigma^2_k$ of a normal distribution,
but in general are the parameters of some probability distribution).

Bayesian nonparametric models aim to find the posterior probability of
clusterings given some particular data, $p(c_{1:N}, \mu_{1:K}, \sigma^2{1:K} |
x_{1:N})$.  In many cases, it's easier to do this in two stages: first, compute
the distribution of cluster assignments $p(c_{1:N} | x_{1:N})$ (marginalizing
over possible clusters _parameters_), and then computing the distribution over
cluster properties $p(\mu_{1:K}, \sigma^2_{1:K} | c_{1:N}, x_{1:N})$.  The
reason for this is that when using a conjugate prior for the cluster parameters,
there's no need to actually know the exact properties of cluster to evaluate how
good it is; all that's needed is the data points that are assigned to that
cluster (and some measure of how similar they are to each other).



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


## Simulations

Vary:
  * number of particles
  * concentration parameter α
  * number of observations seen by the model
  * (maybe: rejuvination threshold)

Using data based on VOT distributions estiamted from:
  * the Buckeye corpus of conversational English [@Nelson2017]
  * two and three components from @Lisker1964 [following @McMurray2009b] (see results/run3)
  * (TODO: single-talker VOT distributions from Buckeye?)

Measure number of clusters, according to:
  * (approximate) maximum a-posteriori: particle with highest posterior
    probability
  * marginal distribution of cluster counts (approximate posterior probability
    of each number of clusters, across runs)
  * expected number of clusters (weighted average across particles)

And compare with the standard batch algorithm (Gibbs sampler).

## Discussion 

* Does it work? Kinda.
* Problem: forget history.  Don't keep track of full uncertainty.  Can never go
  back to simpler solution.  (could be easy to fix: just allow "jumps" where you
  combine clusters...need to work out math, but it should be a matter of doing
  basically a MH step, right?)
* Compare to other approaches:
    * Joe adn bob mixture of gaussians.  Spiritually similar but doesn't have
      the same interpretation (inference).  Hard to see how it connects with
      other levels (lexical etc.)
    * Connectionist models.....???


## Conclusion

It's possible to get a pretty good approximation of ideal inference with a
finite number of hypotheses. -> WITHOUT making psychologically implausible
assumptions like batch processing and infinite data.


# Follow-ups

Order effects: adaptation with a small number of particles, look at correlation
between responses etc.  Compare w/ hysterisis (Tuller and Lancia?)

Connection with toscano and mcmurray model: one-particle solution?

# Poster

Again, what's the point?

1. language acquisition: need to figure out categories based on unlabled
   observations.
2. Bayesian models (computational level).  Treat it as a inference problem:
   prior probability on number of categories (potentially infinite) with a
   simplicity bias.  Combine with likelihood of data under each number of
   categories.
3. This perspective has been **pretty successful!**  BIg problem:
   _computational_ level.  how could a situated agent with limited resources
   ever do this?

Conclusion 

1. Can learn the distrbution of cues as observations come one by one.
2. But need some kind of 'cleanup' to actually make an accurate inference about
   the number of clusters (which is important for acquiring linguistic
   knowledge...need to hook into lexicon etc.)

## What I want people to take away:

* SMC is a way to bridge computational and algorithmic/psychological models.
* But not totally straightforward: need to read out somehow.  eh I hate that.

It _works_, but can't necessarily read off stuff in the obvious way. The number
of categories the model has ever used isn't a good measure of what it thinks the
real complexity of the data is, because it's not a good measure of the number of
categories it'll use in the _future_.

## Want to show:

* logic of modeling: 
    * computational-level model: infer the number and structure of clusters
      based on data...in principle an infinite number of categories, but prefer
      simpler with a "rich get richer" prior.
    * algorithmic: only maintain a small number of hypotheses, these represent
      your uncertain beliefs about the way to cluster the data you've seen so
      far.
* goodness of fit summaries (number of clusters, etc.)
    * number of clusters
    * probability of "correct" solution (number of clusters with > 0.1% of
      observations, entropy of cluster prior, etc.)
* cluster solutions
    * distributions 
    * assignment similarity
* some visualization of algorithm, to contrast with Gibbs.
  
## Relation to previous work:

* sanborn and navarro stuff: learn categories with particles (what kind of
  categories?)
