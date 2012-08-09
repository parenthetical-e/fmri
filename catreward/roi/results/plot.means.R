m.plot.aic_w <- function(aic_w_stats, plot_name) {
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    for(roi in levels(aic_w_stats$roi_names)){
        pdf(height=3.5, width=6)  ## real big for all the data!
        print(roi)
        limits <- aes(ymin=M - SE, ymax=M + SE)
        roi_data <- aic_w_stats[aic_w_stats$roi_names == roi, ]
        p <- ggplot(data=roi_data, aes(
                                       x=dm,
                                       y=M, 
                                       fill=model_family))
        p <- p + geom_bar() + geom_errorbar(limits, size=0.25, width=0.25)
        p <- p + coord_flip()
        p <- p + scale_fill_brewer(palette="Dark2")
        p <- p + ylab("Akaike Weight") + xlab("Model")
        p <- p + theme_bw()
        plot(p)
        ggsave(paste("f_meanbar_", plot_name, "_aic_w_", roi, ".pdf", sep=""))
    }
}


m.plot.aic_w.bilat <- function(aic_w_stats, plot_name) {
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    for(roi in levels(aic_w_stats$bilat_class)){
        pdf(height=6, width=6)  ## real big for all the data!
        print(roi)
        limits <- aes(ymin=M - SE, ymax=M + SE)
        roi_data <- aic_w_stats[aic_w_stats$bilat_class == roi, ]
        p <- ggplot(data=roi_data, aes(
                                       x=dm,
                                       y=M, 
                                       fill=model_family))
        p <- p + geom_bar() + geom_errorbar(limits, size=0.25, width=0.25)
        p <- p + facet_grid(roi_names ~ .)
        p <- p + coord_flip()
        p <- p + scale_fill_brewer(palette="Dark2")
        p <- p + ylab("Akaike Weight") + xlab("Model")
        p <- p + theme_bw()
        plot(p)
        ggsave(paste("f_meanbar_", plot_name, "_aic_w_bilat_", roi, ".pdf", sep=""))
    }
}


m.plot.fvalue <- function(f_results, plot_name){
    # Given all the Ss bic data (from processModelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    f_results$p_levels <- factor(f_results$p_levels, levels=c(
                                            "insignificant",
                                            "trend","significant"))
    # And plot!
    for(roi in levels(f_results$roi_names)){
        pdf(height=3.5, width=6)  ## real big for all the data!
        print(roi)
        roi_data <- f_results[f_results$roi_names == roi, ]
        p <- ggplot(data=roi_data, aes(
                                       x=dm,
                                       y=fvalue, 
                                       fill=model_family,
                                       alpha=p_levels))
        p <- p + geom_bar(colour="black")
        p <- p + coord_flip()
        p <- p + scale_fill_brewer(palette="Dark2")
        p <- p + scale_alpha_discrete(drop=FALSE)
        p <- p + ylab("F-value") + xlab("Model")
        p <- p + theme_bw()

        plot(p)
        ggsave(paste("f_plot_", plot_name, "_fvalue_", roi, ".pdf", sep=""))
    }
}

m.plot.fvalue.bilat <- function(f_results, plot_name){
    # Given all the Ss bic data (from processModelScore.R)
    # make a nice plot for each ROI.
    require(ggplot2)
    source("~/Code/fmri/catreward/roi/results/filterdf.R")

    f_results$p_levels <- factor(f_results$p_levels, levels=c(
                                            "insignificant",
                                            "trend","significant"))
    # And plot!
    for(roi in levels(f_results$bilat_class)){
        pdf(height=6, width=6)  ## real big for all the data!
        print(roi)
        roi_data <- f_results[f_results$bilat_class == roi, ]
        p <- ggplot(data=roi_data, aes(
                                       x=dm,
                                       y=fvalue, 
                                       fill=model_family,
                                       alpha=p_levels))
        p <- p + geom_bar(colour="black") + facet_grid(roi_names ~ .)
        p <- p + coord_flip()
        p <- p + scale_fill_brewer(palette="Dark2")
        p <- p + scale_alpha_discrete(drop=FALSE)
        p <- p + ylab("F-value") + xlab("Model")
        p <- p + theme_bw()

        plot(p)
        ggsave(paste("f_plot_", plot_name, "_fvalue_bilat_", roi, ".pdf", sep=""))
    }
}
