library(plyr)

#set working directory
setwd("~/Desktop/R_Programming/GettingProject")

# Step One
# Goal: Load and merge the training and test sets
x_train <- read.table("./X_train.txt")
y_train <- read.table("./y_train.txt")
subject_train <- read.table("./subject_train.txt")
x_test <- read.table("./X_test.txt")
y_test <- read.table("./y_test.txt")
subject_test <- read.table("./subject_test.txt")

# create all three joined data sets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# clean up unneeded data in environment
rm(x_train)
rm(x_test)
rm(y_train)
rm(y_test)
rm(subject_train)
rm(subject_test)

# Step Two
# Extract measurements on the mean and standard deviation
features <- read.table("features.txt")
mean_and_std_f <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, mean_and_std_f]
names(x_data) <- features[mean_and_std_f, 2]

# Step Three
# Use descriptive activity names to name the activities in the data set
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

# Step Four
# Appropriately label the data set with descriptive variable names
names(subject_data) <- "subject"
combined_data <- cbind(x_data, y_data, subject_data)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
averages_data <- ddply(combined_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

# Write this tidy data to local drive
write.table(averages_data, file = "./tidy_dataset.txt" ,row.name=FALSE)
