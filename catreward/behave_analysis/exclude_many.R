exclude_many <- function(dmany=dall,subs=c("107","110")){
# Exclude the subjects (<subs>) whose codes match those found 
# in dmany[["sub"]]

	mask <- rep(FALSE,nrow(dmany))
	for(s in subs){ mask <- mask | dmany[["sub"]] == s }
	mask <- !mask

	dmany[mask,]
}
