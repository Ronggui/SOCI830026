## demonstrating how the parameters change the logistic curve
curve(plogis(x-8),-20,20,lty=1)
curve(plogis(x-4),-20,20,lty=2,add=T)
curve(plogis(x),-20,20,lty=3,add=T)
curve(plogis(x+4),-20,20,lty=4,add=T)
curve(plogis(x+8),-20,20,lty=5,add=T)

curve(plogis(x*0.25),-20,20,lty=1)
curve(plogis(x*0.5),-20,20,lty=2,add=T)
curve(plogis(x*0.1),-20,20,lty=3,add=T)
curve(plogis(x*2),-20,20,lty=4,add=T)
curve(plogis(x*4),-20,20,lty=5,add=T)

curve(plogis(x*-0.25),-20,20,lty=1,col="red",add=T)
curve(plogis(x*-0.5),-20,20,lty=2,col="red",add=T)
curve(plogis(x*-0.1),-20,20,lty=3,col="red",add=T)
curve(plogis(x*-2),-20,20,lty=4,col="red",add=T)
curve(plogis(x*-4),-20,20,lty=5,col="red",add=T)

## fit a logistic model
library(car)
summary(m1 <- glm(lfp~k5+k618+age+wc+hc+lwg+inc,data=Mroz,family=binomial))
## visualization of model coefficients
library(coefplot)
coefplot(m1)

## goodness of fit
library(LogisticDx)
logiGOF(m1, g = 10)
logiDx(m1)


