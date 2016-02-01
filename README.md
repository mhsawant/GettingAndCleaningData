 GettingAndCleaningData
Getting and Cleaning Data Course week 4 Assignment

 The data for the project:
  
  https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
  
Download the file and unzip it.

load the following pacakage

library(tidyr)
library(dplyr)
library(data.table)

source("run_analysis.R") aftering running this "Tidydata.txt" will be created. 

The tidy data set is a set of variables for each activity and each subject.
 10299 rows are split into 180 groups (30 subjects and 6 activities) and 
 66 mean and standard deviation features are averaged for each group. 
 The resulting data table has 180 rows and 69 columns, 33 Mean variables, 33 Standard deviation variables
and header containing the names for each column.