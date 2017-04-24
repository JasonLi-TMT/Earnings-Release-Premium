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
