read_s <- function(f1='',f2=''){
# Read in and lightly process the behvoiral data.
	
	d1 <- read.table(f1,sep="\t",header=FALSE)
	d2 <- read.table(f2,sep="\t",header=FALSE)
	d <- rbind(d1,d2)

	names(d) <- c("blockindex","stim","cresp","acc","rt",
					"resp","category","width","angle","ignore",
					"value","ignore2")

	# Create a stimulus index
	# the create a factor breaking 
	# the data into 2 blocks and 4 block
	stimindex <- rep(0,nrow(d))
	for(s in unique(d[["stim"]])) {
		mask <- d[["stim"]] == s
		stimindex[mask] <- 1:sum(mask)
	}
	d[["stimindex"]] <- stimindex
	d
}
