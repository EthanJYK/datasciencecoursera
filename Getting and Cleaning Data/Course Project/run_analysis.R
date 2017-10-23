####### Coursera-JHU Data Science Specialization: Getting and Cleaning Data Course Project #######

#---------------------------------------- Overall Goals ---------------------------------------- #
#                                                                                                #
# 1. Download human activity recognition data and merge into one data set.                       #
#                                                                                                #
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.     #
#                                                                                                #
# 3. Use descriptive activity names to name the activities in the data set.                      #
#                                                                                                #
# 4. Label the data set with descriptive variable names appropriately                            #
#                                                                                                #
# 5. Create a tidy data set with average of each variable for each activity and subject.         #
#                                                                                                #
#------------------------------------------------------------------------------------------------#


library(plyr)


#------------------------------------------------------------------------------------------------#
# 1. Download Data from the web

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileName <- "HARdata.zip"
folder <- "UCI HAR Dataset"
if(!file.exists(folder)) {
        download.file(fileURL, fileName)
        unzip(fileName)
}
#------------------------------------------------------------------------------------------------#


#------------------------------------------------------------------------------------------------#
# 2. Load Data
subFolder <- c("train", "test")
for (i in subFolder){
        assign(paste("sub_", i, sep=""), read.table(file.path(folder, i, paste("subject_", i, ".txt", sep=""))))
        assign(paste("act_", i, sep=""), read.table(file.path(folder, i, paste("y_", i, ".txt", sep=""))))
        assign(paste("data_", i, sep=""), read.table(file.path(folder, i, paste("X_", i, ".txt", sep=""))))
}
act_labels <- as.vector(read.table(file.path(folder, "activity_labels.txt"))[,2]) 
#------------------------------------------------------------------------------------------------#


#------------------------------------------------------------------------------------------------#
# 3. Merge and Label Data

## create a variable for train/test group notation. train:0 / test:1
group <- rep(c(0,1), c(nrow(sub_train), nrow(sub_test))) 

## merge 
data <- cbind(group, rbind(sub_train, sub_test), rbind(act_train, act_test), rbind(data_train, data_test)) 

## rename columns
colnames(data) <- c("Group", "Subject", "Activity", as.vector(read.table(file.path(folder, "features.txt"))[,2]))

## replace activity values with activity names
for(i in 1:6){data[,3] <- gsub(i, act_labels[i], data[,3])}

## remove sources
rm("act_train", "act_test", "data_train", "data_test", "sub_train", "sub_test", "group", "act_labels")
#------------------------------------------------------------------------------------------------#


#------------------------------------------------------------------------------------------------#
# 4. Make a tiny data set with average values of each subject and each variable

## leave mean and std.dev only
data <- data[,grep("Group|Subject|Activity|mean\\(\\)|std\\(\\)", colnames(data))]

## rename variables to make more descriptive
variables <- colnames(data)
former <- c("^t", "f", "BodyBody", "Acc", "Gyro", "Jerk", "-", "Mag", "\\(\\)")
fixed <- c("Times.", "Frequency.", "Body", ".Accel", ".Gyro", ".Jerk", ".", ".Magnitude", "")
for(j in 1:9){variables <- gsub(former[j], fixed[j], variables)}
colnames(data) <- variables

## make a tiny data
tiny_data <- ddply(data, .(Group, Subject, Activity), function(x) colMeans(data[,4:ncol(data)]))

## save tiny data as "tiny_data.txt"
write.table(tiny_data, "tiny_data.txt", row.names = FALSE)
#------------------------------------------------------------------------------------------------#


        

        


