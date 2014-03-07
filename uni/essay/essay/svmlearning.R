n<-150
p<-2
sigma<-1
meanpos<-0
meanneg<-3
npos<-round(n/2)
nneg<-n-npos

xpos <- matrix(rnorm(npos*p,mean=meanpos,sd=sigma),npos,p)
xneg <- matrix(rnorm(nneg*p,mean=meanneg,sd=sigma),npos,p)
x<-rbind(xpos,xneg)
y <- matrix(c(rep(1,npos),rep(-1,nneg)))

plot(x,col=ifelse(y>0,1,2))
legend("topleft",c('Positive','Negative'),col=seq(2),pch=1,text.col=seq(2))

ntrain <- round(n*0.8) # number of training examples
tindex <- sample(n,ntrain) # indices of training samples
xtrain <- x[tindex,]
xtest <- x[-tindex,]
ytrain <- y[tindex]
ytest <- y[-tindex]
istrain=rep(0,n)
istrain[tindex]=1
plot(x,col=ifelse(y>0,1,2),pch=ifelse(istrain==1,1,2))
legend("topleft",c('Positive Train','Positive Test','Negative Train','Negative Test'),
       col=c(1,1,2,2),pch=c(1,2,1,2),text.col=c(1,1,2,2))

require(kernlab)
svp <- ksvm(xtrain,ytrain,type="C-svc",kernel='rbfdot',C=10)
scaling(svp)
svp

attributes(svp)

alpha(svp)
alphaindex(svp)
b(svp)

plot(svp,data=xtrain)

ypred=predict(svp,xtest)
table(ytest,ypred)
sum(ypred==ytest)/length(ytest)
ypredscore=predict(svp,xtest,type="decision")

table(ypredscore>0,ypred)
require(ROCR)
pred<-prediction(ypredscore,ytest)
perf<-performance(pred,measure="tpr",x.measure="fpr")
plot(perf)
perf<-performance(pred,measure="prec",x.measure="rec")
plot(perf)
perf<-performance(pred,measure="acc")k
plot(perf)


sv=xtrain[alphaindex(svp)[[1]],]
svc=scale(xtrain[alphaindex(svp)[[1]],],c(1.578549,1.481740),c(1.759381 ,1.694810))
ssum(apply(cbind(coef(svp)[[1]],sv),1,function(x){
  x[1]*(x[-1]%*%xtest[1,])
}))-b(svp)
ypredscore[1]

scaledxt=(xtest[1,]-c(1.578549,1.481740))/c(1.759381 ,1.694810)

sum(apply(cbind(coef(svp)[[1]],sv),1,function(x){
  sx[1]*(x[-1]%*%scaledxt)
}))-b(svp)

sum(apply(cbind(coef(svp)[[1]],svc),1,function(x){
  x[1]*(x[-1]%*%as.vector(sc2))
}))-b(svp)

object=svp
newdata=t(matrix(xtest[1,]))
sc2=scale(newdata[, 
              scaling(object)$scaled, drop = FALSE], center = scaling(object)$x.scale$"scaled:center", 
      scale = scaling(object)$x.scale$"scaled:scale")