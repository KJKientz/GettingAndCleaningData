# Description

# This R script does the following:
#    (1) Merges the training and the test sets to create one data set.
#    (2) Extracts only the measurements on the mean and standard deviation for each measurement. 
#    (3) Uses descriptive activity names to name the activities in the data set
#    (4) Appropriately labels the data set with descriptive variable names. 
#    (5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.



##    (1) Merges the training and the test sets to create one data set. Using the UCI HAR Dataset:


setwd("C:/Users/Kevin/Desktop/Data Scientists Toolbox/Getting and Cleaning Data/Course Project/UCI HAR Dataset")

# Use data.table and plyr packages
library(data.table)
library(plyr)


# Read x_test and x_train datasets (features) into data frames

xTest <- read.table("./test/X_test.txt")
xTrain <- read.table("./train/X_train.txt")


# Read subject_test and subject_test datasets (people IDs) into data frames

subjectTest <- read.table("./test/subject_test.txt")
subjectTrain <- read.table("./train/subject_train.txt")


# Read y_test and y_train datasets (activities) into data frames

yTest <- read.table("./test/y_test.txt")
yTrain <- read.table("./train/y_train.txt")


# Use the rbind function to merge test and train datasets across features, people/subjects (personIDs), and activities

features <- rbind(xTest, xTrain)
people <- rbind(subjectTest, subjectTrain)
activities <- rbind(yTest, yTrain)


# set names for these data frames

featuresHeadingsFile <- fread("./features.txt")
featuresHeadings <- featuresHeadingsFile$V2

names(features) <- featuresHeadings
names(people) <- "personID"
names(activities) <- "activity"


# Combine datasets [use cbind because there are the same # of rows in each of three datasets. We're just adding columns.

mergedData <- cbind(features, people, activities)


##    (2) Extracts only the measurements on the mean and standard deviation for each measurement. 
# use Grep function to pull out only Mean/mean/std headings, and then apply them to merged dataset using "select=" in subset function

selectedFeaturesNames <- featuresHeadings[grep("[Mm]ean\\(\\)|std", featuresHeadings)]
selectedFeaturesNames <- c(selectedFeaturesNames, "personID", "activity")
mergedData <- subset(mergedData, select=selectedFeaturesNames)


##    (3) Uses descriptive activity names to name the activities in the data set
# convert activity #s to activity labels in mergedData dataset

activityLabels <- read.table("./activity_labels.txt")
names(activityLabels) <- c("V1","activity")

# identify each factor (grouping) of activities from the "activity" column in the mergedData dataset 
activityFactors <- factor(mergedData$activity, labels=activityLabels$activity)

# in the "activity" column, convert the factor #s to the factor labels.
mergedData$activity <- activityFactors



##    (4) Appropriately labels the data set with descriptive variable names. 
# Tidy up the column names w/descriptive names

names(mergedData) <- gsub("^t", "TIME-", names(mergedData))
names(mergedData) <- gsub("^f", "FREQUENCY-", names(mergedData))
names(mergedData) <- gsub("Acc", "Accelerometer", names(mergedData))
names(mergedData) <- gsub("Gyro", "Gyroscope", names(mergedData))
names(mergedData) <- gsub("Mag", "Magnitude", names(mergedData))
names(mergedData) <- gsub("BodyBody", "Body", names(mergedData))




##    (5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

# using the plyr package, we use the aggregate function to aggregate and display the mean values of each column, grouped by personID and activity. All of this new data is stored in a new table called "summaryData" which is ordered first by personID, and then by activity. Then the new able is written into a new file called "summarydata.txt".
summaryData <- aggregate(. ~personID + activity, mergedData, mean)
summaryData <- summaryData[order(summaryData$personID, summaryData$activity), ]
write.table(summaryData, file = "summarydata.txt", row.names=FALSE, sep='\t')