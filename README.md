# RAD-index
Relative Asymmetric Distance index for measuring niche overlap.

This is a repository for the index as outlined in Nicol, D. et al. 2021. Geometric approach for a dormant concept: incorporating asymmetry when measuring niche overlap.

The RAD index is a measure of niche similarity between two species (sets of points). It can be used with geographic points, niche space points, or trait space points. 

Along with this README.md file, four other files are provided.

**BackgroundEnvironment.csv** is a data file containing the reduced climatic space of New Zealand from six ecologically relevant variables using the locally linear embedding (LLE) algorithm provided by the dimRed package. 

**ExampleSpecies.csv** is a data file containing the reduced climatic niches of five *Celmisia* species located in New Zealand. The points were originally located from herbarium specimens and then reduced using the LLE algorithm with the same variables as in the background environment.

**RAD-functions.R** is an R.script containing the custom functions required as source to run the illustration of the RAD index.

**RAD-Illustration.Rmd** is a markdown file containing an example code to run the RAD index. Some software packages are required to run the code including *tidyverse*, *plyr*, *sf*, *readr*, *ecospat*, data.*table*, and *janitor*.