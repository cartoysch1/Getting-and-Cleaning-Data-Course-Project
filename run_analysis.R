
setwd("~/Desktop")

#Download data set
filename <- "data.zip"

fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
download.file(fileURL, filename, method="curl")
unzip(filename) 

##Read labels and features
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activitylabels[, 2] <- as.character(activitylabels[, 2])
activitylabels[, 2] <- gsub('_', ' ', activitylabels[, 2])

features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

##Get the mean and standard deviation
features2 <- grep(".*mean.*|.*std.*", features[ ,2])
features2n <- features[features2, 2]
features2n = gsub('-mean', 'Mean', features2n)
features2n = gsub('-std', 'Std', features2n)
features2n <- gsub('[-()]', '', features2n)

##Read the data
train <- read.table("UCI HAR Dataset/train/X_train.txt")[features2]
traina <- read.table("UCI HAR Dataset/train/Y_train.txt")
trains <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trains, traina, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[features2]
testa <- read.table("UCI HAR Dataset/test/Y_test.txt")
tests <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(tests, testa, test)

##Merge data
dat <- rbind(train, test)

##Add column and activity names
colnames(dat) <- c("Subject", "Activity", features2n)
dat$Activity <- factor(dat$Activity, levels = activitylabels[, 1], labels = activitylabels[, 2])
dat$Subject <- as.factor(dat$Subject)


##Create second data set
mdat <- melt(dat, id = c("Subject", "Activity"))
meandat <- dcast(mdat, Subject + Activity ~ variable, mean)

write.table(meandat, "second_tidy_data_set.txt", row.names = FALSE, quote = FALSE)



