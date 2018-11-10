## title: "Data Structure Explore"
## author: "U-HACK MED TEAM 12"
## date: "11/9/2018"

output.path <- "~/Downloads/hackathon/raw/output"
data.path <- "~/Downloads/hackathon/raw"
setwd(data.path)
data <- read.csv("data_file.csv",stringsAsFactors = F, na.strings=c("", " ", "NA", "na", "n/a", "N/a","."))

dim(data)
names(data)
class.v <- sapply(data, class)
table(class.v)
cat.index <- which(class.v=="character")
length(cat.index)
sample.names <- names(data)[10:99]
sample.names
lipid.names <- data[,1]
lipid.names[1:5]
lipid.names[1840:1846]
data.clean <- t(data[,10:99])
dim(data.clean)  ## [1]   90 1846
colnames(data.clean) <- lipid.names
## now need to match sample with stage group number:
table(row.names(data.clean)==sample.names)  ## all true
group.data <- read.csv("name_file.csv",stringsAsFactors = F, na.strings=c("", " ", "NA", "na", "n/a", "N/a","."))
dim(group.data)
names(group.data)
head(group.data)
group.data <- group.data[,-c(1,4:6)]
data.clean <- data.frame(data.clean)
data.clean$sample_name <- sample.names
dim(data.clean)
data.clean <- merge(data.clean, group.data, by="sample_name", all.x=T)
dim(data.clean)
table(data.clean$group_number)
save(data.clean, file="data_clean_with_group.RData")
data.clean <- data.clean[-which(data.clean$group_number>4),]
table(data.clean$group_number)
group.1 <- data.clean[which(data.clean$group_number==1),]
group.2 <- data.clean[which(data.clean$group_number==2),]
group.3 <- data.clean[which(data.clean$group_number==3),]
group.4 <- data.clean[which(data.clean$group_number==4),]
save(group.1, group.2, group.3, group.4, file="group_separated_unnormalized_data.RData")
## need to normalized the data:
library(mlbench)
library(caret)
library(glmnet)
library(pROC)
preprocessParams <- preProcess(data.clean[,-c(1,1848)], method=c("center", "scale")) 
data.clean[,-c(1,1848)] <- predict(preprocessParams, data.clean[,-c(1,1848)])
save(data.clean, file="normalized_combined_data.RData")
group.1 <- data.clean[which(data.clean$group_number==1),]
group.2 <- data.clean[which(data.clean$group_number==2),]
group.3 <- data.clean[which(data.clean$group_number==3),]
group.4 <- data.clean[which(data.clean$group_number==4),]
save(group.1, group.2, group.3, group.4, file="group_separated_normalized_data.RData")
library(gplots)

TS <- 11092018
pdf(paste("group1_",TS,".pdf", sep=""), width=15, height=25)
par(oma=c(2,5,5,5)) ## out margin
##par(mar=c(5,5,5,5))
tmp <- t(group.1[,-c(1,1848)])
colnames(tmp) <- group.1[,1]
heatmap.2(tmp,lhei = c(1,10), lwid = c(1,4) , margins=c(13,10)); dev.off();

pdf(paste("group2_",TS,".pdf", sep=""), width=15, height=25)
par(oma=c(2,5,5,5)) ## out margin
##par(mar=c(5,5,5,5))
tmp <- t(group.2[,-c(1,1848)])
colnames(tmp) <- group.2[,1]
heatmap.2(tmp,lhei = c(1,10), lwid = c(1,4) , margins=c(13,10)); dev.off();

pdf(paste("group3_",TS,".pdf", sep=""), width=15, height=25)
par(oma=c(2,5,5,5)) ## out margin
##par(mar=c(5,5,5,5))
tmp <- t(group.3[,-c(1,1848)])
colnames(tmp) <- group.3[,1]
heatmap.2(tmp,lhei = c(1,10), lwid = c(1,4) , margins=c(13,10)); dev.off();

pdf(paste("group4_",TS,".pdf", sep=""), width=15, height=25)
par(oma=c(2,5,5,5)) ## out margin
##par(mar=c(5,5,5,5))
tmp <- t(group.4[,-c(1,1848)])
colnames(tmp) <- group.4[,1]
heatmap.2(tmp,lhei = c(1,10), lwid = c(1,4) , margins=c(13,10)); dev.off();

summary.m <- sapply(data.clean[,-c(1,1848)], summary)
#load("data_clean_with_group.RData")
load("normalized_combined_data.RData")
library(corrplot)
data.clean <- data.clean[order(data.clean$group_number),]
tmp <- t(data.clean[,-c(1,1848)])
colnames(tmp) <- paste("Group",data.clean$group_number, data.clean$sample_name,sep="_")
cor.tmp <- cor(tmp)
pdf(paste("all_sample_corr_",TS,".pdf", sep=""), width=25, height=20)
corrplot(cor.tmp, type = "upper", order = "hclust", tl.col = "black", tl.srt = 45);dev.off();

table(data.clean$group_number)
test.index.1 <- sample(1:30, 3)
test.index.2 <- sample(1:17, 2)
test.index.3 <- sample(1:20, 2)
sample.in.test.set <- rbind(group.1[test.index.1,c(1,1848)], group.2[test.index.2,c(1,1848)], group.3[test.index.3,c(1,1848)], group.4[test.index.3,c(1,1848)])
write.csv(sample.in.test.set, file="samples_in_testing_set.csv", row.names = F)
test.index.1 <- sample(1:30, 3)
test.index.2 <- sample(1:17, 2)
test.index.3 <- sample(1:20, 2)
sample.in.val.set <- rbind(group.1[test.index.1,c(1,1848)], group.2[test.index.2,c(1,1848)], group.3[test.index.3,c(1,1848)], group.4[test.index.3,c(1,1848)])
intersect(sample.in.test.set$sample_name, sample.in.val.set$sample_name)
write.csv(sample.in.val.set, file="samples_in_val_set.csv", row.names = F)

test.index <- sapply(sample.in.test.set$sample_name, function(x){which(data.clean$sample_name==x)})
train.data <- data.clean[-test.index,]
test.data <- data.clean[test.index,]
save(train.data, test.data, file="data_for_modeling.RData")

train <- train.data[,-c(1,1848)]
y <- as.factor(train.data$group_number==4)
train <- cbind(y,train)
index.1 <- which(train$y=="TRUE")
index.0 <- which(train$y=="FALSE")
length(index.1)
length(index.0)
unb.train <- train
train <- train[c(index.0, sample(index.1, length(index.0), replace=T)),]
table(train$y)
test <- test.data[,-c(1,1848)]
y <- as.factor(test.data$group_number==4)
test <- cbind(y,test)
save(unb.train, train, test, file="data_for_modeling_stage4.RData")

train <- train.data[,-c(1,1848)]
y <- as.factor(train.data$group_number==3)
train <- cbind(y,train)
index.1 <- which(train$y=="TRUE")
index.0 <- which(train$y=="FALSE")
length(index.1)
length(index.0)
unb.train <- train
train <- train[c(index.0, sample(index.1, length(index.0), replace=T)),]
table(train$y)
test <- test.data[,-c(1,1848)]
y <- as.factor(test.data$group_number==3)
test <- cbind(y,test)
save(unb.train, train, test, file="data_for_modeling_stage3.RData")

train <- train.data[,-c(1,1848)]
y <- as.factor(train.data$group_number<3)
train <- cbind(y,train)
index.1 <- which(train$y=="TRUE")
index.0 <- which(train$y=="FALSE")
length(index.1)
length(index.0)
unb.train <- train
train <- train[c(index.1, sample(index.0, length(index.1), replace=T)),]
table(train$y)
test <- test.data[,-c(1,1848)]
y <- as.factor(test.data$group_number<3)
test <- cbind(y,test)
save(unb.train, train, test, file="data_for_modeling_stage1or2.RData")

## selected feature extraction:
load("~/Downloads/hackathon/RandomForest/RFE_5repeated10fold_cross_validation_stage1or2_20181109_224120.RData")
RFE.results <- RFE$results
dim(RFE.results)
RFE.results <- RFE.results[-197,]
## need to check the rfe cross validation of number variables: 
## looking for turning point:
#max(RFE.results$ROC)
#RFE.results$Variables[which(RFE.results$ROC==max(RFE.results$ROC))]  ## [1] 95
pdf(paste("RFE_stage1or2classifier.pdf", sep=""), width=8, height=4)
plot(RFE.results$Variables, RFE.results$ROC, xlab="Number of Inputs", ylab="ROC AUC in Tranining Set (n = 78)", main="Recursive Feature Elimination (5 repeated 10-fold CV)\nStage 1 or 2 Classifier")
abline(v=30, col="red");text(40,0.986, "x = 30", col = "red");dev.off();

load("~/Downloads/hackathon/RandomForest/RFE_5repeated10fold_cross_validation_stage3_20181109_224117.RData")
RFE.results <- RFE$results
dim(RFE.results)
RFE.results <- RFE.results[-197,]
## need to check the rfe cross validation of number variables: 
## looking for turning point:
pdf(paste("RFE_Figure.pdf", sep=""), width=8, height=4)
plot(RFE.results$Variables, RFE.results$ROC, xlab="Number of Inputs", ylab="ROC AUC in Tranining Set (n = 78)", main="Recursive Feature Elimination (5 repeated 10-fold CV)")
abline(v=10, col="red");text(20,0.986, "x = 10", col = "red");
abline(v=30, col="red");text(40,0.986, "x = 30", col = "red");dev.off();

pdf(paste("Scatter_Figure.pdf", sep=""), width=8, height=4)
ggplot(data.clean, aes(x=TAG.48.0..NL.18.0....NH4., y=TAG.48.0..NL.16.0....NH4., shape=as.factor(group_number), color=as.factor(group_number))) + geom_point()
dev.off();

load("~/Downloads/hackathon/RandomForest/stage3classifier_30input_index_10242018.RData")
stage3markers <- names(train[,rfe.30.picks.index])
load("~/Downloads/hackathon/RandomForest/stage4classifier_30input_index_10242018.RData")
stage4markers <- names(train[,rfe.30.picks.index])
load("~/Downloads/hackathon/RandomForest/stage1or2classifier_30input_index_10242018.RData")
stage1or2markers <- names(train[,rfe.30.picks.index])
markers <- c(stage3markers, stage4markers, stage1or2markers)
length(markers)  ## [1] 90
length(unique(markers)) ## [1] 85
unique.markers <- unique(markers)
write.csv(unique.markers, file="markers_based_on_random_forest_fitting.csv", row.names = F)

Alex.train <- read.csv("~/Downloads/hackathon/RandomForestDataReduction/Normed_Training_Data.csv", stringsAsFactors = F, na.strings=c("", " ", "NA", "na", "n/a", "N/a","."))
Alex.train <- Alex.train[,-1]
Alex.train[1:5, 1:10]
write.csv(t(Alex.train), file="Alex_train.csv")
Alex.train <- read.csv("Alex_train.csv")

lipid.name.table <- t(Alex.train[1,])
write.csv(lipid.name.table, file="lipid_marker_name_matching_table.csv")



