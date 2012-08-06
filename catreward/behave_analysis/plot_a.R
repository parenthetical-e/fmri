plot_a_Ss <- function(dmany, kind="acc"){
	if(kind == "acc"){
		pdf(width=4, height=7)
		p <- ggplot(dmany, aes(x=stimindex, y=acc))
		p <- p + stat_summary(fun.y = "mean", geom="line")
        p <- p + stat_smooth(method="glm", family="binomial")
        p <- p + facet_wrap(~sub, nrow=6, ncol=3)
        p <- p + geom_hline(aes(yintercept=0.50), color="red",
                            alpha=0.5)                
		p <- p + theme_bw()
        p <- p + ylim(0,1)
        p <- p + xlab("Stimulus Index")
        p <- p + ylab("Avg. Acc")        
		print(p)
        ggsave(paste("f_all_sS_", kind, ".pdf", sep=""))
	}
	else if(kind == "rt"){
		pdf(width=4, height=7)
		p <- ggplot(dmany, aes(x=stimindex, y=rt))
        p <- p + facet_wrap(~sub, nrow=6, ncol=3)
		p <- p + stat_summary(fun.y = "mean",geom="line")
		p <- p + theme_bw()
        p <- p + xlab("Stimulus Index")
        p <- p + ylab("Avg. RT (s)")
        ggsave(paste("f_all_sS_", kind, ".pdf", sep=""))
		print(p)
	}
	else{ stop("<kind> wasn't understood.") }
}


plot_a_mean <- function(dmany=dall,kind="acc"){
# Across the stimindex, plot average for all subjects and 
# stimuli in dmany.

	if(kind == "acc"){
		pdf(width=2, height=2)
		p <- ggplot(dmany, aes(x=stimindex, y=acc))
		p <- p + stat_summary(fun.y = "mean", geom="line")
        p <- p + stat_smooth(method="glm", family="binomial")
        p <- p + ylim(0,1)
        p <- p + geom_hline(aes(yintercept=0.50), 
                            color="red",alpha=0.5)                
        p <- p + xlab("Stimulus Index")
        p <- p + ylab("Avg. Acc") 
		p <- p + theme_bw()
		print(p)
        ggsave(paste("f_all_mean_", kind, ".pdf", sep=""))
	}
	else if(kind == "rt"){
		pdf(width=2, height=2)
		p <- ggplot(dmany, aes(x=stimindex, y=rt))
		p <- p + stat_summary(fun.y = "mean",geom="line")
        p <- p + xlab("Stimulus Index")
        p <- p + ylab("Avg. RT (s)")
		p <- p + theme_bw()
		print(p)
        ggsave(paste("f_all_mean_", kind, ".pdf", sep=""))
	}
	else{ stop("<kind> wasn't understood.") }
}
