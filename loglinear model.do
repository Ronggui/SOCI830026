* exploratory data analysis for count variable
hist ofp
gen ofp2 = log(ofp+0.5)
graph box ofp2,over(numchron)
sum  numchron, detail

* log linear model
glm  count i.wifecls i.huscls, family(poisson) link(log)
est store m1
** no associations model
predict noassPred
list noassPred in 1

gen d11=0
replace d11=1 if wifecls==1 & huscls==1
gen d22=0
replace d22=1 if wifecls==2 & huscls==2
gen d33=0
replace d33=1 if wifecls==3 & huscls==3
gen d44=0
replace d44=1 if wifecls==4 & huscls==4
gen d55=0
replace d11=1 if wifecls==5 & huscls==5
gen d55=0
replace d66=1 if wifecls==6 & huscls==6
gen d77=0
replace d77=1 if wifecls==7 & huscls==7
gen steps= abs(wifecls-huscls)
gen longmoves=0
replace longmoves=1 if steps>3

glm  count i.wifecls i.huscls d11 d22  d33 d44 d55 d66 d77, family(poisson) link(log)
est store m2
glm  count i.wifecls i.huscls d11 d22  d33 d44 d55 d66 d77 steps, family(poisson) link(log)
est store m3
glm  count i.wifecls i.huscls d11 d22  d33 d44 d55 d66 d77 steps longmoves, family(poisson) link(log)
est store m4

lrtest m1 m2
lrtest m2 m3
lrtest m3 m4
* model 4 is the best fit model

* you can also use poisson
poisson count i.wifecls i.huscls d11 d22  d33 d44 d55 d66 d77 steps longmoves
estat gof

* homogeous association model in agresti (2002:325)
gen am=a*m
gen ac=a*c
gen cm=c*m
* note the all a c m are binary variable of 1/0

poisson count a c m am ac cm
est store hom

poisson count a c m ac cm
lrtest hom

poisson count a c m am cm
lrtest hom

poisson count a c m am ac
lrtest hom

