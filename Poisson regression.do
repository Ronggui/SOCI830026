poisson art fem ment
** goodness of fit
fitstat
estat gof
estat gof, pearson
** mean predicted prob
prcounts psn, plot
graph twoway connected psnobeq psnpreq psnval, ytitle("Pr") ylabel(0(0.1)0.4) xlabel(0(1)9)
** interpretation
listcoef
glm art fem ment, family(poisson)
** overdisperson
** sum of squared deviance residuals
predict rdev, deviance
gen rdev2= rdev^2
sum rdev2
display `r(N)'*`r(mean)'
** sum of squared pearson residuals (preferred)
predict rper, pearson
gen rper2= rper^2
sum rper2
