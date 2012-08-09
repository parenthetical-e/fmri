s.boxplot.AIC <- function(score_data, plot_name){
    # Given all the Ss aic data (from processscore_dataodelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    # And plot!
    for(roi in levels(score_data$roi_names)){
        pdf(height=10, width=8)  ## real big for all the data!
        print(roi)
        roi_data <- score_data[score_data$roi_names == roi, ]
        p <- ggplot(data=roi_data, aes(x=dm, 
                                       y=aic_w, 
                                       colour=model_family)) 
        p <- p + geom_boxplot(notch=FALSE)
        p <- p + geom_hline(aes(yintercept=0), color="black")
        p <- p + coord_flip()
        p <- p + theme_bw()
        p <- p + opts(title=paste(paste("s_boxplot_", 
                                        plot_name, 
                                        "_aic_", 
                                        roi,sep="")))
        p <- p + scale_colour_brewer(palette="Dark2")
        plot(p)
        ggsave(paste("f_boxplot_", plot_name, "_aic_", roi, ".pdf", sep=""))
    }

    # Get rid of all the open windows...
    graphics.off()
}

