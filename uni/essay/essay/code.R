# contamination 
# same x is predicting different 1
# same genetic profile 
# hidden predictor for y we are not measuring 



require(MASS)
require(ggplot2)
require(e1071)
require(reshape)
require(multicore)
require(Hmisc)
require(ROCR)

set.seed(123456789)
auc<-function (y, phat)
{
  # the two arguments are:
  # y = list of actual binary labels, 0, 1;
  # phat = list of ranking (or predicted probability) that an item is a 1 rather than a 0
  y <- as.numeric(y)
  phat <- as.numeric(phat)
  prediction(phat, y)->obj
  performance(obj,'auc')->junk
  as.numeric(attr(junk,'y.values'))
}

uncorrelated<-function(totalfeat=200,realfeat=10,nobs=500,beta=c(1.1,2),flip=0,...){
   truecovs=data.frame(matrix(rnorm(nobs*realfeat),ncol=realfeat))
  if(length(beta)==2) betas=seq(beta[1],beta[2],length.out=realfeat)
  z=apply(truecovs,1,function(x){
    z=rep(0,length(x))
    for (i in 1:length(x)) z[i]=x[i]*ifelse(length(beta)==1,log(beta),log(betas[i]))
    sum(z)
  })
  pr=1/(1+exp(-z))
  Y=rbinom(nobs,1,pr)
  noise=mvrnorm(nobs,rnorm(totalfeat-realfeat),diag(totalfeat-realfeat))
  data=data.frame(Y,truecovs,noise)
  colnames(data)[-1]=sapply(1:(ncol(data)-1),function(x) paste0("X",x))
  if(flip){
    flips=sample(1:nobs,flip)
    data$Y[flips]=1-data$Y[flips]
    flipped<<-flips
  }
  return(data)
}

getsupportvectors<-function(svm.model,Y,svlimit=500,...){
  sv=svm.model$index[which(abs(svm.model$coefs)==1)]
  f=svm.model$decision.values[sv]
  true=ifelse(Y[sv]==1,1,-1)
  
  distance=f*true*-1
  index=order(distance,decreasing=T)
#   coef=svm.model$coefs
#   sc=coef[index]
#   sf=f[index]
#   st=true[index]
#   sd=distance[index]
 sv=sv[index]  
 sv[1:min(length(sv),svlimit)]
}
fitsvm<-function(...){
  points=uncorrelated(...)
  #cname=colnames(points)
  #points$y=factor(points$y)
  #plot(ggplot(points,aes(x1,x2,color=factor(y)))+geom_point())
  #svm.model=tune.svm(y~.,data=points,type="C-classification",kernel="linear")
  svm.model=svm(Y~.,data=points,type="C-classification",kernel="linear",cost=1)
  sv=getsupportvectors(svm.model,points$Y,...)
  results=cbind(t(sapply(colnames(points)[-1],function(var){
    f=as.formula(paste0(var,"~Y"))
    c(t.test(f,data=points)$p.value,
      t.test(f,data=points[!1:nrow(points)%in%sv,])$p.value)
  })))
  #rownames(results)=1:length(cname[-1])
  colnames(results)=c("Normal","SVM")
  results=melt(results)
  results$X1=as.numeric(substring(results$X1,2))
  pvalues=as.matrix(aggregate(results$value, by=list(results$X2), FUN=mean)[2])
  results$nullp=pvalues[1]
  results$nullp[results$X2=="SVM"]=pvalues[2]
  results$sv=length(sv) 
  colnames(results)=c("feature","type","pvalue","nullp","sv")
  results=results[order(results$type,results$pvalue),]
  return(results)
}
simresult<-function(df,topn=10,realfeat=10,...){
  df$y=ifelse(df$feature<=realfeat,1,0)
  df$nltp=-log10(df$pvalue)
  dfsvm=subset(df,df$type=="SVM")
  dfnormal=subset(df,df$type=="Normal")
  aucresult=c(auc(dfsvm$y,dfsvm$nltp),auc(dfnormal$y,dfnormal$nltp))
  fweresult=c(sum(dfsvm$feature[1:topn]<=realfeat),sum(dfnormal$feature[1:topn]<=realfeat))
  fweresult20=c(sum(dfsvm$feature[1:20]<=realfeat),sum(dfnormal$feature[1:20]<=realfeat))
  c(aucresult,fweresult,fweresult20,df$nullp[nrow(df)],df$nullp[1],df$sv[1])
}

simulatesvm<-function(n,...){
  result=mclapply(1:n,function(x) fitsvm(...),mc.cores=8)
  #print(result)
  result=matrix(unlist(mclapply(result,function(x)simresult(x,...),mc.cores=8)),ncol=9,byrow=T)
  apply(result,2,mean)
}



sim<-function(n,betas,svlimit=500,flip=0){
  OR=sapply(betas,function(x)simulatesvm(n=n,beta=x,svlimit=svlimit,flip=flip))
  OR=data.frame(t(OR))
  colnames(OR)=c("SVM","Normal","SVM","Normal","SVM","Normal","SVM","Normal","\\#SV")
  OR=round(OR,3)
  #print(betas)
  if(class(betas)=="list") rownames(OR)=sapply(betas,function(x) paste0(x[1],"-",x[2])) else rownames(OR)= betas
  return(OR)
}

# makehist<-function(...){
#   a=fitsvm(...)
#   colnames(a)=c("feature","type","pvalue","sv")
#   a=a[!a$feature%in%sapply(1:10,function(x)paste0("X",x)),]
#   
#   aggregate(a$pvalue, by=list(a$type), FUN=mean)[2]
#   ggplot(a,aes(x=pvalue))+geom_density(aes(fill=type))
# }

