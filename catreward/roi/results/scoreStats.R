scoreStats <- function(scoreD){
    # Calculate stats, conditionalized on (model AND roi_names).

    # The stats:
    conditionalizeOn <- list(dm=scoreD$dm, roi_names=scoreD$roi_names)
    N = aggregate(scoreD[,1:7], conditionalizeOn, length)
    SD = aggregate(scoreD[,1:7], conditionalizeOn, sd)
    M = aggregate(scoreD[,1:7], conditionalizeOn, mean)

    # Create levels for the type of stat
    M$stat = rep("M", nrow(M))
    N$stat = rep("N", nrow(N))
    SD$stat = rep("SD", nrow(SD))
    
    # Assemble returned DF
    stats <- rbind(M,SD,N)
    stats$stat = as.factor(stats$stat)

    stats
}
