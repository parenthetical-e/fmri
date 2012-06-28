processModelScores <- function(path){
    # Combined each Ss data into a single DF, 
    # and then process them.

    subjects <- c(101, 102, 103, 104, 105, 106, 108, 109, 111, 112, 113, 114, 
                  115, 116, 117, 118)

    # Move to the given path
    old_path <- getwd()
    setwd(path)

    # Get the data
    allData <- NULL
    for(sub in subjects){
        fname <- paste(sub, "_roi_model_scores.txt", sep="")
        data <- read.table(fname, sep="\t", header=TRUE)
        allData <- rbind(allData, data)
    }
    
    # Factorize some things
    allData[["sub"]] <- as.factor(allData[["sub"]])
    
    # Add significance cutoff levels, 
    # as factors.
    p_levels <- rep('insignificant', nrow(allData))
    p_levels[allData[["f_pvalue"]] < 0.10] <- "weak_trend"
    p_levels[allData[["f_pvalue"]] < 0.08] <- "trend"
    p_levels[allData[["f_pvalue"]] < 0.06] <- "significant"
    allData[["p_levels"]] <- as.factor(p_levels)

    # Create better ROI names, 
    # catreward specific
    roiNames <- unique(allData[["roi"]])
    newRoiNames <- rep("replace", nrow(allData))
    for(roi in roiNames){
        splitUp <- strsplit(roi,'_|\\W',perl=TRUE)[[1]]
            ## split by non-word OR underscore
        dropPrePosfix <- splitUp[2:(length(splitUp)-2)]
        dropEmpty <- dropPrePosfix[dropPrePosfix != ""]
        newName <- paste(dropEmpty, collapse="_")
        newRoiNames[allData[["roi"]] == roi] <- newName
    }
    allData[["roi_names"]] <- as.factor(newRoiNames)

    setwd(old_path)
    
    allData
}
