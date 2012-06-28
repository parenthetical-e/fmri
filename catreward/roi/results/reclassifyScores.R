reclassifyScores <- function(scoreD){
    # Uses the DM names to reclassify models into 
    # broader categories.  The goal is to asesss
    # consistency between Ss.

    classes <- scoreD[, "dm"]
    splitUp <- strsplit(as.character(classes), '_')

    generalCat <- rep(NA, nrow(scoreD))
    for(ii in 1:length(splitUp)){
        splt <- splitUp[[ii]]

        # First figure out generalCat
        if(('rpe' %in% splt)){ 
            generalCat[ii] <- 'rpe'
        } else if('value' %in% splt){
            generalCat[ii] <- 'value'
        } else if(('acc' %in% splt) | ('gl' %in% splt)){
            generalCat[ii] <- 'reward'
        } else if(('rdis' %in% splt) | ('exp' %in% splt) | ('gauss' %in% splt)){
            generalCat[ii] <- 'similiarity'
        } else if('distance' %in% splt){
            generalCat[ii] <- 'distance'
        } else if(('resp1' %in% splt) | ('cresp1' %in% splt) | ('rt' %in% splt)){
            generalCat[ii] <- 'response'
        } else if('0' %in% splt){
            generalCat[ii] <- 'univariate'
        } else { print(paste("No generalCat detected at ", ii, "-", splt)) }
    }
    scoreD$score_class <- as.factor(generalCat)
    scoreD
}

