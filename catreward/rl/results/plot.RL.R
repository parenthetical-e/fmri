plot.RL.logL <- function(rlpar){
    # Plot the log-liklihood scores for each model and coding scheme 
    # in rl data
    require("ggplot2")
    source("~/Code/fmri/catreward/rl/results/filterdf.R")

    # Drop rdis
    rlpar <- filterdf(rlpar, "sim", c('none', 'exp', 'gauss'))
    rlpar$sim <- factor(rlpar$sim, 
                           levels=c('none', 'exp', 'gauss'))

    print(str(rlpar))
    pdf(height=2, width=3)  ## real big for all the data!
    p <- ggplot(rlpar, aes(x=sim, y=logL))
    p <- p + stat_summary(fun.data = "mean_se")
    p <- p + facet_grid(. ~ reward)
    p <- p + xlab("Similarity")
    p <- p + ylab("Log-Likelihood")
    p <- p + theme_bw()
    
    plot(p)
    ggsave(paste("f_logL.pdf", sep=""))  
    graphics.off()    
}


plot.RL.alpha <- function(rlpar){
    # Plot alphas for each model and coding scheme 
    # in rl data
    require("ggplot2")
    source("~/Code/fmri/catreward/rl/results/filterdf.R")

    # Drop rdis
    rlpar <- filterdf(rlpar, "sim", c('none', 'exp', 'gauss'))
    rlpar$sim <- factor(rlpar$sim, 
                           levels=c('none', 'exp', 'gauss'))

    print(str(rlpar))
    pdf(height=2, width=3)  ## real big for all the data!
    p <- ggplot(rlpar, aes(x=sim, y=alpha))
    p <- p + stat_summary(fun.data = "mean_se")
    p <- p + facet_grid(. ~ reward)
    p <- p + xlab("Similarity")
    p <- p + ylab("Alpha")
    p <- p + ylim(0,1)
    p <- p + theme_bw()
    
    plot(p)
    ggsave(paste("f_alpha.pdf", sep=""))  
    graphics.off()    
}


plot.RL.beta <- function(rlpar){
    # Plot the betas for each model and coding scheme 
    # in rl data
    require("ggplot2")
    source("~/Code/fmri/catreward/rl/results/filterdf.R")

    # Drop rdis
    rlpar <- filterdf(rlpar, "sim", c('none', 'exp', 'gauss'))
    rlpar$sim <- factor(rlpar$sim, 
                           levels=c('none', 'exp', 'gauss'))

    print(str(rlpar))
    pdf(height=2, width=3)  ## real big for all the data!
    p <- ggplot(rlpar, aes(x=sim, y=beta))
    p <- p + facet_grid(. ~ reward)
    p <- p + stat_summary(fun.data = "mean_se")
    p <- p + xlab("Similarity")
    p <- p + ylab("Beta")
    p <- p + ylim(0,5)
    p <- p + theme_bw()
    
    plot(p)
    ggsave(paste("f_beta.pdf", sep=""))
    graphics.off()    
}


trialindex <- function(rldata){
    # Add a by subject and model trialindex to rldata
    
    rldata[["trialindex"]] <- rep(0,nrow(rldata))
        ## init

    subs <- unique(rldata$sub)
    mods <- unique(rldata$sim)
    
    for(sub in subs){
        for(mod in mods){
            mask <- (rldata$sub == sub) & (rldata$sim == mod)
            rldata[["trialindex"]][mask] <- 1:sum(mask)
        }
    }
    rldata
}


plot.RL.RPE <- function(rldata, code){
    require("ggplot2")
    source("~/Code/fmri/catreward/rl/results/filterdf.R") 
    
    # Keep only code
    rldata <- filterdf(rldata, "reward", c(code))
    
    # Drop rdis
    rldata <- filterdf(rldata, "sim", c('none', 'exp', 'gauss'))
    rldata$sim <- factor(rldata$sim, 
                           levels=c('none', 'exp', 'gauss'))

    # Add a sub index to rldata
    rldata <- trialindex(rldata)

    pdf(width=6,height=12)
    p <- ggplot(rldata, aes(x=trialindex, y=rpe))
    p <- p + geom_line()
    p <- p + facet_grid(sub ~ sim)
    p <- p + xlab("Trials")
    p <- p + ylab("Reward Prediction Error")
    p <- p + ylim(-1,1)
    p <- p + theme_bw()
    plot(p)

    ggsave(paste("f_rpe_", code, ".pdf", sep=""))    
    graphics.off()
}


plot.RL.value <- function(rldata, code){
    require("ggplot2")
    source("~/Code/fmri/catreward/rl/results/filterdf.R")
    
    # Keep only code
    rldata <- filterdf(rldata, "reward", c(code))
    
    # Drop rdis
    rldata <- filterdf(rldata, "sim", c('none', 'exp', 'gauss'))
    rldata$sim <- factor(rldata$sim, 
                           levels=c('none', 'exp', 'gauss'))

    # Add a sub index to rldata
    rldata <- trialindex(rldata)

    pdf(width=6,height=12)
    p <- ggplot(rldata, aes(x=trialindex, y=value))
    p <- p + geom_line()
    p <- p + facet_grid(sub ~ sim)
    p <- p + xlab("Trials")
    p <- p + ylab("Value")
    p <- p + ylim(-1,1)
    p <- p + theme_bw()
    plot(p)

    ggsave(paste("f_value_", code, ".pdf", sep=""))    
    graphics.off()
}

plot.RL.RPE.density <- function(rldata){
    # Plot a histogram using all Ss data for the three sim
    # models
    
    # Drop rdis
    rldata <- filterdf(rldata, "sim", c('none', 'exp', 'gauss'))
    rldata$sim <- factor(rldata$sim, 
                           levels=c('none', 'exp', 'gauss'))

    pdf(width=6,height=3)
    p <- ggplot(rldata, aes(x=rpe, fill=sim,colour=sim))
    p <- p + geom_density(alpha=0.2)
    p <- p + facet_grid(~reward)
    p <- p + scale_fill_brewer(palette="Dark2")
    p <- p + scale_colour_brewer(palette="Dark2")
    p <- p + ylab("Density (truncated)")
    p <- p + xlab("Reward Prediction Error")
    p <- p + coord_cartesian(ylim=c(0, 6))
    p <- p + theme_bw()
    plot(p)

    ggsave(paste("f_density_rpe.pdf", sep=""))    
    graphics.off()
}


plot.RL.value.density <- function(rldata){
    # Plot a histogram using all Ss data for the three sim
    # models
    
    # Drop rdis
    rldata <- filterdf(rldata, "sim", c('none', 'exp', 'gauss'))
    rldata$sim <- factor(rldata$sim, 
                           levels=c('none', 'exp', 'gauss'))

    pdf(width=6,height=3)
    p <- ggplot(rldata, aes(x=value, fill=sim,colour=sim))
    p <- p + geom_density(alpha=0.2)
    p <- p + facet_grid(~reward)
    p <- p + scale_fill_brewer(palette="Dark2")
    p <- p + scale_colour_brewer(palette="Dark2")
    p <- p + ylab("Density (truncated)")
    p <- p + xlab("Value")
    p <- p + coord_cartesian(ylim=c(0, 6))
    p <- p + theme_bw()
    plot(p)

    ggsave(paste("f_density_value.pdf", sep=""))    
    graphics.off()
}
