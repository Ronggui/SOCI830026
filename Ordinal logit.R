library(foreign)
warm <-read.dta("ordwarm2.dta")
head(warm)
## use MASS::polr
library(MASS)
m <- polr(warm~yr89+male+white+age+ed+prst,data=warm)
summary(m)

## use VGAM::vglm
library(VGAM)
m2 <- vglm(ordered(warm)~yr89+male+white+age+ed+prst,propodds,data=warm)
summary(m2)

## use rms::lrm
library(rms)
## check po assumption
par(mfrow=c(3,2))
plot.xmean.ordinaly(warm~yr89+male+white+age+ed+prst,data=warm)

(m3 <- lrm(warm~yr89+male+white+age+ed+prst,data=warm,x=TRUE,y=TRUE))

## check po assumption and transformation of IVs (via partial residuals)
par(mfrow=c(2,6))
residuals(m3,type="partial",pl=T)
residuals(m3,type="score.binary",pl=T)
