* Methods
    * Point to chen and liu (2000), and Fearnhead (2004).
    * intuitive explanation of what's going on:
        * each particle samples how to categorize the next observation
        * when the weights get too lopsided, re-sample the particles so that
          good solutions (probabilistically) replace bad ones.
* Results
    * Figures
        * "Success" as a function of alpha, number of particles, and number of
          observations.
        * Gibbs sampler baseline (just do for one num. obs. because doesn't seem
          to change much)
