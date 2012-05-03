ii_plot <- function(dat='ii_stim.dat'){
    library(ggplot2)

    ii <- read.table(dat)
    colnames(ii) <- c("Category","Width","Angle","Unk")
    ii[["Category"]] <- factor(ii[["Category"]])

    quartz(width=5, height=4)
    plt <- ggplot(ii, aes(x=Width, y=Angle, colour=Category))
    plt <- plt + geom_point() + theme_bw() + ylim(0,100) + xlim(0,100)
    print(plt)
}
