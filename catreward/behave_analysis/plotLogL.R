plotLogL <- function(fname){
    require("ggplot2")

    rlpar <- read.table(fname, sep=",", header=TRUE)
    p <- ggplot(rlpar, aes(x=sim, y=logL))
    p <- p + geom_bar()
    p <- p + facet_grid(. ~ reward)
    plot(p)
}
