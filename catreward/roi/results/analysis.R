analysis <- function(suffix, keep=NA){
    # A master script for catreward roi model analysis
    
    source("~/Code/fmri/catreward/roi/results/importAllScores.R")
    source("~/Code/fmri/catreward/roi/results/reclassifyScores.R")
    source("~/Code/fmri/catreward/roi/results/reclassifyRois.R")
    source("~/Code/fmri/catreward/roi/results/scoreStats.R")

    scores <- importAllScores(suffix)
    scores <- reclassifyRois(scores)
    scores <- reclassifyScores(scores)

    print(paste("Overall mean AIC / BIC was ",
                mean(scores$aic), " / ",
                mean(scores$bic),
                sep=""))
    
    if(sum(is.na(keep)) == 0){
        # Build a mask
        mask <- rep(FALSE, nrow(scores))
        for(name in keep){
            mask <- mask | (scores$dm == name)
        }

        # use it to filter scores
        scores <- scores[mask, ]

        # and relevel too.
        scores <- droplevels(scores)
    }

    # Get stats for Ss
    stats <- scoreStats(scores)

    # TOOD Do plots?

    # Return
    list(scores=scores, stats=stats)
}

