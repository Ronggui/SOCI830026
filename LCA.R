cmpLCA <- function(...){
  ## objects of poLCA
  ncls <- sapply(list(...), function(obj) obj$call$nclass)
  ncls_idx <- order(ncls)
  ncls <- ncls[ncls_idx]
  fitstats <- sapply(list(...), function(obj) c(obj$aic, obj$bic,-2*obj$llik))
  fitstats <- fitstats[, ncls_idx]
  plot(ncls,fitstats[1,], type="b", ylim=range(fitstats), ylab="goodness of fit", xlab="numer of classes", xaxt="n")
  axis(1, ncls)
  lines(ncls, fitstats[2,], type="b",col="red")
  lines(ncls, fitstats[3,], type="b", col="blue") 
  legend("bottomleft", legend=c("AIC", "BIC", "LLik"), col=c("black", "red", "blue"), lty=1)
}

condTable <- function(obj, digits = 3) {
  ## obj: fitted object from poLCA
  ## generate table of conditional probabilities for easy reading
  tt <- lapply(obj$probs, function(condProbs) t(condProbs))
  condT <- do.call(rbind, tt)
  nCategories <- sapply(tt, function(tti) nrow(tti))
  rownames(condT) <- paste(rep(names(tt), times=nCategories), rownames(condT), sep=" ")
  colnames(condT) <- gsub(":", "", colnames(condT))
  round(condT, digits)
  }
  
library(poLCA)
## all manifest variables are recoded from 1, 2, ... (Not start from 0)

sentM1 <- poLCA(cbind(fengqing, lianghui, zhaoyuan, kunming,  wenzhang)~1,data=dat, nclass=1, nrep=10, maxiter=10000)
sentM2 <- poLCA(cbind(fengqing, lianghui, zhaoyuan, kunming,  wenzhang)~1,data=dat, nclass=2, nrep=10, maxiter=10000)
sentM3 <- poLCA(cbind(fengqing, lianghui, zhaoyuan, kunming,  wenzhang)~1,data=dat, nclass=3, nrep=10, maxiter=10000)
sentM4 <- poLCA(cbind(fengqing, lianghui, zhaoyuan, kunming,  wenzhang)~1,data=dat, nclass=4, nrep=10, maxiter=10000)
sentM5 <- poLCA(cbind(fengqing, lianghui, zhaoyuan, kunming,  wenzhang)~1,data=dat, nclass=5, nrep=10, maxiter=10000)
## check aic, bic and loglik (take model sentM4 as an example)
## these are useful for model choice
sentM4$aic
sentM4$bic
sentM4$llik
## source cmpLCA.R first, then we can do the following
cmpLCA(sentM1, sentM2, sentM3, sentM4, sentM5)

# if we choose 4-class model
# To keep the conditional probabilities almost identical for each run, sepcify the probs.start manually
probs.start.new <- poLCA.reorder(sentM4$probs.start,order(sentM4$P,decreasing=TRUE))
sentM4alt <- poLCA(cbind(fengqing, lianghui, zhaoyuan, kunming, wenzhang)~1,data=dat, nclass=4, nrep=10, maxiter=10000,probs.start = probs.start.new)

## if we take this as the final model, and generate the predicted class
dat$cls <- NA
cases_without_missing <- complete.cases(dat[,c("fengqing", "lianghui", "zhaoyuan", "kunming", "wenzhang")])
dat$cls[cases_without_missing] <- sentM4alt$predclass
## note the trick here: these with missing variables are excluded from the latent class analysis
##      and the predicted class is not avaiable


cmplca <- function(..., plot=TRUE){
  ## lca models fitted by library(lcca)
  obj <- list(...)
  nclass <- sapply(obj, function(x) nrow(x$param$gamma))
  aic <- sapply(obj, function(x) x$AIC)
  bic <- sapply(obj, function(x) x$BIC)
  ans <- data.frame(nclass=nclass, aic=aic, bic=bic)
  if (plot){
    require(lattice)
    print(xyplot(aic+bic~nclass, type="b",lty=c(1,2), auto.key=list(columns = 2)))
  }
  ans
}

library(lcca)
mod <- cbind(proElection, consitutionalism, transparency, newsRegulation, sarft, netRegulation, propaganda, univalues, citizenship, rights, ruleOfLaw)~1
summary(fit1 <- lca(mod, data=dat, nclass=1))
summary(fit2 <- lca(mod, data=dat, nclass=2))
summary(fit3 <- lca(mod, data=dat, nclass=3))
summary(fit4 <- lca(mod, data=dat, nclass=4))
summary(fit5 <- lca(mod, data=dat, nclass=5))
summary(fit6 <- lca(mod, data=dat, nclass=6))
summary(fit7 <- lca(mod, data=dat, nclass=7))
cmplca(fit1, fit2, fit3, fit4, fit5, fit6, fit7)
