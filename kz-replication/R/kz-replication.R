# set working directory
setwd("~/Dropbox/projects/meaningful-inferences")

# load packages

# read data
kz <- read.csv("kz-replication/data/kz.csv")

n.treat <- sum(kz$treated)
n.control <- length(kz$treated) - sum(kz$treated)
n.support.treat <- sum(kz$anygriffin[kz$treated == 1])
n.support.control <- sum(kz$anygriffin[kz$treated == 0])

# treat v. control
m1 <- prop.test(x = c(n.support.treat, n.support.control), 
          n = c(n.treat, n.control), 
          conf.level = .9,
          correct = FALSE)
ci1 <- m1$conf.int