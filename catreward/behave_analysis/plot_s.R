plot_s <- function(dat=d,kind="acc",name="1"){
# Use stimindex to plot the <name>d column
# (1) as a across stimulus average then
# (2) plot each stimulus results in a faceted plot
	
	library(ggplot2)
	
	if(kind == "acc"){
		quartz(width=4, height=2)
		plt <- ggplot(dat, aes(x=stimindex, y=acc))
	 	plt <- plt + stat_summary(fun.y = "mean",geom="line")
		plt <- plt + theme_bw()
		print(plt)
		quartz.save(paste(name,"_m_",kind,".pdf",sep=""), type = "pdf")
		
		quartz(width=4, height=7)
		plt <- ggplot(dat, aes(x=stimindex, y=acc))
		plt <- plt + facet_grid(stim~.)
		plt <- plt + stat_smooth(method="glm", family="binomial")  
		plt <- plt + theme_bw()
		print(plt)
		quartz.save(paste(name,"_s_",kind,".pdf",sep=""), type = "pdf")
	}
	else if(kind == "rt"){
		quartz(width=4, height=2)
		plt <- ggplot(dat, aes(x=stimindex, y=rt))
	 	plt <- plt + stat_summary(fun.y = "mean",geom="line")
		plt <- plt + theme_bw()
		print(plt)
		quartz.save(paste(name,"_m_",kind,".pdf",sep=""), type = "pdf")
	}
	else{ stop("<kind> wasn't understood.") }

}
