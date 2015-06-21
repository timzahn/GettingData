library(data.table)
setwd("C:\\Users\\alw64gf\\Documents\\R\\Getting and Cleaning Data\\Week 3\\Project\\data")

#***Tasks: # You should create one R script called run_analysis.R that does the following.
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.



#****Step 1:

#***Read the feature list and activity labels
features <- read.table("features.txt", header=FALSE)
activity_labels <- read.table("activity_labels.txt", header=FALSE)

#Rename the columns
colnames(features) <- c("feature_number","feature")
colnames(activity_labels) <- c("activity_number", "activity")


#***Read the test data
subject_test <- read.table(".\\test\\subject_test.txt",header=FALSE)
X_test <- read.table(".\\test\\X_test.txt",header=FALSE)
y_test <- read.table(".\\test\\y_test.txt",header=FALSE)


#rename columns of the test datasets
colnames(subject_test) <-"subject_number"
colnames(y_test) <- "activity_number"
colnames(X_test) <- features$feature # we take the features we already read as the column names

#***Combine the test data
test_data <- cbind(subject_test,y_test,X_test)


#***Read the training data
subject_train <- read.table(".\\train\\subject_train.txt",header=FALSE)
X_train <- read.table(".\\train\\X_train.txt",header=FALSE)
y_train <- read.table(".\\train\\y_train.txt",header=FALSE)

#rename columns of the training datasets
colnames(subject_train) <-"subject_number"
colnames(y_train) <- "activity_number"
colnames(X_train) <- features$feature # we take the features we already read as the column names


#***Combine the test data
train_data <- cbind(subject_train,y_train, X_train)


#***Combine the test data with the training data
complete_data <- rbind(test_data,train_data) 

#>>>Step 1 completed<<<

#Step 2: Extract only the measurements on the mean and standard deviation for each measurement
#First I look for the columns that contain either std or mean
std_cols <- grep("std", names(complete_data), value=TRUE)
mean_cols <- grep("mean", names(complete_data), value=TRUE)

#Now I create a vector with all the Columns that I want to keep from the dataset
#including subject_number and activity_number
columns_to_keep <- c( c("subject_number","activity_number"), std_cols, mean_cols)

#Now I filter for these columns and save it to the data frame filtered_data
filtered_data <- complete_data[,columns_to_keep]

#>>>Step 2 completed<<<

#****Step 3: Use descriptive activity names to name the activities in the data set
# Here I will label the column activity_number with the corresponding activity names
# Therefore I use the data from the file activity_labels
filtered_data$activity_number <- factor(filtered_data$activity_number, levels = activity_labels$activity_number, labels = lapply(activity_labels$activity, as.character)) 

#>>>Step 3 completed<<<

#****Step 4: Appropriatel labels the data set with descriptive variable names.
# I already used the variable names from the provided files. I think one cannot do better than that
#>>>Step 4 completed<<<

#****Step 5: From the data set in step 4, create a second, independent tidy data set with the average of each 
#variable for each activity and each subject
#I do that with the reshape2 package:
library(reshape2)

#I use the combination from subject_number and activity_number as row ID
melt_dataset <- melt(filtered_data, id=c("subject_number","activity_number"))
final_dataset<-reshape2::acast(melt_dataset,subject_number+activity_number~...,mean)

#write the result to a file
write.table(final_dataset, "test.txt")



