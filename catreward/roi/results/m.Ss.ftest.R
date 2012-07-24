m.Ss.ftest <- function(score_data){
    source("~/Code/fmri/catreward/roi/results/score.stats.R")
    
    # Get means, exp the fvalue
    stats <- score.stats(score_data)

    # Assume insignificant, loop over each row
    # of stats and see if its fvalue is significance
    # or trending
    p_levels <- rep('insignificant', nrow(stats))
    for(ii in 1:nrow(stats)){
        row <- stats[ii, ]

        df1 <- ifelse(row$df_model == 0, 1, row$df_model)
        fvalue <- row$fvalue

        f_thresh_05 <- qf(.94, df1, Inf)  ## We have effectivly Inf df2
        f_thresh_10 <- qf(.89, df1, Inf)
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
    results
 }
