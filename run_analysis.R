#this script will merge the datasets, extract only mean and standard deviation, rename the activities, label the variables, and create a tidy data set

#download and extract the zip separately

#load the datasets

subject_train <- read.table("C:/Users/Richard/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
View(subject_train)
subject_test <- read.table("C:/Users/Richard/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
View(subject_test)
y_train <- read.table("C:/Users/Richard/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
View(y_train)
y_test <- read.table("C:/Users/Richard/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
View(y_test)
X_test <- read.table("C:/Users/Richard/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
View(X_test)
X_train <- read.table("C:/Users/Richard/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
View(X_train)
features <- read.table("C:/Users/Richard/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
View(features)

#assign colnames

colnames(X_test)<-features[,2]
colnames(y_train)<-"Activity"
colnames(y_test)<-"Activity"
colnames(subject_train)<-"subject"
colnames(subject_test)<-"subject"
colnames(X_train)<-features[,2]

#combine the data sets

test_total <- cbind(X_test,y_test,subject_test)
train_total <- cbind(X_train,y_train,subject_train)
comb_total <-rbind(test_total,train_total)

#subset out the mean and standard deviation

colnames <- colnames(comb_total) 
mean_stdev <- (grepl("Activity",colnames) | grepl("subject",colnames)|grepl("mean..",colnames)|grepl("std..",colnames))

sub_comb_total <- comb_total[ , mean_stdev == TRUE]

#clean up the fields

sub_comb_cols <- colnames(sub_comb_total)

sub_comb_cols <- gsub("[\\(\\)-]", "", sub_comb_cols)

sub_comb_cols <- gsub("^f", "frequencyDomain", sub_comb_cols)
sub_comb_cols <- gsub("^t", "timeDomain", sub_comb_cols)
sub_comb_cols <- gsub("Acc", "Accelerometer", sub_comb_cols)
sub_comb_cols <- gsub("Gyro", "Gyroscope", sub_comb_cols)
sub_comb_cols <- gsub("Mag", "Magnitude", sub_comb_cols)
sub_comb_cols <- gsub("Freq", "Frequency", sub_comb_cols)
sub_comb_cols <- gsub("mean", "Mean", sub_comb_cols)
sub_comb_cols <- gsub("std", "StandardDeviation", sub_comb_cols)
sub_comb_cols <- gsub("BodyBody", "Body", sub_comb_cols)
colnames(sub_comb_total)<-sub_comb_cols

#rename the activities 

activity_labels <- read.table("C:/Users/Richard/Downloads/getdata%2Fprojectfiles%2FUCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
View(activity_labels)

colnames(activity_labels) <- c('activityId','activity_labels')
finalDataNoActivityType  <- sub_comb_cols[,names(sub_comb_cols) !='activityType'];

sub_comb_total<- merge(sub_comb_total,activity_labels,by.x='Activity',by.y='activityId')

#average

sub_comb_tot2<-aggregate(sub_comb_total[,names(sub_comb_total)!= c('activity','subject')],
                         by=list(activity=sub_comb_total$activity,subject= sub_comb_total$subject),mean);

# output to file "tidy_data.txt"
write.table(sub_comb_tot2, './tidy_data.txt',row.names=TRUE,sep='\t');