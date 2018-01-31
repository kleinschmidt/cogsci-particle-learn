* Methods
    * Point to chen and liu (2000), and Fearnhead (2004).
    * intuitive explanation of what's going on:
        * each particle samples how to categorize the next observation
        * when the weights get too lopsided, re-sample the particles so that
          good solutions (probabilistically) replace bad ones.
* Analyses
    * Three-component data, too.
* Results
    * Figures
        * visualize input data
        * "Success" as a function of alpha, number of particles, and number of
          observations.  How to measure success?  $p(K=2|x)$?
        * distribution over number of components?
        * Gibbs sampler baseline (just do for one num. obs. and samples because
          doesn't seem to change much).  Just include this in the other figures.
* Figure out "the point"
