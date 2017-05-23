library(dplyr)

#Download and unzip the dataset#

zipURL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipFILE<-"UCI HAR DATASET.zip"

if(!file.exists(zipFILE)) 

unzip(zipFILE)

#load activity labels and features#

activityLabels<-read.table("UCI HAR Dataset/activity_labels.txt")
activityLabels[,2]<-as.character(activityLabels[,2])
features<-read.table("UCI HAR Dataset/features.txt")
features[,2]<-as.character(features[,2])

#Extracts only the measurements on the mean and standard deviation for each measurement.

meanandstd_features<-grep(".*mean.*|.*std.*",features[,2])
meanandstd<-features[meanandstd_features,2]
meanandstd=gsub('-mean','-Mean',meanandstd)
meanandstd=gsub('-std','Std',meanandstd)
meanandstd<-gsub('[-()]','',meanandstd)

#load the datasets#
train<-read.table("UCI HAR Dataset/train/X_train.txt")[meanandstd_features]
train_activities<-read.table("UCI HAR Dataset/train/Y_train.txt")
train_subjects<-read.table("UCI HAR dataset/train/subject_train.txt")
train <- cbind(train_subjects, train_activities, train)
test<-read.table("UCI HAR Dataset/test/X_test.txt")[meanandstd_features]
test_activities <- read.table("UCI HAR Dataset/test/Y_test.txt")
test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(test_subjects, test_activities, test)

#Merge the training and the test sets to create one data set.#
allData <- rbind(train, test)
colnames(allData) <- c("subject", "activity", meanandstd)

#factors#
allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
allData$subject <- as.factor(allData$subject)

allData.melted <- melt(allData, id = c("subject", "activity"))
allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)

write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)
