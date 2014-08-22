# set working directory
setwd("~/Dropbox/projects/meaningful-inferences/")

# load packages
library(MASS)
library(sandwich)
library(compactr)

# read data
d <- read.csv("hks-replication/Data/HKS_AJPS_2013.tab", sep = "\t")
keep <- c("osvAll", "troopLag", "policeLag", "militaryobserversLag",
            "brv_AllLag", "osvAllLagDum", "incomp", "epduration", "lntpop",
          "conflict_id")
d <- na.omit(d[, keep])
#d <- d[d$osvAll < 50000, ]
#d$incomp <- d$incomp - 1



# estimate model
m <- glm.nb(osvAll ~ troopLag + policeLag + militaryobserversLag + 
         brv_AllLag + osvAllLagDum + incomp + epduration + 
         lntpop, 
       data = d, init.theta = 5, control = glm.control(epsilon = 1e-12, maxit = 2500, trace = FALSE))

b <- coef(m)
V <- vcovHC(m)
# simulate the coefficients
sims <- mvrnorm(1000, b, V)

trps <- seq(0, 8, by = .1)
X <- cbind(1, 
           trps, #mean(d$troopLag, na.rm = TRUE),
           mean(d$policeLag, na.rm = TRUE),
           mean(d$militaryobserversLag, na.rm = TRUE),
           mean(d$brv_AllLag, na.rm = TRUE),
           1, #mean(d$osvAllLagDum, na.rm = TRUE), 
           2, #mean(d$incomp, na.rm = TRUE),
           mean(d$epduration, na.rm = TRUE),
           mean(d$lntpop, na.rm = TRUE))

ev.sims <- exp(X%*%t(sims))
q <- apply(ev.sims, 1, quantile, c(.05, .5, .95))

pdf("doc/figs/hks-ev.pdf", height = 3.5, width = 5)
par(mfrow = c(1,1), oma = c(0,0,0,0), mar = c(3,3.5,1,1))
eplot(xlim = c(0, 8),
      ylim = mm(q),
      xlab = "Number of UN Troops",
      ylab = "Average Number of Civilian Casualties",
      ylabpos = 2.2,
      xat = 0:4*2,
      xticklab = c("0", "2,000", "4,000", "6,000", "8,000"))
lines(trps, q[2, ], lwd = 3)
lines(trps, q[1, ], lty = 3)
lines(trps, q[3, ], lty = 3)
dev.off()

pdf("doc/figs/hks-ci.pdf", height = 3.5, width = 5)
par(mfrow = c(1,1), oma = c(0,0,0,0), mar = c(3,1,1,1))
eplot(xlim = c(0, 150),
      ylim = c(.8, 4.7),
      xlab = "Average Number of Civilian Casualties Prevented",
      anny = FALSE)
levels <- c(2,4,6,8)
names <- c("2,000 Troops\n(approx. $2 million)", "4,000 Troops\n(approx. $4 million)", 
           "6,000 Troops\n(approx. $6 million)", "8,000 Troops\n(approx. $8 million)")
for (i in 1:length(levels)) {
  q <- quantile(ev.sims[trps == 0, ] - ev.sims[trps == levels[i], ], c(.05, .5, .95))
  points(q[2], i, pch = 19)
  lines(q[c(1,3)], c(i, i))
  text(q[2], i, names[i], pos = 3, cex = .7)
}
dev.off()