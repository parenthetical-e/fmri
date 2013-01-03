score.stats <- function(score_data){
    # Calculate stats, conditionalized on (model AND roi_names)
    # using scores normalized based on model_00.
    
    # TODO -- first norm by model_00, for each Ss and Roi
    
    # Then stats, conditionalized on:
    cond_on <- list(dm=score_data$dm, roi_names=score_data$roi_names)
    N = aggregate(score_data[,1:8], cond_on, length)

    SD = aggregate(score_data[,1:8], cond_on, sd)
    M = aggregate(score_data[,1:8], cond_on, mean)
    SE <- SD[ ,3:10] / sqrt(N[ ,3:10])
    SE <- cbind(SD[,1:2],SE)

    # Create levels for the type of stat
    M$stat <- rep("M", nrow(M))
    N$stat <- rep("N", nrow(N))
    SD$stat <- rep("SD", nrow(SD))
    SE$stat <- rep("SE", nrow(SE))

    # Assemble returned DF
    stats <- rbind(M, SD, N, SE)
    stats$stat = as.factor(stats$stat)
    stats
}


score.stats.aic_w.familymeans <- function(aic){
    # Calculate means for the model families
    
    cond_on <- list(model_family=aic$model_family,
                    roi_names=aic$roi_names)
    M = aggregate(aic[ ,"aic_w"], cond_on, mean, data=aic)
    M <- M[order(M$roi_names, M$x), ]
    M
}


score.stats.aic_w <- function(aic){
    # Calculate means for each model
    source("~/Code/fmri/catreward/roi/results/filterdf.R")
    source("~/Code/fmri/catreward/roi/results/import.all.scores.R")
    source("~/Code/fmri/catreward/roi/results/reclassify.R")
    source("~/Code/fmri/catreward/roi/results/score.stats.R")
    source("~/Code/fmri/catreward/roi/results/normalize.R")
    source("~/Code/fmri/catreward/roi/results/s.ftest.R")

    # Then stats, conditionalized on:
    cond_on <- list(dm=aic$dm, roi_names=aic$roi_names)
    N = aggregate(aic[ ,"aic_w"], cond_on, length)
    SD = aggregate(aic[ ,"aic_w"], cond_on, sd)
    M = aggregate(aic[ ,"aic_w"], cond_on, mean)
    SE <- SD[ ,"x"] / sqrt(N[ ,"x"])

    # Assemble returned DF
    stats <- list("M"=M$x, "SE"=SE, "roi_names"=M$roi_names, "dm"=M$dm)
    stats <- as.data.frame(stats)
    
    # Create metadata
    stats <- reclassify.rois(stats)
    stats <- reclassify.scores(stats)
    stats <- reclassify.as.bilateral(stats)
    
    stats <- stats[order(stats$roi_names, stats$M), ]
    stats
}
