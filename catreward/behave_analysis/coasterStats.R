coasterStats <- function(num){
	# For subject num, return statistics (M, SD) of coaster 
	# parameters (condtionalized by gains and losses) 
    # for pavlov A and B combined.
    # 
    # Needs to be run from the folder containing the data
    # 
    # USE: to run all Ss:
    # allStats <- NULL; for(i in 101:118){tab <- coasterStats(i); allStats <- rbind(allStats, tab)}
    #
    # and wrote it by
    # write.table(allStats, "101_118_coaster_stats.txt", row.names=FALSE, sep=",", quote=FALSE)
    

    # Create names, read in the data and
    # name the cols for easy access.
	pA <- paste(num, "_126_pavlov_A.dat", sep="")
	pB <- paste(num, "_54_pavlov_B.dat", sep="")
    
    dAB <- rbind(read.table(pA), read.table(pB))
    colnames(dAB) <- c("cat", "width", "angle", "ignore", "gl")

    # Filter the data by gains or losses
    # also remove any jitter trials (= 0)
    gMask <- (dAB[["gl"]] == 1) & (dAB[["cat"]] > 0)
    lMask <- dAB[["gl"]] == -1 & (dAB[["cat"]] > 0)
    
    # Calc the stats, and combined them.
    gStats <- c(mean(dAB[["width"]][gMask]), 
                sd(dAB[["width"]][gMask]),
                mean(dAB[["angle"]][gMask]), 
                sd(dAB[["angle"]][gMask]))

    lStats <- c(mean(dAB[["width"]][lMask]), 
                sd(dAB[["width"]][lMask]),
                mean(dAB[["angle"]][lMask]), 
                sd(dAB[["angle"]][lMask]))
    stats <- rbind(gStats, lStats)

    # Add subject and kind (g or l) factors
    # and pretty up the final table.
    stats <- cbind(stats, c(num, num))
    stats <- cbind(stats, c("g", "l"))
    colnames(stats) <- c("M_width", "SD_width", "M_angle", 
                         "SD_angle", "sub","gl")

    stats <- as.data.frame(stats, row.names=FALSE)
}


