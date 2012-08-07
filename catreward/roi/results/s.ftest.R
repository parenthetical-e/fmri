s.ftest <- function(score_data, bonf_corr){
    source("~/Code/fmri/catreward/roi/results/score.stats.R")
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    score_data <- reclassify.rois(score_data)
    score_data <- reclassify.scores(score_data)
    score_data <- reclassify.as.bilateral(score_data)
    
    # Relevant to run4.py (and beyond) only
    # drop all 'invert' coding entries,
    # these are identical (in a linear model sense)
    # to their un-inverted matches, i.e.
    # B * (-1)*X = (-1)*B * X
    # Why did I not see this from the start?  Idiot.
    score_data <- filterdf(score_data, "recode_class", c("standard"))
    score_data <- filterdf(score_data, "acc_split", c("no"))

    alldm <- unique(score_data$dm)
    dropdm <- c("resp1_resp6", "gauss_gauss_opp","exp_exp_opp")
    keepdm <- alldm[!alldm %in% dropdm]
    score_data <- filterdf(score_data, "dm", keepdm)

    # Get means, exp the fvalue
    stats <- score.stats(score_data)
    stats <- filterdf(stats, "stat",c("M"))

    # Assume insignificant, loop over each row
    # of stats and see if its fvalue is significance
    # or trending
    p_levels <- rep('insignificant', nrow(stats))
    for(ii in 1:nrow(stats)){
        row <- stats[ii, ]

        df1 <- ifelse(row$df_model == 0, 1, row$df_model)
        fvalue <- row$fvalue

        p_thresh <- 0.05 / bonf_corr
        p_trend <- 0.10 / bonf_corr

        f_thresh_05 <- qf(1-p_thresh, df1, Inf)  ## We have effectivly Inf df2
        f_thresh_10 <- qf(1-p_trend, df1, Inf)
        if(fvalue >= f_thresh_05){
            p_levels[ii] <- 'significant'
        } else if(fvalue >= f_thresh_10){
            p_levels[ii] <- 'trend'
        }
    }

    # Included indentifying info on the significance results,
    # the results themselves and return.
    results <- list(dm=stats$dm, 
                    roi_names=stats$roi_names, 
                    fvalue=stats$fvalue, 
                    p_levels=p_levels)
    results <- as.data.frame(results)
    results[['p_levels']] <- as.factor(results[['p_levels']])
    
    results <- reclassify.rois(results)
    results <- reclassify.scores(results)
    results <- reclassify.as.bilateral(results)
    results
 }
