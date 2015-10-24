# Getting and Cleaning Data Project

# Source Data
The data is described in detail here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The data used can be found here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


# Description
The run_analysis.R script does the following:

    (1) Merges the training and the test sets to create one data set.
    (2) Extracts only the measurements on the mean and standard deviation for each measurement. 
    (3) Uses descriptive activity names to name the activities in the data set
    (4) Appropriately labels the data set with descriptive variable names. 
    (5) From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

# Variables

The variables "xTest" and "xTrain" represent the labels for the types of features that were recorded by the accelerometers on the Samsung Galaxy S.
The variables "subjectTest" and "subjectTrain" represent the IDs of the people who were wearing the accelerometers on their waists.
The variables "yTest" and "yTrain" represent the measurements collected from the activities conducted by each subject, for each feature that was examined. There were six activities that were performed by each of the subjects. The activities were:
* Walking
* Walking upstairs
* Walking downstairs
* Sitting
* Standing
* Laying

# Section 1: Merges the training and the test sets to create one data set.

Using the rbind function, the script merges test and train datasets across features, people/subjects (personIDs), and activities
Then, using the cbind function, the script combines datasets into one, merged dataset.

# Section 2: Extracts only the measurements on the mean and standard deviation for each measurement. 

Using the Grep function, the script pulls out only mean/std headings, and then applies them to merged dataset using "select=" in subset function


# Section 3: Uses descriptive activity names to name the activities in the data set
Using the activity_labels.txt file, the script converts the numbers listed in the merged data set to the names of the activities.


# Section 4: Appropriately labels the data set with descriptive variable names. 
Using the gsub function, the names of the fields contained in the merged dataset are renamed with descriptive variable names.

# Section 5: From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
Using the plyr package, we use the aggregate function to aggregate and display the mean values of each column, grouped by personID and activity. 
All of this new data is stored in a new table called "summaryData" which is ordered first by personID, and then by activity. 
Then the new able is written into a new file called "summarydata.txt".

