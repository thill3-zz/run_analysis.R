#You should create one R script called run_analysis.R that does the following.

# 1Merges the training and the test sets to create one data set.
#2 Extracts only the measurements on the mean and standard deviation for each 
#measurement.
#3 Uses descriptive activity names to name the activities in the data set
#4 Appropriately labels the data set with descriptive variable names.
#5 From the data set in step 4, creates a second, independent tidy data set with 
#the average of each variable for each activity and each subject.

#Step 0 - load data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("./SamsungGalaxy5.zip")) {
        print("Downloading file.")
        download.file(fileUrl, destfile = "./data/SamsungGalaxy5.zip")
} else {
        print("File already exists and will not be downloaded.")
}

sg5xtest <- read.table("./UCIHARDataset/test/X_test.txt"
                       , colClasses = "numeric")
sg5ytest <- read.table("./UCIHARDataset/test/y_test.txt"
                       , colClasses = "character")
sg5xtrain <- read.table("./UCIHARDataset/train/X_train.txt"
                        , colClasses = "numeric")
sg5ytrain <- read.table("./UCIHARDataset/train/y_train.txt"
                        , colClasses = "character")
sg5features <- read.table("./UCIHARDataset/features.txt"
                          , header = FALSE
                          , stringsAsFactors = FALSE)


#Step 1 - Now that the files are downloaded I can merge them
if(!exists(combined)) {
        combined <- rbind(sg5xtrain, sg5xtest)
        } 
        #row combine the test and train datasets
        #If I include the labels at the top then rbind coerces all the data to 
                #character. That causes problems, so I'll input the column 
                #labels later
dim(combined) #10299x561
#Now set the column names to be the appropriate ones.
colnames(combined) <- t(sg5features)[2,] #Have to use the second row because 
        #the first is just numbers
combined[1:5,1:4] #That looks right
typeof(combined[5,8]) #double, as it should be
dup <- duplicated(names(combined)) #If I don't remove duplicate column names 
        #now then there are problems later.
combined1 <- combined[,!dup]
dim(combined1) #now it's 10299 x 477 and there are no duplicate named columns

#Steps 3 & 4 - The fact that I'm doing this before steps 2 is simply a 
        #matter of convenience. The order makes no difference.
        #Once the data is combined I have to assign the appropriate labels. 
        #These are in the "y_" files

combinedLabels <- rbind(sg5ytrain, sg5ytest) #First rowbind the label sets so 
        #that they are the same number as columns in the dataset
dim(combinedLabels) #10299x1 as it should be
dataWithLabels <- cbind(combinedLabels, combined1)
dim(dataWithLabels) #10299x478 as it should be
sg5activityLabels <- read.table("./UCIHARDataset/activity_labels.txt"
                                , colClasses = "factor")
applyLabel <- function(input) {sg5activityLabels[input, 2]} #create a function 
        #to get the label text
dataWithLabels[,1] <- sapply(X=dataWithLabels[,1], FUN=applyLabel) #apply the
        #function and replace the labels.
colnames(dataWithLabels) <- c("Activity", names(combined1)) #Put a label on the
        #activity column
dim(dataWithLabels) #10299x478

#Step 2 - Extract only the columns with mean and std(standard deviation)
library(dplyr)
indices <- grep(".*mean|std.*",names(dataWithLabels)) #which columns are the 
        #mean and SD columns?
length(indices) #79
musAndSigmas <- select(dataWithLabels, c(1,indices)) #Have to include 1 there, 
        #because it's the labels column.
dim(musAndSigmas) #10299x80 - all the rows, only the activity, mean, and std columns

#Step 5
#We'll have to start by adding on the subject data to the df.
sg5SubjectTest <- read.table("./UCIHARDataset/test/subject_test.txt")
sg5SubjectTrain <- read.table("./UCIHARDataset/train/subject_train.txt")
combinedSubjects <- rbind(sg5SubjectTrain, sg5SubjectTest)
dim(combinedSubjects) #10299x1
musAndSigmasSubjects <- cbind(combinedSubjects, musAndSigmas)
dim(musAndSigmasSubjects) #10299x81
colnames(musAndSigmasSubjects) <- c("Subject", names(musAndSigmasSubjects)[-1])
dim(musAndSigmasSubjects) #10299x81
#Then we group the data
groupedData <- group_by(musAndSigmasSubjects, Activity, Subject)
#And summarise it.
summarisedData <- summarise_all(groupedData, mean)
summarisedData[175:184,1:3] #We can see that the data ends at 180 rows
        #from 30 participants x 6 activities
        #dim = 180x81

write.table(x = summarisedData
            , file = "./CourseraGetCleanWk4ProjectTidyData.txt"
            ,row.names = FALSE)
