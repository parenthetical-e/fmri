topScores <- function(allD, num, score){
    # Return the top <num> models based on <score>, for each ROI, 
    # including some other useful info as well.
    
    otherScores <- c("bic", "aic", "r_adj", "fvalue")
    otherScores <- otherScores[otherScores != score]

    topTable <- NULL
    for(roi in levels(allD$roi_names)){
        rD <- allD[allD$roi_names == roi, ]
        sorted <- rD[with(rD, order(rD[[score]])), ]
            ## Use order() and with() to sort rD efficiently
            ## from:
            ## http://stackoverflow.com/questions/1296646/
            ## how-to-sort-a-dataframe-by-columns-in-r
       
        # Get the N top scores:
        # For these bigger is better
        if((score == "r_adj") | (score == "fvalue")){
            numRow <- nrow(sorted)
            topN <- sorted[(numRow - (num - 1)):numRow, ]
        } else {
            # Smaller is better for aic, bic
            topN <- sorted[1:num,]
        }
        
        # Calculate the percentage of otherScores that agree
        matchCount <- rep(0,num)
        for(oS in otherScores){
            oSorted <- rD[with(rD, order(rD[[oS]])), ]
            if((score == "r_adj") | (score == "fvalue")){  
                numRow <- nrow(sorted)
                oTopN <- oSorted[(numRow - (num - 1)):numRow, ]
            } else {
                oTopN <- oSorted[1:num, ]
            }
            match = oTopN$dm == topN$dm
            matchCount[match] <- matchCount[match] + 1
        }
        rTable <- cbind(1:num, 
                        as.character(topN$roi_names), 
                        as.character(topN$dm),  
                        topN[[score]],
                        topN$f_pvalue,
                        matchCount / length(otherScores))

        topTable <- rbind(topTable, rTable)
    }
    colnames(topTable) <- c('numindex', 'roi_names', 'dm', 
                            score, 'f_pvalue', 'agreement')
    topTable
}
