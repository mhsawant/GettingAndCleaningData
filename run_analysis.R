##Here are the data for the project:
  
##  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

##You should create one R script called run_analysis.R that does the following.

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average
##     of each variable for each activity and each subject.




## load the pacakage
library(tidyr)
library(dplyr)
library(data.table)

myfile <- "./UCI HAR Dataset"
 
## read subject file

SubjectTestdata <- tbl_df(read.table(file.path(myfile, "test", "subject_test.txt")))
SubjectTraindata <- tbl_df(read.table(file.path(myfile, "train", "subject_train.txt")))

## read activity file
   
ActivityTestdata <- tbl_df(read.table(file.path(myfile, "test", "y_test.txt")))
ActivityTraindata <- tbl_df(read.table(file.path(myfile, "train", "y_train.txt")))
 
## read data file
  
Testdata <- tbl_df(read.table(file.path(myfile, "test", "X_test.txt")))
Traindata <- tbl_df(read.table(file.path(myfile, "train", "X_train.txt")))

## merging the training and test tables using rbind
  
allSubjectdata<- rbind(SubjectTestdata,SubjectTraindata)
allActivitydata<- rbind(ActivityTestdata,ActivityTraindata)
alldata <- rbind(Testdata, Traindata)
 
## rename variable 'subject' and 'activity'
 
setnames(allSubjectdata, "V1", "subject")
setnames(allActivitydata, "V1", "activity")

#read feature file
featuredata <- tbl_df(read.table(file.path(myfile, "features.txt")))
 
# renaming variables as "featuresNum", "featuresName"
setnames(featuredata, names(featuredata), c("featureNum", "featureName"))
colnames(alldata) <- featuredata$featureName

#read activitylable and give column names
activityLabels<- tbl_df(read.table(file.path(myfile, "activity_labels.txt")))
setnames(activityLabels, names(activityLabels), c("activityNum", "activityName"))
 
# Add activity names to activity data
activityNumberToName <- function(n) {activityLabels[activityLabels$activityNum==n,]$activityName}
allActivitydata <- cbind(allActivitydata, sapply(allActivitydata$activity, activityNumberToName))
names(allActivitydata) <- c("activity", "activityName")

## extract mean and SD columns from featuresdata
alldata <- alldata[,grep("-(mean|std)\\(\\)", names(alldata), value = T)]

## Merge all columns

alldata <- cbind(allSubjectdata, allActivitydata, alldata)

#create summarytable with means  by subject and Activity

summarytable <-aggregate(alldata[,grep("\\(\\)", names(alldata))], by=list(alldata$activityName, alldata$subject), FUN = mean)

#Appropriately labels the data set with descriptive variable names.
names(summarytable)<-sub("Group.1", "activity", names(summarytable))
names(summarytable)<-sub("Group.2", "subject", names(summarytable))
names(summarytable)<-gsub("std()", "SD", names(summarytable))
names(summarytable)<-gsub("mean()", "MEAN", names(summarytable))
names(summarytable)<-gsub("^t", "time", names(summarytable))
names(summarytable)<-gsub("^f", "frequency", names(summarytable))
names(summarytable)<-gsub("Acc", "Accelerometer", names(summarytable))
names(summarytable)<-gsub("Gyro", "Gyroscope", names(summarytable))
names(summarytable)<-gsub("Mag", "Magnitude", names(summarytable))
names(summarytable)<-gsub("BodyBody", "Body", names(summarytable))

#write data to the textfile

write.table(summarytable, "TidyData.txt", row.name=FALSE)

         
