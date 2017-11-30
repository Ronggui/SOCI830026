use promotion.dta

* life table
ltable dur event, noadjust hazard
ltable dur event, noadjust

* data expension (elaborate a bit)
expand dur
by id, sort: generate year=_n
generate y=0
replace y=event if year==dur

* hazard from person-period data
tabulate year y, row

* can also use logistic regression
logit y i.year
predict haz, pr
* use sepby to draw a separator line between  the first and second person
list id year haz y event if id<3, sepby(id)


* include time constant co-variates only
logit y i.year undgrad phdmed phdprest
predict haz, pr
generate ln_one_m_haz = ln(1-haz)
by id (year), sort: generate ln_surv=sum(ln_one_m_haz)
generate surv=exp(ln_surv)
twoway (line surv year if id==1, connect(stairstep)), xtitle(year) ytitle(survival)

* use resticted cubic spline
mkspline sply=year, cubic nknots(3) display
logit y  sply*
predict pr_spline, pr
label variable pr_spline "spline"

logit y  i.year
predict pr_dum, pr
label variable pr_dum "dummy"

gen logyear = log(year)
logit y  logyear
predict pr_logy, pr
label variable pr_logy "log"

lowess y year, gen(lowy)
logit y  lowy
predict pr_low, pr
label variable pr_low "lowess"

twoway (line pr_spline year if id==1, lpattern(solid)) (line pr_dum year if id==1, lpattern(dash)) (line pr_logy year if id==1, lpattern(dot)) (line pr_low year if id==1), xtitle(year) ytitle(hazard)

* conditional logit model
stset dur, failure(event) id(id)
stsplit, at(failures) riskset(RS)
clogit event undgrad phdmed phdprest, group(RS)
** or directly use dur as grouping id
clogit event undgrad phdmed phdprest, group(dur)
