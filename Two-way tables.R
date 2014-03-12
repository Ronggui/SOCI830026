## use association plot to show pearson residuals

## From Agresti(2007) p.39
M <- as.table(rbind(c(762, 327, 468), c(484, 239, 477)))
dimnames(M) <- list(gender = c("M","F"), party = c("Democrat","Independent", "Republican"))

(Xsq <- chisq.test(M))  # Prints test summary

library(vcd)
fourfold(M[,1:2]) 
fourfold(M[,c(1,3)]) 
## fourfold plot is used to depict odds ratio
## only for 2x2 tables
sieve(M,sievetype="observed", shade=TRUE)
sieve(M,sievetype="expected", shade=TRUE)
assoc(M) ## show pearson residuals
