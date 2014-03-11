tab s5 tole_gov
tab s5 tole_gov, row
# two types of chisquared tests
tab s5 tole_gov, chi
tab s5 tole_gov, lrchi

tab  grp_act
tab  grp_act, nolabel
recode grp_act (-3=.) (1=0) (2=1), gen(grp_act_new)
recode s5 (1=0) (2=1), gen(s5new)
tab s5new grp_act_new, chi row
# interval of odds ratio
# cc only takes 0/1 variables as input
cc s5new grp_act_new
logit s5new grp_act_new, or
