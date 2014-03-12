tab  lfp
tab  lfp, nolabel
recode lfp (1=0) (2=1), gen(y)
* logit model in table 3.3
logit y k5 k618 age i.wc i.hc lwg inc
* return odds ratio rather than coef
logistic y k5 k618 age i.wc i.hc lwg inc
* ereturn list
matrix list e(V)
* list variaous forms of coef for interpretation
* need to install spost first
* refer to www.indiana.edu/~jslsoc/spost.htm for more
listcoef
* plot probability vs IVs
prgen age, from(30) to(60) rest(mean) generate(age)
twoway (connect agep1 agex )

* if you don't want to use i., you need to recode wc and hc first
recode hc (1=0) (2=1),gen(hcnew)
recode wc (1=0) (2=1),gen(wcnew)
logit y k5 k618 age wcnew hcnew lwg inc

* test coef wcnew = coef hcnew =0?
* loglikelihood ratio test
logit y k5 k618 age wcnew hcnew lwg inc
est store unrestr
logit y k5 k618 age  lwg inc
** if the number of obs is not the same due to missing values,
** use the following two lines insteadn
gen sample=1 if e(sample)
logit y k5 k618 age  lwg inc if sample==1
est store restr

lrtest restr unrestr
* wald test
test wcnew=hcnew=0

* violation of principle of marginality
recode wc (1=0) (2=1), gen(wc1)
gen k5wc=k5*wc
gen k5wc1=k5*wc1
logit y k5 wc k5wc
logit y k5 wc1 k5wc1
logit y wc k5wc
logit y wc1 k5wc1

* Index of goodness of fit
fitstat

* Pearson statistics goodness of fit
* This statistic is based on covariate patterns rather than number of cases
* The pearson residuals are adjusted by number of cases in each covariate patterns
estat gof

** get the number of cases for each covariate patterns
predict num, number
by num, sort: gen m1=cond(_n==_N, _N,.)
by num, sort: gen m2=_N

** predicted probabilities
predict pr

** various residuals, which are adjusted by number of cases in each covariate patterns
predict pearson, residual
predict d, deviance
predict spearson, rstand
** demonstrate the calculation of standardized residuals
gen spearson2= pearson/sqrt(1-h)
gen pearson2=(y-m2*pr)/sqrt(m2*pr*(1-pr))

** useful statistics for diagnostic analysis
** influence statistics
predict h, hat
predict db, db
predict dx2,dx2
predict dd, dd

gen db2= spearson^2*h/(1-h)
gen dx22=spearson^2
gen dd2=d^2/(1-h)

** demonstrate the formular of GOF which is based on group-wise pearson residuals
estat gof
gen rsq=pearson^2
sum rsq if m1!=.
display r(mean)*r(N)

** diagnostic plots
twoway (scatter dx2 pr)
twoway (scatter dd pr)
twoway (scatter db pr)
twoway (scatter dx2 pr [weight=db], msymbol(oh))

* install package for partial residuals
** diagnostic analysis from case-wise perspective (e.g. fit logistic model by glm)
ssc install logitcprplot, replace
* standardised pearson residuals
predict rst, rstandard
gen index=_n
scatter rst index
* Component-plus-residual plot for logistic regression
logitcprplot lwg,lowess
** this plot suggest a nonlinear relationship, lwg^2 should be added?
