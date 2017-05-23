library("data.table")
library("reshape2")

#download and unzip the data

zipurl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfile<- "UCI HAR Dataset.zip"

if (!file.exists(zipfile)) {
          download.file(zipurl, zipfile, mode = "wb")}

datapath <- "UCI HAR Dataset"
if (!file.exists(datapath)) {
          unzip(zipfile)}

#activities and features

activitylabels <- fread(file.path(datapath, "activity_labels.txt")
                        , col.names = c("classLabels", "activityName"))
features <- fread(file.path(datapath, "features.txt")
                  , col.names = c("index", "featureNames"))
featurestokeep <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featurestokeep, featureNames]
measurements <- gsub('[()]', '', measurements)
measurements

#test data

TestActivities  <- read.table(file.path(datapath, "test/Y_test.txt" ),header = FALSE)
TestSubject<-read.table(file.path(datapath, "test/subject_test.txt"),header = FALSE)
TestFeatures<-read.table(file.path(datapath, "test/X_test.txt" ),header = FALSE)

#test data

TrainActivities <- read.table(file.path(datapath, "train/Y_train.txt"),header = FALSE)
TrainSubject<-read.table(file.path(datapath, "train/subject_train.txt"),header = FALSE)
TrainFeatures<-read.table(file.path(datapath, "train/X_train.txt"),header = FALSE)


#bind data
SubjectData <- rbind(TrainSubject, TestSubject)
ActivityData<- rbind(TrainActivities, TestActivities)
FeaturesData<- rbind(TrainFeatures, TestFeatures)

#give names to variables
names(SubjectData)<-c("subject")
names(ActivityData)<- c("activity")
FeaturesNames <- read.table(file.path(datapath, "features.txt"),head=FALSE)
names(FeaturesData)<- FeaturesNames$V2

MergeData <- cbind(SubjectData, ActivityData)
FinalData<-cbind(FeaturesData,MergeData)
FinalData

#write data
write.table( FinalData, file = "tidy.csv", quote = FALSE)
