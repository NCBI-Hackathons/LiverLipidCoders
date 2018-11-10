setwd("/project/hackathon/hackers12/shared/RandomForest")

library(mlbench)
library(caret)
library(glmnet)
library(pROC)

rfFuncs_RL <- rfFuncs
rfFuncs_RL$summary <- function (data, lev = NULL, model = NULL) { #Computes Sens, Spec. and ROC for a given model
  if (is.character(data$obs)) {
    data$obs <- factor(data$obs, levels = lev)
  }
  if (is.character(data$pred)) {
    data$pred <- factor(data$pred, levels = lev)
  }
  twoClassSummary(data, lev = lev, model = NULL)
}

control <- rfeControl(functions=rfFuncs_RL, 
                      method = "repeatedCV",
                      number = 10,
                      repeats = 5,
                      rerank = FALSE,
                      returnResamp = "all")

## ------------ stage 4 classifier:
load("data_for_modeling_stage4.RData")
rfe.30.fit <- rfe(train[,-1], as.factor(train[,1]), sizes=30, metric='ROC',rfeControl=control)
#sapply(rfe.30.fit, class)
#sapply(rfe.30.fit, length)
print(rfe.30.fit)
save(rfe.30.fit, file="stage4classifier_rfe_30_fit_10242018.RData")


if(length(rfe.30.fit$optVariables)==30){
  rfe.30.picks <- rfe.30.fit$optVariables
  rfe.30.picks.index <- sapply(rfe.30.picks, function(x){which(names(train)==x)})
  save(rfe.30.picks, rfe.30.picks.index, file="stage4classifier_rfe_30_picks_tuning_index_10242018.RData")
}else{
  print("length(rfe.30.fit$optVariables)!=30")
  print('\n')
  rfe.30.fit.update <- update(rfe.30.fit, train[,-1], train[,1], size=30)
  rfe.30.picks <- rfe.30.fit.update$bestVar
  rfe.30.picks.index <- sapply(rfe.30.picks, function(x){which(names(train)==x)})
  save(rfe.30.picks, rfe.30.picks.index, file="stage4classifier_rfe_30_picks_update_index_10242018.RData")
}


save(rfe.30.picks.index, file="stage4classifier_30input_index_10242018.RData")

## ------------ stage 3 classifier:
load("data_for_modeling_stage3.RData")
rfe.30.fit <- rfe(train[,-1], as.factor(train[,1]), sizes=30, metric='ROC',rfeControl=control)
#sapply(rfe.30.fit, class)
#sapply(rfe.30.fit, length)
print(rfe.30.fit)
save(rfe.30.fit, file="stage3classifier_rfe_30_fit_10242018.RData")


if(length(rfe.30.fit$optVariables)==30){
  rfe.30.picks <- rfe.30.fit$optVariables
  rfe.30.picks.index <- sapply(rfe.30.picks, function(x){which(names(train)==x)})
  save(rfe.30.picks, rfe.30.picks.index, file="stage3classifier_rfe_30_picks_tuning_index_10242018.RData")
}else{
  print("length(rfe.30.fit$optVariables)!=30")
  print('\n')
  rfe.30.fit.update <- update(rfe.30.fit, train[,-1], train[,1], size=30)
  rfe.30.picks <- rfe.30.fit.update$bestVar
  rfe.30.picks.index <- sapply(rfe.30.picks, function(x){which(names(train)==x)})
  save(rfe.30.picks, rfe.30.picks.index, file="stage3classifier_rfe_30_picks_update_index_10242018.RData")
}

save(rfe.30.picks.index, file="stage3classifier_30input_index_10242018.RData")

## ------------ stage 1 or 2 classifier:
load("data_for_modeling_stage1or2.RData")
rfe.30.fit <- rfe(train[,-1], as.factor(train[,1]), sizes=30, metric='ROC',rfeControl=control)
#sapply(rfe.30.fit, class)
#sapply(rfe.30.fit, length)
print(rfe.30.fit)
save(rfe.30.fit, file="stage1or2classifier_rfe_30_fit_10242018.RData")


if(length(rfe.30.fit$optVariables)==30){
  rfe.30.picks <- rfe.30.fit$optVariables
  rfe.30.picks.index <- sapply(rfe.30.picks, function(x){which(names(train)==x)})
  save(rfe.30.picks, rfe.30.picks.index, file="stage1or2classifier_rfe_30_picks_tuning_index_10242018.RData")
}else{
  print("length(rfe.30.fit$optVariables)!=30")
  print('\n')
  rfe.30.fit.update <- update(rfe.30.fit, train[,-1], train[,1], size=30)
  rfe.30.picks <- rfe.30.fit.update$bestVar
  rfe.30.picks.index <- sapply(rfe.30.picks, function(x){which(names(train)==x)})
  save(rfe.30.picks, rfe.30.picks.index, file="stage1or2classifier_rfe_30_picks_update_index_10242018.RData")
}

save(rfe.30.picks.index, file="stage1or2classifier_30input_index_10242018.RData")