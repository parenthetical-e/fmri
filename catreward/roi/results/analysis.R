analysis <- function(suffix, norm){
    # A master script for catreward roi model analysis
    
    source("~/Code/fmri/catreward/roi/results/import.all.scores.R")
    source("~/Code/fmri/catreward/roi/results/reclassify.R")
    source("~/Code/fmri/catreward/roi/results/score.stats.R")
    source("~/Code/fmri/catreward/roi/results/normalize.R")
    
    # Read in process all the scores
    scores <- import.all.scores(suffix)
    if(norm == "model_00"){
        scores <- norm.model_00(scores, 1:7)
    } else if (norm == "mean"){
        scores <- norm.mean(scores, 1:7)
    }
    
    # Create some useful meta-data
    scores <- reclassify.rois(scores)
    scores <- reclassify.scores(scores)
    scores <- reclassify.as.bilateral(scores)

    # Calc some basic stats
    stats <- score.stats(scores)

    # and redo reclassify.
    stats <- reclassify.rois(stats)
    stats <- reclassify.scores(stats)
    stats <- reclassify.as.bilateral(stats)

    # And return both scores and their stats
    list(scores=scores, stats=stats)
}

