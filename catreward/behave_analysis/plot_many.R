plot_many <- function(dmany=dall,kind="acc"){
# Plot individual subjects data based the results of read_many()

	source("~/Code/categorical_r/behave/plot_s.R")
	
	for(s in unique(dmany[["sub"]])){
		print(s)
		
		d <- dmany[dmany[["sub"]]==s,]
		plot_s(d,kind,s)
	}
}
