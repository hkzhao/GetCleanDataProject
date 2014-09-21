## 1. Merges the training and the test sets to create one data set.

## data file locations
featureFile <- "UCI HAR Dataset/features.txt"
activityLabelFile <- "UCI HAR Dataset/activity_labels.txt"

trainXFile <- "UCI HAR Dataset/train/X_train.txt"
trainYFile <- "UCI HAR Dataset/train/Y_train.txt"
trainSubjectFile <- "UCI HAR Dataset/train/subject_train.txt"

testXFile <- "UCI HAR Dataset/test/X_test.txt"
testYFile <- "UCI HAR Dataset/test/Y_test.txt"
testSubjectFile <- "UCI HAR Dataset/test/subject_test.txt"

## load feature (X column) names
features <- read.table(featureFile)
colNames <- features[, 2]

## read training data

# read X training data
trainX <- read.table(trainXFile)
colnames(trainX) <- colNames

# read X training data
trainY <- read.table(trainYFile)
colnames(trainY) <- c("act_id")

# read subject data
trainSubject <- read.table(trainSubjectFile)
colnames(trainSubject) <- c("subject")

# combine all training data
trainAll <- cbind(trainX, trainY, trainSubject)

## read test data

# read X test data
testX <- read.table(testXFile)
colnames(testX) <- colNames

# read Y test data
testY <- read.table(testYFile)
colnames(testY) <- c("act_id")

# read subject test data
testSubject <- read.table(testSubjectFile)
colnames(testSubject) <- c("subject")

# combine all test data
testAll <- cbind(testX, testY, testSubject)

## combine both training and test data
totalSet <- rbind(trainAll, testAll)

##################
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# find the column names that contains "mean" and "std", plus "act_id" and "subject"
meanStdCol <- grepl("mean\\x28|std", colNames)
meanStdCol <- c(meanStdCol, c(TRUE, TRUE))

# select only the qualified columns
meanStdData <- totalSet[, meanStdCol]

###################
## 3. Uses descriptive activity names to name the activities in the data set

activityLabels <- read.table(activityLabelFile)
colnames(activityLabels) <- c("act_id", "activity")

#add a no column for later restoring the ordering
meanStdData$no <- 1:nrow(meanStdData)
# join to append activity names
meanStdData <- merge(x=meanStdData, y=activityLabels, by.x="act_id", by.y="act_id")
# restore the order
meanStdData <- meanStdData[with(meanStdData, order(no)), ]
# remove extra columns "no" and "act_id"
meanStdData <- meanStdData[,!(names(meanStdData) %in% c("act_id", "no"))]

####################
## 4. Appropriately labels the data set with descriptive variable names. 

# extract column names
msdColNames <- names(meanStdData)
# initialize new column names
newColNames = rep("n",length(msdColNames));

# create new column names one by one
for (i in 1 : length(msdColNames)) {
	# do not change "subject" and "activity"
	if ((msdColNames[i] == "activity") || (msdColNames[i] == "subject")) {
		newColNames[i] <- msdColNames[i]
		next
	}
	
	# tokenize original column name
	splited <- strsplit(gsub("\\)","",gsub("\\(","",msdColNames[i])), "-")
	
	# create first part of the new column name
	A <- "of"
	if (splited[[1]][2] == "mean") {
		A <- paste("Mean", A)
	} 
	else if (splited[[1]][2] == "std") {
		A <- paste("Standard Deviation", A)
	} 
	
	# create second part of the new column name
	B <- splited[[1]][3]
	
	# create third part of the new column name
	C <- splited[[1]][1]
	if (substr(C, 1, 1) == "t") {
		C <- paste("Time Domain", substr(C, 2, nchar(C)))
	}
	else if (substr(C, 1, 1) == "f") {
		C <- paste("Frequency Domain", substr(C, 2, nchar(C)))
	}
	
	# combine the three parts together
	if (is.na(B)) {
		newColNames[i] <- paste(A, C)
	}
	else {
		newColNames[i] <- paste(A, B, C)
	}
}

## assign new names to data frame
colnames(meanStdData) <- newColNames

################################################
## 5. From the data set in step 4, creates a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

dataSet2 <- aggregate(. ~ activity+subject, data=meanStdData, FUN=mean)

write.table(dataSet2, file="tidyDataSet2.txt", sep=",", row.names = FALSE, col.names = TRUE)



