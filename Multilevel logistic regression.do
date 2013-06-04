use Contraception

* recode the DV
tabulate use, nolabel
tabulate use
recode use (1=0) (2=1), gen(useBin)
recode urban (1=0) (2=1), gen(urbanBin)

xtmelogit useBin urbanBin age i.livch || district:
* get median odds ratior of fixed effect and variance of sigma
xtmelogit, variance or

* 80% interval odds ratio of urban
display exp(_b["urbanBin"] + sqrt(2*.2154977)*invnormal(0.9))
display exp(_b["urban"] + sqrt(2*.2154977)*invnormal(0.1))

## Median odds ratio interpretation for random effect
display exp(abs(sqrt(2*0.21267)*invnormal(0.75)))

* use xtlogit
xtlogit useBin urbanBin age i.livch, i(district) fe
est  store fe1
xtlogit useBin urbanBin age i.livch, i(district) re
est  store re1
* hausman test, re1 is efficient
hausman fe1 re1
* can't reject H0, so random effect model is prefered

* can also use clogit to estimate the fixed effect model
clogit useBin urbanBin age i.livch, group(district)

*** random slop models
* independent covariance
xtmelogit useBin urbanBin age i.livch || district: urbanBin
xtmelogit, variance or

* unstructured of covariance, similar to that of lme4
xtmelogit useBin urbanBin age i.livch || district: urbanBin,  covariance(unstructured)
xtmelogit, variance or

