plotModelScore <- function(allData){
    # Given all the Ss aic data (from processModelScore.R)
    # make a nice plot for each ROI.
    library(ggplot2)

    # Order p_levels
    relev <- c("insignificant", "weak_trend", "trend", "significant") 
    allData$p_levels <- factor(allData$p_levels, levels = relev)

    # Plot!
    for(roi in levels(allData$roi_names)){
        quartz(width=30, height=5)  ## real big for all the data!
        roiData <- allData[allData$roi_names == roi, ]
        p <- ggplot(roiData, aes(x=dm, y=aic))
        p <- p + stat_summary(fun.y = "mean", geom="point")
#        p <- p + geom_point(aes(colour=p_levels))
        p <- p + scale_colour_brewer(palette="Blues")
        p <- p + opts(axis.text.x=theme_text(angle=-90, hjust=0))
        plot(p)
        ggsave(paste(roi,".pdf",sep=""))
    }
    # Get rid of all the open windows...
    graphics.off()
}
