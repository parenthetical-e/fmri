plotMeanModelScore <- function(meanScore){
    # Given all the Ss bic data (from processModelScore.R)
    # make a nice plot for each ROI.
    library(ggplot2)

    # Plot!
    for(roi in levels(meanScore$roi_names)){
        quartz(height=6, width=10)  ## real big for all the data!
        roiData <- meanScore[meanScore$roi_names == roi, ]
        p <- ggplot(roiData, aes(x=score_class, y=bic - min(bic), label=dm))
        p <- p + opts(title=roi)
        p <- p + geom_point()
        p <- p + stat_summary(fun.y = "mean", geom="point", color="red")        
        p <- p + ylim(c(0,10))
        p <- p + geom_text(hjust=0, vjust=0, size=3)
        plot(p)
        ggsave(paste(roi,".pdf",sep=""))
    }
    # Get rid of all the open windows...
    graphics.off()
}
