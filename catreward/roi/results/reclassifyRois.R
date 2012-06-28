reclassifyRois <- function(scoreD){
    # Uses the DM names to reclassify models into 
    # broader categories.  The goal is to asesss
    # consistency between Ss.

    classes <- scoreD[, "roi_names"]
    splitUp <- strsplit(as.character(classes), '_')

    roiCat <- rep(NA, nrow(scoreD))
    for(ii in 1:length(splitUp)){
        splt <- splitUp[[ii]]

        # First figure out roiCat
        if(('Cingulate' %in% splt)){ 
            roiCat[ii] <- 'cingulate'
        } else if('Frontal' %in% splt){
            roiCat[ii] <- 'frontal'
        } else if('Accumbens' %in% splt){
            roiCat[ii] <- 'ventral_striatum' 
        } else if('Caudate' %in% splt){
            roiCat[ii] <- 'caudate'
        } else if('Putamen' %in% splt){
            roiCat[ii] <- 'putamen'
        } else if(('Cuneal' %in% splt) | ('Precuneous' %in% splt)){
            roiCat[ii] <- 'visual'
        } else if('Hippocampus' %in% splt){
            roiCat[ii] <- 'hippocampus'
        } else { print(paste("No roiCat detected at ", ii, "-", splt)) }
    }
    scoreD$roi_class <- as.factor(roiCat)
    scoreD
}

