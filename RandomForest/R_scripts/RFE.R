
## This is the script for BioHPC batch run:
## RFE corss validation 
setwd("/project/hackathon/hackers12/shared/RandomForest")
load("data_for_modeling_stage4.RData")

#install.packages("caret",
#                 repos = "http://cran.r-project.org", 
#                 dependencies = c("Depends", "Imports", "Suggests"))
# install.packages("mlbench")
library(mlbench)
library(caret)

# define the control using a random forest selection function
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
                      returnResamp = "final")
# run the RFE algorithm
RFE <- rfe(train[,-1], train[,1], 
           sizes = c(5:200), 
           metric='ROC',
           maximize=TRUE,
           rfeControl = control)

print(RFE)

TS <- format(Sys.time(), "_%Y%m%d_%H%M%S")
print(TS)
save(RFE, file=paste("RFE_5repeated10fold_cross_validation_stage4", TS,".RData", sep=""))
pdf(paste("cross_validation_ROC_Plot_stage4",TS,".pdf", sep=""), width=5, height=4)
plot(RFE); dev.off();

RFE.results <- RFE$results
max(RFE.results$ROC)
RFE.results$Variables[which(RFE.results$ROC==max(RFE.results$ROC))]  ## 
pdf(paste("CV_ROC_Plot_stage4",TS,".pdf", sep=""), width=10, height=4)
plot(RFE.results$Variables, RFE.results$ROC, xlab="Number of Inputs", ylab="ROC AUC in Tranining Set", main="Recursive Feature Elimination (5 repeated 10-fold CV)")
##abline(v=?, col="red");text(? , ?, "x = ?", col = "red");
dev.off();

## ---------------------------- stage 3 classifier:
load("data_for_modeling_stage3.RData")

TS <- format(Sys.time(), "_%Y%m%d_%H%M%S")
print(TS)
save(RFE, file=paste("RFE_5repeated10fold_cross_validation_stage3", TS,".RData", sep=""))
pdf(paste("cross_validation_ROC_Plot_stage3",TS,".pdf", sep=""), width=5, height=4)
plot(RFE); dev.off();

RFE.results <- RFE$results
max(RFE.results$ROC)
RFE.results$Variables[which(RFE.results$ROC==max(RFE.results$ROC))]  ## 
pdf(paste("CV_ROC_Plot_stage3",TS,".pdf", sep=""), width=10, height=4)
plot(RFE.results$Variables, RFE.results$ROC, xlab="Number of Inputs", ylab="ROC AUC in Tranining Set", main="Recursive Feature Elimination (5 repeated 10-fold CV)")
##abline(v=?, col="red");text(? , ?, "x = ?", col = "red");
dev.off();

## ---------------------------- stage 1or2 classifier:
load("data_for_modeling_stage1or2.RData")

TS <- format(Sys.time(), "_%Y%m%d_%H%M%S")
print(TS)
save(RFE, file=paste("RFE_5repeated10fold_cross_validation_stage1or2", TS,".RData", sep=""))
pdf(paste("cross_validation_ROC_Plot_stage1or2",TS,".pdf", sep=""), width=5, height=4)
plot(RFE); dev.off();

RFE.results <- RFE$results
max(RFE.results$ROC)
RFE.results$Variables[which(RFE.results$ROC==max(RFE.results$ROC))]  ## 
pdf(paste("CV_ROC_Plot_stage1or2",TS,".pdf", sep=""), width=10, height=4)
plot(RFE.results$Variables, RFE.results$ROC, xlab="Number of Inputs", ylab="ROC AUC in Tranining Set", main="Recursive Feature Elimination (5 repeated 10-fold CV)")
##abline(v=?, col="red");text(? , ?, "x = ?", col = "red");
dev.off();
