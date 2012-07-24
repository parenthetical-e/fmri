norm.min.delta <- function(score_data, index){
    # The way (right) way for normalizing AIC scores.  
    # But just do to to everything.
        
    for(sub in unique(score_data$sub)){
        for(roi in unique(score_data$roi_names)){
            mask <- {
                (score_data$sub %in% sub) & 
                (score_data$roi_names %in% roi)
            }
            srm <- score_data[mask, ]
            mins <- sapply(srm[ ,index], min)
            for(cnt in 1:nrow(srm)){
                srm[cnt,index] <- srm[cnt,index] - mins
            }
            score_data[mask,] <- srm
        }
    }
    score_data
}


norm.model_00 <- function(score_data, index){
    # For each sub, model, norm to model_00
    # for each score in the index.
    
    for(sub in unique(score_data$sub)){
        for(roi in unique(score_data$roi_names)){
            mask <- {
                (score_data$sub %in% sub) & 
                (score_data$roi_names %in% roi)
            }
            srm <- score_data[mask, ]
            model_00_data <- srm[srm$model == "model_00", ][index]
            for(cnt in 1:nrow(srm)){
                srm[cnt,index] <- srm[cnt,index] - model_00_data
            }
            score_data[mask,] <- srm
        }
    }
    score_data
}


norm.mean <- function(score_data, index){
    # For each sub, model, norm to model_00
    # for each score in the index.
    
    for(sub in unique(score_data$sub)){
        for(roi in unique(score_data$roi_names)){
            mask <- {
                (score_data$sub %in% sub) & 
                (score_data$roi_names %in% roi)
            }
            srm <- score_data[mask, ]
            means <- sapply(srm[ ,index], mean)
            for(cnt in 1:nrow(srm)){
                srm[cnt,index] <- srm[cnt,index] - means
            }
            score_data[mask,] <- srm
        }
    }
    score_data
}

