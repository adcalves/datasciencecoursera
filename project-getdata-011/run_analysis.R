# Load all raw data. Each training/test data consist of three separate files.
x.train <- read.delim("train/X_train.txt", header = FALSE, sep = "")
subject.train <- read.delim("train/subject_train.txt", header = FALSE)
y.train <- read.delim("train/y_train.txt", header = FALSE)
x.test <- read.delim("test/X_test.txt", header = FALSE, sep = "")
subject.test <- read.delim("test/subject_test.txt", header = FALSE)
y.test <- read.delim("test/y_test.txt", header = FALSE)
activity.labels <- read.delim("activity_labels.txt", sep = " ", header = FALSE)
features = read.delim("features.txt", header = FALSE, sep = " ")

# Merge training data with the test data
x <- rbind(x.train, x.test)
subject <- rbind(subject.train, subject.test)
y <- rbind(y.train, y.test)

# Fix x to have the right columns (mean, std) and the right column names.
names(x) <- make.names(names = as.vector(features[,2]), unique = TRUE, allow_ = TRUE)
x = select(x, contains("mean.."), contains("std.."), -ends_with("gravityMean."))

# Add subject to the beginning and give it a better column name
tidy <- cbind(subject, x)
names(tidy)[1] <- "subject"

# Join activity with labels and then add to x
y <- merge(y, activity.labels, by.x = "V1", by.y = "V1", sort = FALSE)
tidy <- cbind(tidy, y[,2])
names(tidy)[68] <- "activity"

# Create new tidy data-set summarizing the mean of all features grouped by subject, activity
summarized.tidy <- group_by(tidy, subject, activity)
summarized.tidy <- summarise_each(summarized.tidy, funs(mean))
write.table(summarized.tidy, file = "summarized.tidy.txt", row.names = FALSE)







