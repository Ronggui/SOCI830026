library(mediation)
require(sandwich)


###
# Dependent variable: work1
# explanatory variale: treat
# mediator: job_disc, treated as continous variable for demonstration only
# control variables: econ_hard,  sex, age
###

# ols model for continous mediator
m.ols <- lm(job_disc ~ treat + econ_hard + sex + age, data=jobs)

# logistic regression for dependent variable
d.bin <- glm(work1 ~ treat + job_disc + econ_hard + sex + age, data=jobs,
             family=binomial(link="logit"))

summary(m.ols)
summary(d.bin)

# mediation analysis
contbin <- mediate(m.ols, d.bin, sims=1000, treat="treat", mediator="job_disc")

summary(contbin)

###
# The average causal mediation effect (ACME) represents the expected difference in the potential outcome 
# when the mediator took the value that would realize under the treatment condition as opposed to the 
# control condition, while the treatment status itself is held constant.
#
# The average direct effect (ADE) represents the expected difference in the potential outcome when the 
# treatment is changed but the mediator is held constant at the value that would realize if the treatment equals t.
###


# Using heteroskedasticity-consistent standard errors
contbin.rb <- mediate(m.ols, d.bin, sims=1000, treat="treat", mediator="job_disc",
                     robustSE=TRUE)
summary(contbin.rb)

####
# for more information, see the help page
# ?mediate
####