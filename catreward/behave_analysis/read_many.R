read_many <- function(num=101:110){
# Read each of the data files specifcied by the code
# there are two files for every code, A and B, which
# match A and B in the 'run' scanner task.

	source("~/Code/categorical_r/behave/read_s.R")
	
	alld <- NULL
	for(n in num){
		n1 <- paste("data_",n,"_run_trials_A.dat.log",sep="")
		n2 <- paste("data_",n,"_run_trials_B.dat.log",sep="")
		d <- read_s(n1,n2)		
		
		d[["sub"]] <- rep(paste(n),nrow(d))
			## Add a subject code
		
		alld <- rbind(alld,d)
	}
	alld[["sub"]] <- factor(alld[["sub"]])
	alld
}
