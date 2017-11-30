data(Contraception,package="mlmRev")

### use rjags
Contraception$useBin <- car::recode(Contraception$use,"'Y'=1;'N'=0",F)
Contraception$ch1 <- car::recode(Contraception$livch,"'1'=1;else=0",F)
Contraception$ch2 <- car::recode(Contraception$livch,"'2'=1;else=0",F)
Contraception$ch3 <- car::recode(Contraception$livch,"'3+'=1;else=0",F)
Contraception$urbanBin <- car::recode(Contraception$urban,"'Y'=1;'N'=0",F)
Contraception$district2 <- as.numeric(as.character(Contraception$district))

d <- c(N=1934,M=61,as.list(Contraception[,c(5,7:12)]))
inits <- list(alpha0=1,alpha.urban=0,alpha.age=0,alpha.ch1=0,alpha.chi2=0,alpha.ch3=0,tau=1)

library(rjags)
load.module("glm")

m1 <- jags.model("contraception.bug", d,inits,n.chain=2,n.adapt=2500)
## m1$recompile()
update(m1,3000)
mc1 <- coda.samples(m1,c("alpha.age","alpha.urban","alpha.ch1","alpha.ch2","alpha.ch3","sigma"),10000,thin=20)
plot(mc1)
geweke.diag(mc1)
summary(mc1)

save.image("contraception.Rdata")
