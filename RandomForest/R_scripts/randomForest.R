setwd("/project/hackathon/hackers12/shared/RandomForest")

library(randomForest)
library(pROC)

##-------------- stage 4 classifier:
n.tree <- 10000
load("data_for_modeling_stage4.RData")
load("stage4classifier_30input_index_10242018.RData")

RF.fit <- randomForest(train[,rfe.30.picks.index], as.factor(train$y), ntree=n.tree, xtest=test[,rfe.30.picks.index], ytest=as.factor(test$y),importance = T, keep.forest=T)
print(RF.fit$err.rate[n.tree,])
#print(RF.fit$test[["err.rate"]][n.tree,])
##predict(RF.fit, test[,-76], type="prob")
table(test$y, predict(RF.fit, test[,rfe.30.picks.index]))

## 
TS <- format(Sys.time(), "_%Y%m%d_%H%M%S")
save(RF.fit, file=paste("stage4classifier_RF_ntree",n.tree, TS,".RData", sep=""))
pdf(paste("stage4classifier_RF_errPlot",TS,".pdf", sep=""), width=5, height=4)
plot(RF.fit); dev.off();
pdf(paste("stage4classifier_RF_ImpPlot",TS,".pdf", sep=""), width=20, height=15)
varImpPlot(RF.fit, sort=T, main="Variable Importance"); dev.off();

## ----- test set AUC:
pred.30 <- predict(RF.fit, test[,rfe.30.picks.index], type="prob")
true <- test$y
ppp <- roc(true, pred.30[,2], direction="<")
pdf(paste("stage4_RF30_test_set_ROC",TS,".pdf", sep=""), width=4, height=4)
plot(ppp, col="blue", lwd=3, main="Test Set: n = 9") ## 
legend("bottomright", legend=paste("AUC = ", round(ppp$auc[1], digits=3), sep=""),col="blue", lty=1,cex=0.8)
dev.off()


rm(list=ls())
##-------------- stage 3 classifier:
n.tree <- 10000
load("data_for_modeling_stage3.RData")
load("stage3classifier_30input_index_10242018.RData")

RF.fit <- randomForest(train[,rfe.30.picks.index], as.factor(train$y), ntree=n.tree, xtest=test[,rfe.30.picks.index], ytest=as.factor(test$y),importance = T, keep.forest=T)
print(RF.fit$err.rate[n.tree,])
#print(RF.fit$test[["err.rate"]][n.tree,])
##predict(RF.fit, test[,-76], type="prob")
table(test$y, predict(RF.fit, test[,rfe.30.picks.index]))

## 
TS <- format(Sys.time(), "_%Y%m%d_%H%M%S")
save(RF.fit, file=paste("stage3classifier_RF_ntree",n.tree, TS,".RData", sep=""))
pdf(paste("stage3classifier_RF_errPlot",TS,".pdf", sep=""), width=5, height=4)
plot(RF.fit); dev.off();
pdf(paste("stage3classifier_RF_ImpPlot",TS,".pdf", sep=""), width=20, height=15)
varImpPlot(RF.fit, sort=T, main="Variable Importance"); dev.off();

## ----- test set AUC:
pred.30 <- predict(RF.fit, test[,rfe.30.picks.index], type="prob")
true <- test$y
ppp <- roc(true, pred.30[,2], direction="<")
pdf(paste("stage3_RF30_test_set_ROC",TS,".pdf", sep=""), width=4, height=4)
plot(ppp, col="blue", lwd=3, main="Test Set: n = 9") ## 
legend("bottomright", legend=paste("AUC = ", round(ppp$auc[1], digits=3), sep=""),col="blue", lty=1,cex=0.8)
dev.off()



rm(list=ls())
##-------------- stage 1 or 2 classifier:
n.tree <- 10000
load("data_for_modeling_stage1or2.RData")
load("stage1or2classifier_30input_index_10242018.RData")

RF.fit <- randomForest(train[,rfe.30.picks.index], as.factor(train$y), ntree=n.tree, xtest=test[,rfe.30.picks.index], ytest=as.factor(test$y),importance = T, keep.forest=T)
print(RF.fit$err.rate[n.tree,])
#print(RF.fit$test[["err.rate"]][n.tree,])
##predict(RF.fit, test[,-76], type="prob")
table(test$y, predict(RF.fit, test[,rfe.30.picks.index]))

## 
TS <- format(Sys.time(), "_%Y%m%d_%H%M%S")
save(RF.fit, file=paste("stage1or2classifier_RF_ntree",n.tree, TS,".RData", sep=""))
pdf(paste("stage1or2classifier_RF_errPlot",TS,".pdf", sep=""), width=5, height=4)
plot(RF.fit); dev.off();
pdf(paste("stage1or2classifier_RF_ImpPlot",TS,".pdf", sep=""), width=20, height=15)
varImpPlot(RF.fit, sort=T, main="Variable Importance"); dev.off();

## ----- test set AUC:
pred.30 <- predict(RF.fit, test[,rfe.30.picks.index], type="prob")
true <- test$y
ppp <- roc(true, pred.30[,2], direction="<")
pdf(paste("stage1or2_RF30_test_set_ROC",TS,".pdf", sep=""), width=4, height=4)
plot(ppp, col="blue", lwd=3, main="Test Set: n = 9") ## 
legend("bottomright", legend=paste("AUC = ", round(ppp$auc[1], digits=3), sep=""),col="blue", lty=1,cex=0.8)
dev.off()