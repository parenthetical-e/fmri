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
                                       colour=score_class)) 
        p <- p + geom_boxplot(notch=FALSE)
        p <- p + stat_summary(fun.y = "mean", geom="point", shape=2)        
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


s.meanpoint.AIC <- function(score_data, plot_name){
    # Given all the Ss aic data (from processscore_dataodelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    # And plot!
    for(roi in levels(score_data$roi_names)){
        print(roi)
        pdf(height=4, width=6)  ## real big for all the data!
        roi_data <- score_data[score_data$roi_names == roi, ]
        p <- ggplot(data=roi_data, aes(x=dm, 
                                       y=aic_w, 
                                       colour=score_class)) 
        p <- p + stat_summary(fun.data = "mean_cl_boot",size=1)  
        p <- p + geom_hline(aes(yintercept=0), color="black")
        p <- p + coord_flip()
        p <- p + scale_colour_brewer(palette="Dark2")
        p <- p + ylab("Akaike Weight") + ylim(0, 0.10)
        p <- p + xlab("Model")
        p <- p + theme_bw()
        plot(p)
        ggsave(paste("f_meanpoint_", plot_name, "_aic_", roi, ".pdf", sep=""))
    }

    # Get rid of all the open windows...
    graphics.off()
}

s.meanpoint.AIC.bilat <- function(score_data, plot_name){
    # Given all the Ss aic data (from processscore_dataodelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    # And plot!
    for(roi in levels(score_data$bilat_class)){
        pdf(height=4, width=9)  ## real big for all the data!
        print(roi)
        roi_data <- score_data[score_data$bilat_class == roi, ]
        p <- ggplot(data=roi_data, aes(x=dm, 
                                       y=aic_w, 
                                       colour=score_class)) 
        p <- p + stat_summary(fun.data = "mean_se",size=1)
        p <- p + facet_grid(. ~ roi_names)
        p <- p + geom_hline(aes(yintercept=0), color="black")
        p <- p + coord_flip()
        p <- p + ylab("Akaike Weight") + ylim(0, 0.10)
        p <- p + xlab("Model")
        p <- p + scale_colour_brewer(palette="Dark2")
        p <- p + theme_bw()
        plot(p)
        ggsave(paste("f_meanpoint_bilat", plot_name, "_aic_", roi, ".pdf", sep=""))
    }

    # Get rid of all the open windows...
    graphics.off()
}


s.plot.AIC <- function(score_data, plot_name){
    # Given all the Ss aic data (from processscore_dataodelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")


    # And plot!
    for(roi in levels(score_data$roi_names)){
        pdf(height=5, width=7.5)  ## real big for all the data!
        print(roi)
        roi_data <- score_data[score_data$roi_names == roi, ]
        p <- ggplot(data=roi_data, aes(x=dm, 
                                       y=aic_w, 
                                       colour=score_class)) 
        p <- p + geom_point()
        #p <- p + stat_summary(fun.y = "mean_se", geom="bar", alpha=0.1)        
        p <- p + coord_flip()
        p <- p + opts(title=paste(paste("s_plot_", 
                                        plot_name, 
                                        "_aic_", 
                                        roi,sep="")))
        p <- p + scale_colour_brewer(palette="Dark2")
        p <- p + theme_bw()
        plot(p)
        ggsave(paste("s_plot_", plot_name, "_aic_", roi, ".pdf", sep=""))
    }
    # Get rid of all the open windows...
    graphics.off()
}


s.bars.AIC <- function(score_data, plot_name){
    # Given all the Ss aic data (from processscore_dataodelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    # Order p_levels
    relev <- c("insignificant", "weak_trend", "trend", "significant")
    score_data$p_levels <- factor(score_data$p_levels, levels=relev)

    # And plot!
    for(roi in levels(score_data$roi_names)){
        pdf(height=11, width=7.5)  ## real big for all the data!
        print(roi)
        roi_data <- score_data[score_data$roi_names == roi, ]
        p <- ggplot(data=roi_data, aes(x=dm, 
                                       y=aic, 
                                       colour=score_class, fill=score_class, alpha=p_levels)) 
        p <- p + facet_wrap(~sub) 
        p <- p + geom_bar(position="dodge")
        p <- p + geom_hline(aes(yintercept=0), color="black")
        p <- p + geom_hline(aes(yintercept=-2), color="red", alpha=0.8)
        p <- p + geom_hline(aes(yintercept=-4), color="orange", alpha=0.8)
        p <- p + coord_flip()
        p <- p + ylim(-20, 5)
        p <- p + theme_bw()
        p <- p + opts(title=paste(paste("s_bars_", 
                                        plot_name, 
                                        "_aic_", 
                                        roi,sep="")))
        plot(p)
        ggsave(paste("s_bars_", plot_name, "_aic_", roi, ".pdf", sep=""))
    }
    # Get rid of all the open windows...
    graphics.off()
}


s.plot.llf <- function(score_data, plot_name){
    # Given all the Ss llf data (from processscore_dataodelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    # Order p_levels
    relev <- c("insignificant", "weak_trend", "trend", "significant")
    score_data$p_levels <- factor(score_data$p_levels, levels=relev)
    print(levels(score_data$roi_names))

    # And plot!
    for(roi in levels(score_data$roi_names)){
        pdf(height=5, width=7.5)  ## real big for all the data!
        print(roi)
        roi_data <- score_data[score_data$roi_names == roi, ]
        p <- ggplot(data=roi_data, aes(x=dm, 
                                       y=llf, 
                                       colour=score_class,
                                       alpha=p_levels)) 
        #p <- p + facet_grid(score_class~.) 
        p <- p + geom_point()
        p <- p + stat_summary(fun.y = "mean", geom="bar", alpha=0.1)        
        p <- p + geom_hline(aes(yintercept=0), color="black")
        p <- p + coord_flip()
        p <- p + opts(title=paste(paste("s_plot_", 
                                        plot_name, 
                                        "_llf_", 
                                        roi,sep="")))
        p <- p + scale_colour_brewer(palette="Dark2")
        p <- p + theme_bw()
        plot(p)
        ggsave(paste("s_plot_", plot_name, "_llf_", roi, ".pdf", sep=""))
    }
    # Get rid of all the open windows...
    graphics.off()
}


s.plot.r_adj <- function(score_data, plot_name){
    # Given all the Ss r_adj data (from processscore_dataodelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    # Order p_levels
    relev <- c("insignificant", "weak_trend", "trend", "significant")
    score_data$p_levels <- factor(score_data$p_levels, levels=relev)

    # And plot!
    for(roi in levels(score_data$roi_names)){
        pdf(height=5, width=7.5)  ## real big for all the data!
        print(roi)
        roi_data <- score_data[score_data$roi_names == roi, ]
        p <- ggplot(data=roi_data, aes(x=dm, 
                                       y=r_adj, 
                                       colour=score_class,
                                       alpha=p_levels))  
        p <- p + geom_point()
        p <- p + stat_summary(fun.y = "mean", geom="bar", alpha=0.1)        
        p <- p + geom_hline(aes(yintercept=0), color="black")
        p <- p + coord_flip()
        p <- p + opts(title=paste(paste("s_plot_", 
                                        plot_name, 
                                        "_r_adj_", 
                                        roi,sep="")))
        p <- p + scale_colour_brewer(palette="Dark2")
        p <- p + theme_bw()
        plot(p)
        ggsave(paste("s_plot_", plot_name, "_r_adj_", roi, ".pdf", sep=""))
    }
    # Get rid of all the open windows...
    graphics.off()
}

