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
