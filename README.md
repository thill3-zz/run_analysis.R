# run_analysis.R
Coursera Project - Geting and Cleaning Data - Final Project

Background

  The entirety of the data is stored in a downloaded zip file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.
  Once this file is manually unzipped we find the other necessary files
    X-train.txt - the data used to train the model (if we wanted a regression)
    y_train.txt - the column labels for the training data
    X_test.txt - the data used to test the model (if we were doing a regression and error analysis)
    y_test.txt - the labels for the test data
    features.txt - the column names for the X_train and X_test datasets
    activity_labels.txt - a translation from the activity codes (1 through 6) to text values
    subject_test.txt - The subjects who performed the task in each row of the test data
    subject_train.txt - the subjects who performed the task in each row of the training data.
    
Project tasks

  1) Merge the training and the test sets to create one data set.
  2) Extract only the measurements on the mean and standard deviation for each measurement.
  3) Use descriptive activity names to name the activities in the data set
  4) Appropriately labels the data set with descriptive variable names.
  5 )From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
  
Overview

  The original data is contained in a .zip file that must first be unzipped.
  Then the script can load the individual data tables into R memory using the read.table command
  The files, column labels, subject numbers, and activity codes are all combined into one large file by using cbind (column bind) and rbind (row bind) commands
  We can limit processing needs by reducing the size of the dataset. We consider only the columns including the terms "mean" and "std" (standard deviation).
  At the same time we remove columns with duplicate variable names for two reasons - 1) they interfere with the later analysis, and 2) they are not labelled as "mean" or "std" variables.
  The group_by() command allows us to group the data according to Activity (what the person is doing) and Subject (who the person is).
  Once the data is grouped the summarise_all(data,mean) command generates the mean of each set of values for each set of Activity/Subject pairs.
