# Make sure that working directory is set properly
setwd("~/Dropbox/projects/meaningful-inferences")

# clear workspace
rm(list = ls())

# load packages
library(compactr)

# create figure
pdf("doc/figs/example-cis.pdf", height = 4, width = 5)
par(mfrow = c(1,1), mar = c(3,1,1,1), oma = c(0,0,0,0))
eplot(xlim = c(-0.3, 1), ylim = c(.5, 5.5),
      xlab = "Effect", anny = FALSE)
abline(v = 0, col = "grey50")
abline(v = 0.25, lty = 2, col = "grey50")


# CI 1
ht <- 1
est <- .05
lwr <- -.01
points(est, ht, pch = 19)
lines(c(lwr, est + est - lwr ), c(ht,ht))
text(est, ht, "Study E\nSmall, Precise, Not Significant", pos = 3, cex = .8)

# CI 2 
ht <- 2
est <- .05
lwr <- .01
points(est, ht, pch = 19)
lines(c(lwr, est + est - lwr ), c(ht,ht))
text(est, ht, "Study D\nSmall, Precise, Significant", pos = 3, cex = .8)

# CI 3
ht <- 3
est <- .4
lwr <- -.01
points(est, ht, pch = 19)
lines(c(lwr, est + est - lwr ), c(ht,ht))
text(est, ht, "Study C\nLarge, Imprecise, Not Significant", pos = 3, cex = .8)

# CI 4
ht <- 4
est <- .4
lwr <- .01
points(est, ht, pch = 19)
lines(c(lwr, est + est - lwr ), c(ht,ht))
text(est, ht, "Study B\nLarge, Imprecise, Significant", pos = 3, cex = .8)

# CI 5
ht <- 5
est <- .4
lwr <- .35
points(est, ht, pch = 19)
lines(c(lwr, est + est - lwr ), c(ht,ht))
text(est, ht, "Study A\nLarge, Precise, Significant", pos = 3, cex = .8)

# close graphics device
dev.off()