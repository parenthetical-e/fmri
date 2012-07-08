import.all.scores <- function(suffix){
    # Using <suffix> to select the right data, combined each Ss 
    # data into a single DF, and then process them.

    subjects <- c(101, 102, 103, 104, 105, 106, 108, 109, 111, 112, 113, 114, 
                  115, 116, 117, 118)

    # Get the data
    all_data <- NULL
    for(sub in subjects){
        fname <- paste(sub, "_", suffix, ".txt", sep="")
        data <- read.table(fname, sep="\t", header=TRUE)
        all_data <- rbind(all_data, data)
    }
    
    # Factorize some things
    all_data[["sub"]] <- as.factor(all_data[["sub"]])
    
    # Add significance cutoff levels, 
    # as factors.
    p_levels <- rep('insignificant', nrow(all_data))
    #p_levels[all_data[["f_pvalue"]] < 0.10] <- "weak_trend"
    #p_levels[all_data[["f_pvalue"]] < 0.08] <- "trend"
    p_levels[all_data[["f_pvalue"]] < 0.06] <- "significant"
    all_data[["p_levels"]] <- as.factor(p_levels)

    # Create better ROI names, 
    # catreward specific
    roi_names <- unique(all_data[["roi"]])
    new_names <- rep("replace", nrow(all_data))
    for(roi in roi_names){
        splitup <- strsplit(roi, '_|\\W', perl=TRUE)[[1]]
            ## split by non-word OR underscore
        drop_pre_post_fix <- splitup[2:(length(splitup)-2)]
        drop_empty <- drop_pre_post_fix[drop_pre_post_fix != ""]
        new_name <- paste(drop_empty, collapse="_")
        new_names[all_data[["roi"]] == roi] <- new_name
    }
    all_data[["roi_names"]] <- as.factor(new_names)
    all_data
}
