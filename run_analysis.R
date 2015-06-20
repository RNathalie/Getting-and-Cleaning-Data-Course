library(data.table)
library(dplyr)

#1. Reading the train and test data, merging them

#1.a. reading, binding test, train sets
data_x_test<-read.table("UCI HAR Dataset/test/X_test.txt", header=F)
data_x_train<-read.table("UCI HAR Dataset/train/X_train.txt", header=F)
Data_x<-rbind(data_x_test, data_x_train)


#1.b. reading, binding test, train labels
data_y_test<-read.table("UCI HAR Dataset/test/y_test.txt", header=F)
data_y_train<-read.table("UCI HAR Dataset/train/y_train.txt", header=F)
Data_y<-rbind(data_y_test, data_y_train)
colnames(Data_y)<- "Activity"

#1.c. reading, binding test, train subjects
data_sbj_test<-read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
data_sbj_train<-read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
Data_sbj<-rbind(data_sbj_test, data_sbj_train)
colnames(Data_sbj)<-"Subject"

#1.d. merging data in one dataset
features<-read.table("UCI HAR Dataset/features.txt", header=F)
colnames(Data_x)<- features[,2]# assinging columns' names
R_Data <- cbind(Data_x, Data_y, Data_sbj)


#2. Subtracting "*mean()" or "*std()" variables estimated from the signal
#2.a. Getting the columns names, containing "mean" and "std"
Var_mean_SD <- grep(".*[[:punct:]]mean[[:punct:]].*|.*std[[:punct:]].*", names(R_Data), value=TRUE, ignore.case=TRUE)
#2.b. Getting the needed columns plus activity and subject ones
Data_mean_SD<-R_Data[, (c(c(Var_mean_SD), "Activity", "Subject"))]

#3. Naming the activities
labels<-read.table("UCI HAR Dataset/activity_labels.txt", header=F)
for(i in 1:6){Data_mean_SD$Activity[Data_mean_SD$Activity==i]<-as.character(labels[i,2])}

#4. Making the variables names mnemonic and unique
colnames(Data_mean_SD)<-gsub("[[:punct:]]mean[[:punct:]][[:punct:]]", "Mean", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("[[:punct:]]std[[:punct:]][[:punct:]]", "SD", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("^t", "Time_", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("Acc", "Accelometre_", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("^f", "Frequency_", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("Gyro", "Gyroscope_", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("Mag", "Magnitude_", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("BodyBody", "Body", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("Body", "Body_", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("Jerk", "Jerk_", colnames(Data_mean_SD), ignore.case=T)
colnames(Data_mean_SD)<-gsub("Gravity", "Gravity_", colnames(Data_mean_SD), ignore.case=T)

#5. Creating tidy dataset with means of each variable for each activity-subject
#5.a. Making Subject and Activity columns as factors for aggregate function
Data_mean_SD$Subject<-as.factor(Data_mean_SD$Subject)
Data_mean_SD$Activity<-as.factor(Data_mean_SD$Activity)
#5.b. Creating new tidy dataset with mean for each variable for each activity-subject
Data_tidy<-aggregate(.~Subject+Activity,Data_mean_SD, mean)
#5.c. Sorting the final dataset 
Data_tidy<-arrange(Data_tidy, Subject, Activity)
#5.d. Creating the file "Tidy data.txt" with final tidy data
write.table(Data_tidy, "Tidy data.txt", row.names=F)
