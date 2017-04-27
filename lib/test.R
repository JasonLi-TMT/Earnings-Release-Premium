library(gbm)
library(caret)
library(DMwR)
library(nnet)
library(randomForest)
library(e1071)

############ gbm ######################

test.gbm=function(model,test.data)
{
  test.gbm = predict(model, test.data, n.tree = 400, type = 'response')
  test.gbm = ifelse(test.gbm > 0.5, 1, 0)
  return(test.gbm)
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
  pre.svm <- predict(model,test.data,type="class")
  return(pre.svm)
}

############ Logistic ######################
test.log <- function(model, test_data) 
{
  result<- predict(model,newdata =test_data,type = 'response')
  fitted.results <- ifelse(result>0.5,1,0)
  return(fitted.results)
}
