library(foreign)
occ <- read.dta("nomocc2.dta")
## use nnet package
library(nnet)
m <- multinom(occ~white+ed+exper,data=occ)
summary(m, Wald=T)

## use mlogit package as well
library(mlogit)
occ2 <- mlogit.data(occ,"occ",shape="wide")
## two new variables are created (chid and alt)
m1 <- mlogit(occ~0|white+ed+exper,data=occ2)
summary(m1)
m2 <- mlogit(occ~0|white+ed+exper,data=occ2,reflevel="Prof")
summary(m2)
waldtest(m2,.~.|.-white)
waldtest(m2,.~.|.-ed)
waldtest(m2,.~.|.-exper)
lrtest(m2,.~.|.-white)
lrtest(m2,.~.|.-ed)
lrtest(m2,.~.|.-exper)
## constrained models must be fitted for score test
m2cwhite <- update(m2,.~.|.-white)
m2cexper <- update(m2,.~.|.-exper)
m2ced <- update(m2,.~.|.-ed)
## the first argument must be the constrained model
scoretest(m2cwhite,m2)
scoretest(m2ced,m2)
scoretest(m2cexper,m2)
## IIA test: Hausman-style test
m3 <- update(m2, alt.subset=c("BlueCol","Craft","WhiteCol","Prof"))
## Menial is excluded
hmftest(m2,m3)
m3 <- update(m2, alt.subset=c("BlueCol","Menial","WhiteCol","Prof"))
## Craft is excluded
hmftest(m2,m3) ## negative -> IIA holds
