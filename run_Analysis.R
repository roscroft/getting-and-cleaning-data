  run_Analysis = function() {
  # Download folder
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","wearable.zip")
  # Unzip folder
  unzip("wearable.zip")
  
  # Read in X_test data
  X_test <- read.table(text = gsub("  ", " ", readLines(".//UCI HAR Dataset//test//X_test.txt")))
  # Read in X_train data
  X_train <- read.table(text = gsub("  ", " ", readLines(".//UCI HAR Dataset//train//X_train.txt")))
  # Combine train and test data sets
  X <- rbind(X_test, X_train)
  # Calculate row means
  X$means <- rowMeans(X)
  # Calculate row standard deviations (not including means column)
  X <- X %>% mutate(stds = apply(.[(1:ncol(X)-1)],1,sd))
  # Retrieve only means and standard deviations
  X <- select(X, means, stds)
  
  # Read in y_test data
  y_test <- read.table(text = gsub("  ", " ", readLines(".//UCI HAR Dataset//test//y_test.txt")))
  # Read in y_train data
  y_train <- read.table(text = gsub("  ", " ", readLines(".//UCI HAR Dataset//train//y_train.txt")))
  # Combine train and test data sets
  y <- rbind(y_test, y_train)
  # Label y values as activities
  y <- y %>% rename("activity" = "V1")
  
  # Read in subject_test data
  subject_test <- read.table(text = gsub("  ", " ", readLines(".//UCI HAR Dataset//test//subject_test.txt")))
  # Read in subject_train data
  subject_train <- read.table(text = gsub("  ", " ", readLines(".//UCI HAR Dataset//train//subject_train.txt")))
  # Combine train and test data sets
  subject <- rbind(subject_test, subject_train)
  # Label subject values as subject
  subject <- subject %>% rename("subject" = "V1")
  
  # Attach numeric labels to data
  tidy1 <- cbind(subject, y, X)
  # Change numeric labels to factor
  tidy1$activity <- as.factor(tidy1$activity)
  
  # Extract activities from data set
  labels <- read.table(".//UCI HAR Dataset//activity_labels.txt")
  # The labels are stored in the column "V2"; rename for readability
  labels <- labels %>% rename("activity_labels" = "V2")
  
  # The activities listed in labels are the levels for the numeric labels in our crafted dataset. Replace them directly
  levels(tidy1$activity) <- labels$activity_labels
  
  
  # For the second data set, group by subject, then by activity
  subjects <- group_by(tidy1, subject, activity)
  # Then create a second, independent tidy data set with the average of each variable for each activity and each subject.
  tidy2 <- subjects %>% summarize(means = mean(means), stds = mean(stds))
  write.table(tidy2,"tidy_analysis.txt",row.name=FALSE)
  return(tidy2)
}