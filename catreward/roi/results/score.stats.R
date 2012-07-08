score.stats <- function(score_data){
    # Calculate stats, conditionalized on (model AND roi_names)
    # using scores normalized based on model_00.
    
    # TODO -- first norm by model_00, for each Ss and Roi
    
    # Then stats, conditionalized on:
    cond_on <- list(dm=score_data$dm, roi_names=score_data$roi_names)
    N = aggregate(score_data[,1:7], cond_on, length)

    SD = aggregate(score_data[,1:7], cond_on, sd)
    M = aggregate(score_data[,1:7], cond_on, mean)
    SE <- SD[ ,3:9] / sqrt(N[ ,3:9])
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