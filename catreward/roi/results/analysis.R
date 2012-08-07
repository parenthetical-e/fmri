analysis <- function(suffix, norm){
    # A master script for catreward roi model analysis
    source("~/Code/fmri/catreward/roi/results/filterdf.R")
    source("~/Code/fmri/catreward/roi/results/import.all.scores.R")
    source("~/Code/fmri/catreward/roi/results/reclassify.R")
    source("~/Code/fmri/catreward/roi/results/score.stats.R")
    source("~/Code/fmri/catreward/roi/results/normalize.R")
    source("~/Code/fmri/catreward/roi/results/s.ftest.R")
    
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

    source("~/Code/fmri/catreward/roi/results/filterdf.R")
    source("~/Code/fmri/catreward/roi/results/import.all.scores.R")
    source("~/Code/fmri/catreward/roi/results/reclassify.R")
    source("~/Code/fmri/catreward/roi/results/score.stats.R")
    source("~/Code/fmri/catreward/roi/results/normalize.R")

    # Read in process all the scores
    scores <- import.all.scores(suffix)
         
    # Drop all scores but aic (and F)
    scores <- scores[ ,c("aic","dm","roi_names","sub")]

    # Create useful metadata and do some filtering
    scores <- reclassify.rois(scores)
    scores <- reclassify.as.bilateral(scores)
    scores <- reclassify.scores(scores)

    # Relevant to run4.py (and beyond) only
    # drop all 'invert' coding entries,
    # these are identical (in a linear model sense)
    # to their un-inverted matches, i.e.
    # B * (-1)*X = (-1)*B * X
    # Why did I not see this from the start?  Idiot.
    scores <- filterdf(scores, "recode_class", c("standard"))
    scores <- filterdf(scores, "acc_split", c("no"))
    
    # Drop these unneeded controls
    alldm <- unique(scores$dm)
    dropdm <- c("resp1_resp6", "gauss_gauss_opp","exp_exp_opp")
    keepdm <- alldm[!alldm %in% dropdm]
    scores <- filterdf(scores, "dm", keepdm) 

    # Drop and rdis data
    rdis_mask <- rep(TRUE, length(alldm))
    for(ii in 1:length(alldm)){
        dm <- alldm[ii]
        dm_split <- strsplit(as.character(dm), '_')
        if("rdis" %in% dm_split[[1]]){ rdis_mask[ii] <- FALSE }
    }
    print(rdis_mask)
    scores <- filterdf(scores, 'dm', alldm[rdis_mask])

    scores$aic_ranked <- rep(0, nrow(scores))
    scores$aic_likelihood <- rep(0, nrow(scores))
    scores$aic_w <- rep(0, nrow(scores))
    for(roi in unique(scores$roi_names)){
        for(ss in unique(scores$sub)){
            mask <- (scores$roi_names == roi) & (scores$sub == ss)

            # Get AIC values for this mask
            m_aic <- scores$aic[mask]
            
            # Rank them
            m_best_aic <- min(m_aic)
            m_aic_ranked <- m_aic - m_best_aic

            # Calculate the Akaike likelihood then normalize it, 
            # producing the weights
            m_aic_likelihood <- exp(-0.5 * m_aic_ranked) 
            m_aic_w <- m_aic_likelihood / sum(m_aic_likelihood)
                ## Forumula taken from:
                ## Anderson et al. Null Hypothesis Testing: Problems, Prevalence, 
                ## and a`n Alternative. The Journal of Wildlife Management (2000) 
                ## vol. 64 (4) pp. 912-923

            # Now put all the m_* back in place
            scores$aic_ranked[mask] <- m_aic_ranked
            scores$aic_likelihood[mask] <- m_aic_likelihood
            scores$aic_w[mask] <- m_aic_w
        }
    }

    # Calc means, then...
    # Get the 95% set
    #scores$selected_model <- rep("FALSE", nrow(scores))
    #scores <- scores[order(scores$aic_w), ] ## Order by aic_w
    #infocount <- 0
    #for(ii in 1:nrow(scores)){
    #    scores$selected_model[ii] <- "TRUE"
    #    infocount <- infocount + scores$aic_w[ii]
    #    if(infocount >= 0.95){ break() }
    #}
    scores
}
