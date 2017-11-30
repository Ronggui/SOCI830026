library(foreign)
couart <- read.dta("W15 couart2.dta")

m1 <- glm(art~fem+ment, data=couart, family=poisson)
summary(m1)

library(MASS)
m2 <- glm.nb(art~fem+ment, data=couart)
summary(m2)

library(pscl)
vignette("countreg", package="pscl")


