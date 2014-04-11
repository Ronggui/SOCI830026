tab occ

mlogit  occ white ed exper, nolog
matrix betas=get(_b)
matrix list betas
matrix nbeta=betas[1,1..4] - betas[1,5..8]
matrix list nbeta

mlogit  occ white ed exper, nolog base(2)

predict prM, outcome(Menial)
predict prB, outcome(BlueCol)
predict prC, outcome(Craft)
predict prW, outcome(WhiteCol)
predict prP, outcome(Prof)
** you can obtain all in one command
predict prM prB prC prW prP 

** LRT
* inference of exper 
quiet mlogit occ white ed exper, nolog
est store m1
quiet mlogit occ ed exper if e(sample)
est store m0
lrtest m0 m1
** test all IVs in one command
mlogit occ white ed exper, nolog
mlogtest, lr

** Wald test
* inference of exper
test _b[Menial:exper]=_b[BlueCol:exper]=_b[Craft:exper]=_b[WhiteCol:exper]=0
* or simply
test exper
mlogtest, wald

test _b[Craft:ed]=_b[WhiteCol:ed]=0

** inference of more IVs
mlogtest, lr set(white exper)
mlogtest, wald set(white exper)

** can a category be combined with the reference category?
** Wald test
test _b[Craft:white]=_b[Craft:ed]=_b[Craft:exper]=0
test [Craft]
mlogtest, combine
** lrt
mlogtest, lrcomb
** do it step by step
quiet mlogit occ white ed exper, nolog
est store m1
constraint define 99 [Menial]
** all coefficicents except constant are 0 (same as that in reference category)
quiet mlogit occ white ed exper, nolog constraint(99)
est store m0
lrtest m1 m0

** goodness of fit
fitstat

* odds ratio
mlogit, rr
** work for stata 9 and 10
listcoef
** descrete change
prvalue, x(white=0) rest(mean) save
prvalue, x(white=1) rest(mean) diff
** predicted probabilities of outcome 1 given combinations of Xs
prtable ed white, outcome(1)
** generate prob for visual inspection (work for Stata 10, but not 11)
prgen ed, x(white=1) from(6) to(30) gen(wht) ncases(18)
prgen ed, x(white=0) from(6) to(30) gen(nwht) ncases(18)
twayway connected whtp1 nwhtp1 nwhtx
** change in probabilities (Stata 10 only)
prchange
** further visual inspection
mlogview

** test IIA
mlogtest, hausman
mlogtest, smhsiao
