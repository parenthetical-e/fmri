plot_a <- function(dmany=dall,kind="acc"){
# Across the stimindex, plot average for all subjects and 
# stimuli in dmany.

	if(kind == "acc"){
		quartz(width=4, height=2)
		plt <- ggplot(dmany, aes(x=stimindex, y=acc))
		plt <- plt + stat_summary(fun.y = "mean",geom="line")
		plt <- plt + theme_bw()
		print(plt)
		quartz.save(paste("all_",kind,".pdf",sep=""), type = "pdf")
	}
	else if(kind == "rt"){
		quartz(width=4, height=2)
		plt <- ggplot(dmany, aes(x=stimindex, y=rt))
		plt <- plt + stat_summary(fun.y = "mean",geom="line")
		plt <- plt + theme_bw()
		print(plt)
		quartz.save(paste("all_",kind,".pdf",sep=""), type = "pdf")
	}
	else{ stop("<kind> wasn't understood.") }
}
