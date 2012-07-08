top.scores <- function(score_data, num, score){
    # Return the top <num> models based on <score>, for each ROI, 
    # including some other useful info as well.
    
    other_scores <- c("bic", "aic", "r_adj", "fvalue")
    other_scores <- other_scores[other_scores != score]

    topTable <- NULL
    for(roi in levels(score_data$roi_names)){
        rdata <- score_data[score_data$roi_names == roi, ]
        sorted <- rdata[with(rdata, order(rdata[[score]])), ]
            ## Use order() and with() to sort rdata efficiently
            ## from:
            ## http://stackoverflow.com/questions/1296646/
            ## how-to-sort-a-dataframe-by-columns-in-r
       
        # Get the N top scores:
        # For these bigger is better
        if((score == "r_adj") | (score == "fvalue")){
            numrow <- nrow(sorted)
            topn <- sorted[(numrow - (num - 1)):numrow, ]
        } else {
            # Smaller is better for aic, bic
            topn <- sorted[1:num,]
        }
        
        # Calculate the percentage of other_scores that agree
        match_count <- rep(0,num)
        for(other in other_scores){
            o_sorted <- rdata[with(rdata, order(rdata[[other]])), ]
            if((score == "r_adj") | (score == "fvalue")){  
                numrow <- nrow(sorted)
                o_topn <- o_sorted[(numrow - (num - 1)):numrow, ]
            } else {
                o_topn <- o_sorted[1:num, ]
            }
            match = o_topn$dm == topn$dm
            match_count[match] <- match_count[match] + 1
        }
        r_table <- cbind(1:num, 
                        as.character(topn$roi_names), 
                        as.character(topn$dm),  
                        topn[[score]],
                        topn$f_pvalue,
                        match_count / length(other_scores))

        top_table <- rbind(top_table, r_table)
    }
    colnames(top_table) <- c('numindex', 'roi_names', 'dm', 
                            score, 'f_pvalue', 'agreement')
    top_table
}
