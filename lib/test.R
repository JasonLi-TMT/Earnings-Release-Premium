library(gbm)
library(caret)
library(DMwR)
library(nnet)
library(randomForest)
library(e1071)

############ gbm ######################

test.gbm=function(model,test.data)
{
  prediction=ifelse(predict(model$gbm,test.data,n.trees=model$n)>0.5,1,0)
  return(prediction)
}

############ BP network ######################
test.bp=function(model,test.data)
{
  pre.nnet <- predict(model, test.data, type = "class")
  return(pre.nnet)
}

############ Random Forest ######################
test.rf <- function(model,test.data) {
  return(predict(model, test.data, type = "class"))
}


############ SVM ######################
test.svm <- function(model,test.data)
{
  return(predict(model,test.data,type="class"))
}

############ Logistic ######################
test.log <- function(model, test_data) 
{
  result<- predict(model,newdata =test_data,type = 'response')
  fitted.results <- ifelse(result>0.5,1,0)
  return(fitted.results)
}
