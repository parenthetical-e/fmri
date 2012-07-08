m.plot.AIC <- function(score_stats, plot_name){
    # Given all the Ss bic data (from processModelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    # get M only
    M <- score_stats[score_stats$stat == "M", ]
    
    M$se <-  score_stats[score_stats$stat == "SE", ]$aic
        ## add SE as a factor to M

    # And plot!
    for(roi in levels(M$roi_names)){
        pdf(height=6, width=10)  ## real big for all the data!
        print(roi)
        roi_data <- M[M$roi_names == roi, ]
        limits <- aes(ymin=aic - se, ymax=aic + se)
        p <- ggplot(data=roi_data, aes(
                                       x=dm, 
                                       y=aic, 
                                       fill=score_class))
        p <- p + geom_bar()
        p <- p + geom_errorbar(limits, size=0.25, color="black", width=.25)
        p <- p + coord_flip()
        p <- p + geom_hline(aes(yintercept=0), color="black")
        p <- p + geom_hline(aes(yintercept=-2), color="red", alpha=0.8)
        p <- p + geom_hline(aes(yintercept=-4), color="orange", alpha=0.8)
        p <- p + opts(title=paste(paste("m_", 
                                        plot_name, 
                                        "_aic_", 
                                        roi,sep="")))
        p <- p + scale_colour_brewer(palette="Dark2")
        p <- p + theme_bw()

        plot(p)
        ggsave(paste("m_plot_", plot_name, "_aic_", roi, ".pdf", sep=""))
    }

    # Get rid of all the open windows...
    graphics.off()
}


m.plot.relativeAIC <- function(score_stats, plot_name){
    # Given all the Ss bic data (from processModelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    # get M only
    M <- score_stats[score_stats$stat == "M", ]
    
    # And plot!
    for(roi in levels(M$roi_names)){
        pdf(height=6, width=10)  ## real big for all the data!
        print(roi)
        roi_data <- M[M$roi_names == roi, ]
        p <- ggplot(data=roi_data, aes(
                                       x=dm, 
                                       y=exp((min(aic) - aic) / 2),
                                       fill=score_class))
        p <- p + geom_bar()
        p <- p + coord_flip()
        p <- p + geom_hline(aes(yintercept=0), color="black")
        p <- p + opts(title=paste(paste("m_", 
                                        plot_name, 
                                        "_aic_", 
                                        roi,sep="")))
        p <- p + scale_fill_brewer(palette="Dark2")
        p <- p + theme_bw()

        plot(p)
        ggsave(paste("m_plot_", plot_name, "_relaic_", roi, ".pdf", sep=""))
    }

    # Get rid of all the open windows...
    graphics.off()
}


m.plot.relativeAIC.bilat <- function(score_stats, plot_name){
    # Given all the Ss bic data (from processModelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")
    
    M <- filterdf(score_stats, "stat", c("M"))

    # And plot!
    for(roi in levels(M$bilat_class)){
        pdf(height=6, width=10)  ## real big for all the data!
        print(roi)
        roi_data <- filterdf(M, "bilat_class", c(roi))
        p <- ggplot(data=roi_data, aes(
                                       x=dm, 
                                       y=exp((min(aic) - aic) / 2),
                                       fill=score_class))
        p <- p + stat_summary(fun.y = "mean", geom="bar")        
        p <- p + coord_flip()
        p <- p + geom_hline(aes(yintercept=0), color="black")
        p <- p + opts(title=paste(paste("m_", 
                                        plot_name, 
                                        "_aic_", 
                                        roi,sep="")))
        p <- p + scale_fill_brewer(palette="Dark2")
        p <- p + theme_bw()

        plot(p)
        ggsave(paste("m_plot_", plot_name, "_relaic_", roi, ".pdf", sep=""))
    }

    # Get rid of all the open windows...
    graphics.off()
}


