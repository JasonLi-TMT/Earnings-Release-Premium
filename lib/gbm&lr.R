# Read & clean data
short_after_selected <- read.csv("short_after20.csv")
short_after_selected$X <- ifelse(short_after_selected$RETURN >0, 1,0)
short_after_selected <- na.omit(short_after_selected)
short_after_selected <- short_after_selected[,-1]
short_after_selected <- short_after_selected[,-11]
test.index <- sample(1:1500,300,replace = F)
test.sas <- short_after_selected[test.index,]
test.sas.x <- test.sas[,-1]
train.sas <- short_after_selected[-test.index,]
colnames(train.sas)[1] <-"y"
colnames(test.sas)[1] <-"y"

# GBM
res_gbm = train.baseline(train.sas)
pred.gbm = predict(res_gbm$gbm, test.sas.x, n.tree = 400, type = 'response')
pred.gbm = ifelse(pred.gbm > 0.5, 1, 0)
r = table(pred.gbm,test.sas$y)
performance_statistics(r)

# Logistic regression
res_logi = train.log(train.sas) 
pred.logi = predict(res_logi, test.sas.x, type = 'response')
pred.logi = ifelse(pred.logi > 0.5, 1, 0)
r2 = table(pred.logi,test.sas$y)
performance_statistics(r2)
