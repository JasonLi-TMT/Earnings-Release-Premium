## Cross Validation ###
########################

cv.function <- function(data, K){
  
  n <- nrow(data)
  n.fold <- floor(n/K)
  s <- sample(rep(1:K, c(rep(n.fold, K-1), n-(K-1)*n.fold)))
  cv.error.gbm <- rep(NA, K)
  cv.error.BP <- rep(NA, K)
  cv.error.rf <- rep(NA, K)
  cv.error.svm <- rep(NA, K)
  cv.error.log <- rep(NA, K)
  cv.error.vote <- rep(NA, K)
  
  for (i in 1:K){
    train.data <- data[s != i,]
    test.data <- data[s == i,]
    
    fit.gbm <- train.gbm(train.data)
    pred.gbm <- test.gbm(fit.gbm, test.data)  
    cv.error.gbm[i] <- mean(pred.gbm != test.data$y)
    
    fit.BP <- train.bp(train.data)
    pred.BP <- test.bp(fit.BP, test.data)  
    cv.error.BP[i] <- mean(pred.BP != test.data$y)
    
    fit.rf <- train.rf(train.data)
    pred.rf <- test.rf(fit.rf, test.data)  
    cv.error.rf[i] <- mean(pred.rf != test.data$y)
    
    fit.svm <- train.svm(train.data)
    pred.svm <- test.svm(fit.svm, test.data)  
    cv.error.svm[i] <- mean(pred.svm != test.data$y)
    
    fit.log <- train.log(train.data)
    pred.log <- test.log(fit.log, test.data)
    cv.error.log[i] <- mean(pred.log != test.data$y)
    
    pre=(as.numeric(as.character(pred.gbm))+as.numeric(as.character(pred.rf))+as.numeric(as.character(pred.svm)))
    pre=ifelse(pre>=2,1,0)
    cv.error.vote[i] <- mean(pre != test.data$y)
  }			
  cv.error<- data.frame(gbm = mean(cv.error.gbm) ,
                        bp = mean(cv.error.BP), 
                        rf = mean(cv.error.rf), 
                        svm = mean(cv.error.svm), 
                        logistic= mean(cv.error.log),
                        vote= mean(cv.error.vote))
  return(cv.error)
}
