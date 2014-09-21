# README

This repository contains the files for Getting and Cleaning Data Course Project. Below is a list 
of files contains in this repository: 

1. run_analysis.R
	The R script that is used to process the raw data to get final tidy data.
	
2. CodeBook.md
	Contains the descriptions of the variables in final tidy data, the raw data source and the transformation steps for generating final tidy data.
	
3. README.md
	This README.md file.

## Transformations in run_analysis.R

### Step 1: Merges the training and the test sets to create one data set.
The data set contains two subsets: training data and testing data, each contains features (X), activities (Y) 
and subjects. According to the project requirements, We first combined the features, activities and subjects 
in each subset horizontally to create a big data frame for each subset. Then we combined the training data frame 
and test data frame vertically to create a total data frame.

### Step 2: Extracts only the measurements on the mean and standard deviation for each measurement
Since we are interested in only mean and standard deviation features (in Xs), we extracted only feature (X) columns 
with string "mean" and "std", plus "activity" and "subject". The result data frame is our tidy data frame 1.

### Step 3: Uses descriptive activity names to name the activities in the data set
We load the activity names from file activity_labels.txt. Then use merge() to join the activity strings to the 
tidy data frame 1. The original activity ids are then removed, as the activity descriptions have been added

### Step 4: Appropriately labels the data set with descriptive variable names.
We then tries to assign each feature column a better name. This is done by splitting each column names into three parts. 
Then we replace each part with a more descriptive strings. For example, original column name "tBodyAcc-mean()-X" gets
splitted into "tBodyAcc", "mean", "X". We know that "t" means time domain, "mean" is just mean, and "X" is the x axle. 
So The column name finally becomes "Mean of X Time Domain BodyAcc".

### Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
In this step, we aggregate all features (means and stds) in tidy data set 1 over "activity" and "subject" with function mean() (for averaging). 
Because there are 6 activities and 30 subjects, we end up with 180 rows in our final tidyDataSet2.txt.


	
