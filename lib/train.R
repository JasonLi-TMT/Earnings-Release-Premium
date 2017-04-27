library(gbm)
library(caret)
library(DMwR)
library(nnet)
library(randomForest)
library(e1071)

############ gbm ############################
train.gbm <- function(traindata){
  model.gbm = gbm(y~.,data=traindata,dist="adaboost",n.tree = 400,shrinkage=0.1)
  return(model.gbm)
}

############ SVM ###########################
train.svm<- function(traindata) {
  traindata$y <- as.factor(traindata$y)
  svm_tune <- tune(svm, 
                   y~DY+EBITG+EV2EBITDA+M2B+MOMENTUM+PB+PE+PF+PS+days+surprise,
                   data=traindata,
                   kernel="radial", 
                   ranges=list(cost=2^(3:8), 
                               gamma=c(0.3,0.4,0.5)))
  model.svm<- svm_tune$best.model
  return(model.svm)
}

############ BP network ######################
train.bp<- function(traindata) {
  traindata$y <- as.factor(traindata$y)
  tune_bpnn <- tune.nnet(y ~ ., data = traindata, linout = F,
                         size = 1:10, decay = 0.001:0.1, maxit = 200,
                         trace = F, MaxNWts=6000)
  model.nnet <- tune_bpnn$best.model
  return(model.nnet)
}

############ Random Forest ######################
# First tune random forest model, tune parameter 'mtry'
train.rf<- function(traindata) {
  traindata$y <- as.factor(traindata$y)
  y.index<- which(colnames(traindata)=="y")
  bestmtry <- tuneRF(y= traindata$y, x= traindata[,-y.index], stepFactor=1.5, improve=1e-5, ntree=600)
  best.mtry <- bestmtry[,1][which.min(bestmtry[,2])]
  model.rf <- randomForest(y ~ ., data = traindata, ntree=600, mtry=best.mtry, importance=T)
  return(model.rf)
}



############ Logistic ######################
train.log <- function(train_data){
  model.log <- glm(y~.,family = binomial(link="logit"),data=train_data)
  return(model.log)
}

############ SVM-2 ###########################
train.svm2<- function(traindata) {
  traindata$y <- as.factor(traindata$y)
  svm_tune <- tune(svm, 
                   y~DY+EBITG+EV2EBITDA+M2B+MOMENTUM+PB+PE+PF+PS+days,
                   data=traindata,
                   kernel="radial", 
                   ranges=list(cost=2^(-1:9), 
                               gamma=c(0.2,0.3,0.4,0.5,0.6)))
  model.svm<- svm_tune$best.model
  return(model.svm)
}
