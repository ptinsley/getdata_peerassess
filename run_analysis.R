#Global variables
dataDownloadURL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
zipfileName <- 'getdata-projectfiles-UCI HAR Dataset.zip'
zipfileTarget <- 'UCI HAR Dataset'

#make sure we have our dataset
if(!file.exists(zipfileName)) {
  download.file(dataDownloadURL, destfile=zipfileName, method = 'curl')
}

#make sure our dataset is extracted
if(!file.exists(zipfileTarget)) {
  unzip(zipfileName)
}

#load data files if not already loaded (they are big, want to avoid loading on every run)
if(!exists('trainingData') || exists("reload")) {
  trainingData <- read.table(sprintf("%s/train/%s", zipfileTarget, "X_train.txt"), header = FALSE)
}
if(!exists('trainingActivityData') || exists("reload")) {
  trainingActivityData <- read.table(sprintf("%s/train/%s", zipfileTarget, "Y_train.txt"), header = FALSE)
  trainingData[ncol(trainingData)+1] <- trainingActivityData
}
if(!exists('trainingSubjectData') || exists("reload")) {
  trainingSubjectData <- read.table(sprintf("%s/train/%s", zipfileTarget, "subject_train.txt"), header = FALSE)
  trainingData[ncol(trainingData)+1] <- trainingSubjectData
}
if(!exists('testData') || exists("reload")) {
  testData <- read.table(sprintf("%s/test/%s", zipfileTarget, "X_test.txt"), header = FALSE)
}
if(!exists('testActivityData') || exists("reload")) {
  testActivityData <- read.table(sprintf("%s/test/%s", zipfileTarget, "Y_test.txt"), header = FALSE)
  testData[ncol(testData)+1] <- testActivityData
}
if(!exists('testSubjectData') || exists("reload")) {
  testSubjectData <- read.table(sprintf("%s/test/%s", zipfileTarget, "subject_test.txt"), header = FALSE)
  testData[ncol(testData)+1] <- testSubjectData
}
if(!exists('featureNames') || exists("reload")) {
  featureNames <- read.table(sprintf("%s/%s", zipfileTarget, "features.txt"), header = FALSE)
  featureNames <- rbind(featureNames, data.frame(V1 = nrow(featureNames)+1, V2 = 'activity'))
  featureNames <- rbind(featureNames, data.frame(V1 = nrow(featureNames)+1, V2 = 'subject'))
}


if(exists("reload")) {
  rm(reload)
}

#1. - Merges the training and the test sets to create one data set.
mergedData <- rbind(testData, trainingData)

#4. - Appropriately labels the data set with descriptive activity names.
featureNamesClean <- featureNames
featureNamesClean$V2 <- tolower(featureNamesClean$V2)
featureNamesClean$V2 <- gsub('\\(','',featureNamesClean$V2)
featureNamesClean$V2 <- gsub('\\)','',featureNamesClean$V2)
names(mergedData) <- featureNamesClean$V2

#3. - Uses descriptive activity names to name the activities in the data set
#I wanted to do this programatically but could not figure out how in a loop to get this done, works by hand, not in a loop..
#substitute the indexes with descriptive names
mergedData[mergedData$activity == 1, 'activity'] <- 'Walking'
mergedData[mergedData$activity == 2, 'activity'] <- 'Walking Upstairs'
mergedData[mergedData$activity == 3, 'activity'] <- 'Walking Downstairs'
mergedData[mergedData$activity == 4, 'activity'] <- 'Sitting'
mergedData[mergedData$activity == 5, 'activity'] <- 'Standing'
mergedData[mergedData$activity == 6, 'activity'] <- 'Laying'

#2. - Extracts only the measurements on the mean and standard deviation for each measurement.
#use original featureNames so we can easily key off of mean() std()
mergedData <- subset(mergedData, select = grep("mean\\(\\)|std\\(\\)|activity|subject", featureNames$V2))

#5. - Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
for(subject in unique(mergedData$subject)) {
  print(subject)
  print(ave(mergedData[mergedData$subject == subject,1:(ncol(mergedData)-2)]))
}
