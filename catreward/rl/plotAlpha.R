plotAlpha <- function(fname){
    require("ggplot2")

    rlpar <- read.table(fname, sep=",", header=TRUE)
    rlpar$sim <- factor(rlpar$sim, 
                        levels=c('none', 'rdis', 'exp' , 'gauss'))
    p <- ggplot(rlpar, aes(x=sim, y=alpha))
    p <- p + geom_boxplot()
    p <- p + stat_summary(fun.y = "mean", geom="point", color="red")
    plot(p)
}

