library(dplyr); library(caret); library(ggplot2); library(tictoc)


# Get files
folder <- getwd()
trainURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testURL <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
trainFile <- "pml-training.csv"
testFile <- "pml-testing.csv"

if (!file.exists(paste(folder, "/", trainFile, sep=""))) 
{download.file(trainURL, trainFile)}
if (!file.exists(paste(folder, "/", testFile, sep=""))) 
{download.file(testURL, testFile)}

# Load Data
data <- read.csv(trainFile, na.strings=c("NA","","#DIV/0!"))



# remove unnecessary data
## choose NA data
nacols <- apply(data, 2, max) %>% is.na %>% which

## Dealing with time data
# Time data is composed of two parts, and the first ones follow UNIX timestamp, 
# which can be converted into POSIXct format (year-month-day hr:minute:seconds),
# the second ones state the time below a second.
# In case we should take account of time-order of observations, we can combine 
# two separated time data into one since the absolute time values are not 
# important, but here, as we can see in the test data set, all obervations are 
# chosen regardless of time order. This means time data might not be important 
# in our analysis.

## choose unnecessary data
nacols <- c(1:7, nacols)

## remove unnecessary data
data <- data[,-nacols]

# standardization
## automatically ignore factor-labeled values
standardize.data <- preProcess(data, method=c("center", "scale")) 
data <- predict(standardize.data, data)

# create training/cross-validation/test sets
set.seed(10101)
## split data
inTrain <- createDataPartition(data$classe, p=0.6, list=FALSE) # 60% train
Testsplit <- split(as.integer(rownames(data))[-inTrain], c(1,2))
inCV <- Testsplit[[1]] # 20% Cross Validation
inTest <- Testsplit[[2]] # 20% Test

tr <- data[inTrain,]
cv <- data[inCV,]
ts <- data[inTest,]

## PCA of keeping 99% of variance, PCA functions standardize data automatically
pca.data <- preProcess(tr[,-53], method="pca", thresh=0.99)
tr <- cbind(predict(pca.data, tr[,-53]), classe=tr$classe) # apply to train set
cv <- cbind(predict(pca.data, cv[,-53]), classe=cv$classe) # apply to cross validation set
ts <- cbind(predict(pca.data, ts[,-53]),classe=ts$classe) # apply to test set

## split trainset into 10 folds
TrainSplit <- createFolds(tr$classe, k=10, list=TRUE) # train set into 10 folds



# train, test, and record errors  
## train-cv, result record function 
validate <- function(model){
  print(model)
  tic() # start runtime record
  mod <- train(classe~., data=tr, method=model) # train
  tictoc <- toc() # end runtime record
  time <- tictoc$toc - tictoc$tic # record elapsed time
  pr.tr <- predict(mod, tr) # predict training set
  pr.cv <- predict(mod, cv) # predict cross validation set
  # accuracy calculation
  tr.accu <- sum(pr.tr==tr$classe)/length(pr.tr)
  cv.accu <- sum(pr.cv==cv$classe)/length(pr.cv)
  
  assign(paste("mod.", model, sep=""), mod, envir=globalenv())
  assign(paste("tr.accu.", model, sep=""), tr.accu, envir=globalenv())
  assign(paste("cv.accu.", model, sep=""), cv.accu, envir=globalenv())
  assign(paste("time.", model, sep=""), time, envir=globalenv())
  assign(paste("pr.tr.", model, sep=""), pr.tr, envir=globalenv())
  assign(paste("pr.cv.", model, sep=""), pr.cv, envir=globalenv())
}

## by folds
validate.by.folds <- function(model){
  index <- vector()
  tr.accu <- vector()
  cv.accu <- vector()
  time<- vector()
  print(model)
  for(i in 1:10){
    index <- c(index, TrainSplit[[i]]) # indexing
    training <- tr[index,] # training set
    tic() # start runtime record
    mod <- train(classe~., data=training, method=model) # train
    tictoc <- toc() # end runtime record
    time <- c(time, tictoc$toc - tictoc$tic) # record elapsed time
    pr.tr <- predict(mod, training) # predict training set
    pr.cv <- predict(mod, cv) # predict cross validation set
    # accuracy calculation
    tr.accu <- c(tr.accu, sum(pr.tr==training$classe)/length(pr.tr))
    cv.accu <- c(cv.accu, sum(pr.cv==cv$classe)/length(pr.cv))
  }
  assign(paste("mod.", model, sep=""), mod, envir=globalenv())
  assign(paste("tr.accu.", model, sep=""), tr.accu, envir=globalenv())
  assign(paste("cv.accu.", model, sep=""), cv.accu, envir=globalenv())
  assign(paste("time.", model, sep=""), time, envir=globalenv())
  assign(paste("pr.tr.", model, sep=""), pr.tr, envir=globalenv())
  assign(paste("pr.cv.", model, sep=""), pr.cv, envir=globalenv())
}

## test set, record function 
test <- function(model){
  mod <- paste("mod.", model, sep="")
  pr.ts <- predict(get(mod), ts) # predict test set
  # beware of using get() for taking characters as a variable name
  cm <- confusionMatrix(pr.ts, ts$classe)
  assign(paste("result.", model, sep=""), cm, envir=globalenv())
  assign(paste("ts.accu.", model, sep=""), cm$overall[1], envir=globalenv())
  assign(paste("pr.ts.", model, sep=""), pr.ts, envir=globalenv())
}

# run each model
models <- c("lda", "qda", "mlp", "svmLinear", "svmRadial", 
            "rpart", "treebag", "bstTree", "rf", 
            "multinom", "gbm", "nb")
for(i in models){
  validate(i)
  test(i)
}


# summarize results
elapsed.time <- vector()
tr.accuracy <- vector()
cv.accuracy <- vector()
ts.accuracy <- vector()
for (i in models){
  elapsed.time <- c(elapsed.time, get(paste("time.", i, sep="")))
  tr.accuracy <- c(tr.accuracy, get(paste("tr.accu.", i, sep="")))
  cv.accuracy <- c(cv.accuracy, get(paste("cv.accu.", i, sep="")))
  ts.accuracy <- c(ts.accuracy, get(paste("ts.accu.", i, sep="")))
  #rm(paste("time.", "i", sep=""))
  #rm(paste("tr.accu.", i, sep=""))
  #rm(paste("cv.accu.", i, sep=""))
  #rm(paste("ts.accu.", i, sep=""))
}
results <- data.frame(elapsed.time, tr.accuracy, cv.accuracy, ts.accuracy)
rownames(results) <- models


# Ensemble
## get training prediction results
predicted.tr <- as.data.frame(matrix(nrow=dim(tr)[1], ncol=length(models)))
iter <- 0
for (i in models){
  iter <- iter + 1
  # predicted.tr[,iter] <- predict(get(paste("mod.", i, sep="")), tr) # predict again
  predicted.tr[,iter] <- get(paste("pr.tr.", i, sep="")) # use data from validate()
}
rm(list=c("i", "iter"))
colnames(predicted.tr) <- models
predicted.tr$classe <- tr$classe


## get cross validation prediction results
predicted.cv <- as.data.frame(matrix(nrow=dim(cv)[1], ncol=length(models)))
iter <- 0
for (i in models){
  iter <- iter + 1
  # predicted.cv[,iter] <- predict(get(paste("mod.", i, sep="")), cv) # predict again
  predicted.cv[,iter] <- get(paste("pr.cv.", i, sep="")) # use data from validate()
}
rm(list=c("i", "iter"))
colnames(predicted.cv) <- models
predicted.cv$classe <- cv$classe


## get testing prediction results
predicted.ts <- as.data.frame(matrix(nrow=dim(ts)[1], ncol=length(models)))
iter <- 0
for (i in models){
  iter <- iter + 1
  # predicted.ts[,iter] <- predict(get(paste("mod.", i, sep="")), ts) # predict again
  predicted.ts[,iter] <- get(paste("pr.ts.", i, sep="")) # use data from test()
}
rm(list=c("i", "iter"))
colnames(predicted.ts) <- models
predicted.ts$classe <- ts$classe


## run with chosen methods to ensemble models
ensemble <- function(colnums, methods){
  print(colnums)
  colnums <- c(colnums, dim(predicted.tr)[2]) # add classe
  tic()
  mod <- train(classe~., data=predicted.tr[,colnums], method=methods)
  tictoc <- toc()
  time <- tictoc$toc - tictoc$tic
  pr.tr <- predict(mod, predicted.tr[,colnums])
  pr.cv <- predict(mod, predicted.cv[,colnums])
  pr.ts <- predict(mod, predicted.ts[,colnums])
  cm <- confusionMatrix(pr.ts, predicted.ts$classe)
  assign(paste("tr.accu.ensemble.", methods, sep=""), 
         sum(pr.tr==predicted.tr$classe)/length(pr.tr), envir=globalenv())
  assign(paste("cv.accu.ensemble.", methods, sep=""), 
         sum(pr.cv==predicted.cv$classe)/length(pr.cv), envir=globalenv())
  assign(paste("result.ensemble.", methods, sep=""), cm, envir=globalenv())
  assign(paste("ts.accu.ensemble.", methods, sep=""), 
         cm$overall[1], envir=globalenv())
  assign(paste("time.ensemble.", methods, sep=""), time, envir=globalenv())
}

## convert predicted results into numeric values
predicted.tr <- as.data.frame(sapply(predicted.tr, as.numeric))
predicted.cv <- as.data.frame(sapply(predicted.cv, as.numeric))
predicted.ts <- as.data.frame(sapply(predicted.ts, as.numeric))
predicted.tr$classe <- tr$classe
predicted.cv$classe <- cv$classe
predicted.ts$classe <- ts$classe

## Check correlation 
correlations <- cor(predicted.cv[,c(2,3,10,11,12)])

## run ensemble using multinomial regression
list.ensemble <- c("gam", "multinom")
for(i in list.ensemble){
  ensemble(c(2,3,10,11,12), i)
}


## ensemble table
ensemble.tr.accuracy <- c(tr.accu.ensemble.gam, tr.accu.ensemble.multinom)
ensemble.cv.accuracy <- c(cv.accu.ensemble.gam, cv.accu.ensemble.multinom)
ensemble.elapsed.time <- c(sum(elapsed.time[c(2,3,10,11,12)], time.ensemble.gam), 
                           sum(elapsed.time[c(2,3,10,11,12)], time.ensemble.multinom))

t2 <- as.table(rbind(round(ensemble.tr.accuracy,3), round(ensemble.cv.accuracy,3)
                     , round(ensemble.elapsed.time,3)))



# apply the model to the testing data and predict classes        
data.testing <- read.csv(testFile, na.strings=c("NA","","#DIV/0!"))        
data.testing <- data.testing[,-nacols]
data.testing <- predict(standardize.data, data.testing)

testing <- predict(pca.data, data.testing[,-53])
pr.testing.treebag <- predict(mod.treebag, testing)
pr.testing.rf <- predict(mod.rf, testing)
pr.testing.qda <- predict(mod.qda, testing)
pr.testing.svmRadial <- predict(mod.svmRadial, testing)



# plot model training, cv results
png("barplot1.png", width=900, height=450)
bar.df <- t(as.matrix(results[, 2:3]))
par(mar=c(5.1, 4.1, 4.1, 5.1), xpd=TRUE)
bp <- barplot(bar.df, beside=TRUE, border="white", cex.names = 0.9, main = "Accuracy Chart")
## Add text at top of bars
NAs <- rep(NA, 12)
labels <- vector() 
labels1 <- vector() 
labels2 <- vector() 
for(i in 1:length(models)){
        labels <- c(labels, bar.df[,i])
        labels1 <- c(labels1, bar.df[1,i], NAs[i])
        labels2 <- c(labels2, NAs[i], bar.df[2,i])}

text(x = bp, y = labels+0.015, label = round(labels1,3), pos = 1, cex = 0.8, col = "black")
text(x = bp, y = labels-0.015, label = round(labels2,3), pos = 1, cex = 0.8, col = "black")

legend("right", inset=c(-0.08,0), c("Training", "CV"), fill=c("grey30", "grey90"), bty="n", cex=0.9)
dev.off()




# final plot
png("barplot2.png", width=900, height=450)
bar.final <- t(as.matrix(c(cv.accuracy[c(2, 5, 7, 9, 10, 11)], ensemble.cv.accuracy)))
colnames(bar.final) <- c(models[c(2, 5, 7, 9, 10, 11)], "ens.gam", "ens.multinom")
rownames(bar.final) <- "Cross Validation Accuracy"
par(mar=c(5.1, 4.1, 4.1, 5.1), xpd=TRUE)
bpf <- barplot(bar.final, border="white", cex.names = 0.9, main = "Final Accuracy Chart", 
        col=c("cadetblue"), space=1, ylim=c(0,1))
## Add text at top of bars
text(x = bpf, y = bar.final[1,], label = round(bar.final[1,],3), pos = 1, cex = 0.8, col = "black")
dev.off()
