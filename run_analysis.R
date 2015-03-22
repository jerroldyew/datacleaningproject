library("plyr")
library("dplyr")

# Step 1: Merges the training and the test sets to create one data set
trainData <- read.table("./data/train/X_train.txt")
trainLabel <- read.table("./data/train/y_train.txt")
trainSubject <- read.table("./data/train/subject_train.txt")

testData <- read.table("./data/test/X_test.txt")
testLabel <- read.table("./data/test/y_test.txt") 
testSubject <- read.table("./data/test/subject_test.txt")

joinData <- rbind(trainData, testData)
joinLabel <- rbind(trainLabel, testLabel)
joinSubject <- rbind(trainSubject, testSubject)

# Step 2 : Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("./data/features.txt")
meanStdIndices <- grep("mean\\(\\)|std\\(\\)", features[, 2]) # Extract column headers with "mean()" or "std()" 
joinData <- joinData[,meanStdIndices] #Subsetting columns from joinData to give new joinData

# Step 3: Uses descriptive activity names to name the activities in the data set
activity <- read.table("./data/activity_labels.txt")
activity[, 2] <- tolower(gsub("_", "", activity[, 2])) # Reformat to remove "_" and changing to lower caps

substr(activity[2, 2], 8, 8) <- toupper(substr(activity[2, 2], 8, 8)) # Reformat to "walkingdownstairs" to "walkingDownstairs"
substr(activity[3, 2], 8, 8) <- toupper(substr(activity[3, 2], 8, 8)) # Reformat to "walkingupstairs" to "walkingUpstairs"
joinLabel[,1] <- join(joinLabel,activity)[,2] # Joining both label & activity to give descriptive activity name

# Step 4: Appropriately labels the data set with descriptive variable names. 
names(joinLabel) <- "activity"
names(joinSubject) <- "subject"
names(joinData) <- gsub("\\(\\)", "", features[meanStdIndices, 2]) # remove "()"
names(joinData) <- gsub("mean", "Mean", names(joinData)) # capitalize M
names(joinData) <- gsub("std", "Std", names(joinData)) # capitalize S
names(joinData) <- gsub("-", "", names(joinData)) # remove "-" in column names 

cleanedData <- cbind(joinSubject, joinLabel, joinData)
write.table(cleanedData, "clean_data_frm_Step4.txt")

# Step 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
dataCol <- names(cleanedData)[3:68] # Selecting the cols for averaging
res <- ddply(cleanedData,.(subject,activity),function(x) colMeans(x[dataCol])) # Using ddply from dplyr to group by subject & activity, and apply colmean
write.table(res, file="result_frm_Step5.txt", row.names=FALSE)