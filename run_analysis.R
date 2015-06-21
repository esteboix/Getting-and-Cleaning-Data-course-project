
# Optional: sets the working directory, installs dplyr
# setwd("your_directory")
# install.packages("dplyr")

library(dplyr)

# --------------------
# 1. READ AND MERGE THE TRAINING AND THE TEST SETS TO CREATE ONE DATASET
# --------------------

# First, we read the variable names from the dataset
variables = read.table("UCI HAR Dataset/features.txt", col.names=c("Variable id", "Variables"))

# Then we read the train and test data, adding a column in the subject data
# that specifies the set of the data (train or test)
trainX = read.table("UCI HAR Dataset/train/X_train.txt", col.names=variables$Variables)
trainY = read.table("UCI HAR Dataset/train/y_train.txt", col.names="Activity id")
trainSubject = read.table("UCI HAR Dataset/train/subject_train.txt", col.names="Subject id")
trainSubject$set <- "train"

testX = read.table("UCI HAR Dataset/test/X_test.txt", col.names=variables$Variables)
testY = read.table("UCI HAR Dataset/test/y_test.txt", col.names="Activity id")
testSubject = read.table("UCI HAR Dataset/test/subject_test.txt", col.names="Subject id")
testSubject$set <- "test"

# To end this part, we join together the train and test data, and finally we join the two sets
trainData <- cbind(trainSubject, trainY, trainX)
testData <- cbind(testSubject, testY, testX)
Data <- rbind(trainData, testData)

# --------------------
# 2. EXTRACT ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT
# --------------------

# Now we select the data based on partial matches on the column names
selectedData <- Data %>%
                select(1:3,
                       contains("std", ignore.case = TRUE),
                       contains("mean", ignore.case = TRUE),
                       -contains("freq", ignore.case = TRUE),
                       -contains("angle", ignore.case = TRUE))

# --------------------
# 3. USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
# --------------------

# We read the file with the activity names and merge it with the main data using the activity id 
activityNames <- read.table("UCI HAR Dataset/activity_labels.txt", col.names=c("Activity id", "Activity"))
selectedData <- merge(selectedData,activityNames,by="Activity.id")

# --------------------
# 4. APPROPRIATELY LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES
# --------------------

# The variables already have descriptive names, but we can use this step to make them a little bit prettier,
# we get rid of all the dots and substitute them with a single underscore
names(selectedData) <- gsub("\\.", "_", names(selectedData))
names(selectedData) <- gsub("__", "", names(selectedData))

# --------------------
# 5. CREATE A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
# --------------------

# Now create the group the data by activity and subject, and calculate the mean of all the variables
groupedData <- selectedData %>%
               group_by(Activity, Subject_id) %>%
               summarise_each(funs(mean), 4:69)

# And finally, it's time to write the file with the final data set.
write.table(groupedData, "tidy.txt", row.name = FALSE)

