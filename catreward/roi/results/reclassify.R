reclassify.rois <- function(score_data){
    # Uses the DM names to reclassify models into 
    # broader categories.  The goal is to asesss
    # consistency between Ss.

    classes <- score_data[, "roi_names"]
    splitup <- strsplit(as.character(classes), '_')

    roi_class <- rep(NA, nrow(score_data))
    for(ii in 1:length(splitup)){
        splt <- splitup[[ii]]

        # First figure out roi_class
        if(('Cingulate' %in% splt)){ 
            roi_class[ii] <- 'cingulate'
        } else if('Frontal' %in% splt){
            roi_class[ii] <- 'frontal'
        } else if('Accumbens' %in% splt){
            roi_class[ii] <- 'ventral_striatum' 
        } else if('Caudate' %in% splt){
            roi_class[ii] <- 'caudate'
        } else if('Putamen' %in% splt){
            roi_class[ii] <- 'putamen'
        } else if(('Cuneal' %in% splt) |
                  ('Precuneous' %in% splt) | 
                  ('Occipital' %in% splt)){
            roi_class[ii] <- 'visual'
        } else if('Hippocampus' %in% splt){
            roi_class[ii] <- 'hippocampus'
        } else if(('Amygdala' %in% splt) | ('Insular' %in% splt)){
            roi_class[ii] <- 'limbic'
        } else { print(paste("No roi_class detected at ", ii, "-", splt)) }
    }
    score_data$roi_class <- as.factor(roi_class)
    score_data
}


reclassify.as.bilateral <- function(score_data){
    # Use roi_class to group ipsilateral ROIs to bilateral
    # ones.  Reqires that reclassify.rois() has been run.

    classes <- score_data[, "roi_names"]
    splitup <- strsplit(as.character(classes), '_')

    bilat_class <- rep(NA, nrow(score_data))
    for(ii in 1:length(splitup)){
        splt <- splitup[[ii]]
        # If there is a the left and rights in splt
        # drop them and add to bilat_class
        if(('Left' %in% splt) | ('Right' %in% splt)){
            bilat_class[ii] <- paste(splt[-1],sep="_",collapse='_')
                ## last and right will be the first element
                ## in splt
        } else {
            bilat_class[ii] <- paste(splt,sep="_",collapse='_')
        }         
    }         
    score_data$bilat_class <- as.factor(bilat_class)
    score_data
}


reclassify.scores <- function(score_data){
    # Uses the DM names to reclassify models into 
    # broader categories.  The goal is to asesss
    # consistency between Ss.

    classes <- score_data[, "dm"]
    splitup <- strsplit(as.character(classes), '_')

    gen_cat <- rep(NA, nrow(score_data))
    outcome_class <- rep(NA, nrow(score_data))
    recode_class <- rep('standard', nrow(score_data))
    acc_split <- rep('no', nrow(score_data))
    for(ii in 1:length(splitup)){
        splt <- splitup[[ii]]

        # First figure out gen_cat
        if(('rpe' %in% splt)){ 
            gen_cat[ii] <- 'rpe'
        } else if('value' %in% splt){
            gen_cat[ii] <- 'value'
        } else if('cummean' %in% splt){
            gen_cat[ii] <- 'control_cum_reward'
        } else if(('acc' %in% splt) | 
                  ('gl' %in% splt)){
            gen_cat[ii] <- 'control_reward'
        } else if(('rdis' %in% splt) | 
                  ('exp' %in% splt) |
                  ('gauss' %in% splt)){
            gen_cat[ii] <- 'control_similarity'
        } else if(('distance' %in% splt) |
                  ('width' %in% splt) |
                  ('angle' %in% splt)){
            gen_cat[ii] <- 'control_similarity'
        } else if(('resp1' %in% splt) | 
                  ('cresp1' %in% splt) | 
                  ('rt' %in% splt)){
            gen_cat[ii] <- 'control_response'
        } else if('0' %in% splt){
            gen_cat[ii] <- 'boxcar'
        } else { print(paste("No gen_cat detected at ", ii, "-", splt)) }

        # Then do outcome_class
        if('acc' %in% splt) { outcome_class[ii] <- 'acc' }
        else if('gl' %in% splt) { outcome_class[ii] <- 'gl' }

        # Then sort based on the coding scheme
        if('invert' %in% splt) { recode_class[ii] <- 'invert'}
        else if ('pos' %in% splt) { recode_class[ii] <- 'positive'}
        
        # Regressors are split up by accuracy?
        if(('0' %in% splt) & 
           ('1' %in% splt) &
           (gen_cat[ii] != 'boxcar')) { acc_split[ii] <- 'yes' }
    }

    score_data$model_family <- as.factor(gen_cat)
    score_data$outcome_class <- as.factor(outcome_class)
    score_data$recode_class <- as.factor(recode_class)
    score_data$acc_split <- as.factor(acc_split)
    score_data
}


