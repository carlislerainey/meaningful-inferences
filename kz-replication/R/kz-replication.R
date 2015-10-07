# set working directory
setwd("~/Dropbox/projects/meaningful-inferences")

# load packages
library(compactr)

# read data
kz <- read.csv("kz-replication/data/kz.csv")

n.treat <- sum(kz$treated)
n.control <- length(kz$treated) - sum(kz$treated)
n.support.treat <- sum(kz$anygriffin[kz$treated == 1])
n.support.control <- sum(kz$anygriffin[kz$treated == 0])
n.support.jenkins.treat <- sum(kz$anyjenkins[kz$treated == 1])
n.all.else <- length(kz) + n.control
n.support.all.else <- n.support.control + sum(kz$anygriffin)


# treat v. control
m1 <- prop.test(x = c(n.support.treat, n.support.control), 
          n = c(n.treat, n.control), 
          conf.level = .9,
          correct = FALSE); m1
ci1 <- m1$conf.int
est1 <- m1$estimate[1] - m1$estimate[2]

# treat v. placebo
m2 <- prop.test(x = c(n.support.treat, n.support.jenkins.treat), 
                n = c(n.treat, n.treat), 
                conf.level = .9,
                correct = FALSE); m2
ci2 <- m2$conf.int
est2 <- m2$estimate[1] - m2$estimate[2]


# plot cis
pdf("doc/figs/kz-ci.pdf", height = 3, width = 5)
par(mfrow = c(1, 1), mar = c(5, 1, 1, 1), oma = c(0, 0, 0, 0))
eplot(xlim = c(-.1, .3), ylim = c(0, 1),
      xlab = "Estimated Treatment Effect\nand 90% Confidence Interval",
      xlabpos = 2.5,
      anny = FALSE)
abline(v = 0, lty = 3, lwd = 3, col = "grey50")
lines(ci1, c(.25, .25), lwd = 2)
points(est1, .25, pch = 19)
text(est1, .25, "Treatment Group v. Control Group", pos = 3, cex = .8)
lines(ci2, c(.75, .75), lwd = 2)
points(est2, .75, pch = 19)
text(est2, .75, "Treated Name v. Placebo Name", pos = 3, cex = .8)
dev.off()
