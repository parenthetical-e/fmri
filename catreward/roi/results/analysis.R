analysis <- function(suffix, norm){
    # A master script for catreward roi model analysis
    source("~/Code/fmri/catreward/roi/results/filterdf.R")
    source("~/Code/fmri/catreward/roi/results/import.all.scores.R")
    source("~/Code/fmri/catreward/roi/results/reclassify.R")
    source("~/Code/fmri/catreward/roi/results/score.stats.R")
    source("~/Code/fmri/catreward/roi/results/normalize.R")
    source("~/Code/fmri/catreward/roi/results/m.Ss.ftest.R")
    
    # Read in process all the scores
    scores <- import.all.scores(suffix)

    # Was each model for each ROI significant by 
    # Ss-average omnibus F-test?  (F data was average
    # of each S taken from the pythonic regressions).
    sig_results <- m.Ss.ftest(scores)

    # Norm!
    if(norm == "model_00"){
        scores <- norm.model_00(scores, 1:7)
    } else if(norm == "mean"){
        scores <- norm.mean(scores, 1:7)
    } else if(norm == "min"){
        scores <- norm.min.delta(scores, 1:7)
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
    stats$fvalue_raw <- sig_results$fvalue
    stats$p_levels <- sig_results$p_levels

    # drop all 'invert' coding entries,
    # these are identical (in a linear model sense)
    # to their un-inverted matches, i.e.
    # B * (-1)*X = (-1)*B * X
    # Why did I not see this from the start?  Idiot.
    scores <- filterdf(scores, "recode_class", c("standard", "positive"))
    stats <- filterdf(stats, "recode_class", c("standard", "positive"))

    # And return both scores and their stats
    list(scores=scores, stats=stats)
}


analysis.aic <- function(suffix){
    # A modified version of analysis() focused on AIC scores
    
    # Read in process all the scores
    scores <- import.all.scores(suffix)
   
    # Was each model for each ROI significant by 
    # Ss-average omnibus F-test?  (F data was average
    # of each S taken from the pythonic regressions).
    sig_results <- m.Ss.ftest(scores)
  
    # Norm by model_00
    scores <- norm.model_00(scores, 1:7)
    
    # Calc the stats, then attach the F-test results
    stats <- score.stats(scores)

    # Drop all scores but aic (and F)
    stats <- stats[ ,c("aic","dm","roi_names","stat")]
    stats$fvalue <- sig_results$fvalue
    stats$p_levels <- sig_results$p_levels
    print(str(stats))
    
    # Rank AIC:
    # Compare AIC to best for each ROI
    stats$aic_ranked <- rep(0, nrow(stats))
    for(roi in unique(stats$roi_names)){
        roi_mask <- stats$roi_names == roi
        best_aic <- min(stats[roi_mask, ])
        stats$aic_ranked[roi_mask] <- stats$aic[roi_mask]- best_aic
    }

    # Get Akaike likelihood then normalize it, 
    # producing the weights
    stats$aic_likelihood <- exp(-0.5 * stats$aic_ranked) 
    stats$aic_w <- stats$aic_likelihood / sum(exp(-0.5 * stats$aic_ranked))
        ## Forumula taken from:
        ## Anderson et al. Null Hypothesis Testing: Problems, Prevalence, 
        ## and an Alternative. The Journal of Wildlife Management (2000) 
        ## vol. 64 (4) pp. 912-923
 
    # Get the 95% set
    stats$selected_model <- rep("FALSE", nrow(stats))
    stats <- stats[order(stats$aic_w), ] ## Order by aic_w
    infocount <- 0
    for(ii in 1:nrow(stats)){
        stats$selected_model[ii] <- "TRUE"
        infocount <- infocount + stats$aic_w[ii]
        if(infocount >= 0.95){ break() }
    }

    # Create useful metadata and do some filtering
    stats <- reclassify.rois(stats)
    stats <- reclassify.scores(stats)
    stats <- reclassify.as.bilateral(stats)
 
    # Relevant to run4.py (and beyond) only
    # drop all 'invert' coding entries,
    # these are identical (in a linear model sense)
    # to their un-inverted matches, i.e.
    # B * (-1)*X = (-1)*B * X
    # Why did I not see this from the start?  Idiot.
    scores <- filterdf(scores, "recode_class", c("standard", "positive"))
    stats <- filterdf(stats, "recode_class", c("standard", "positive"))
}
