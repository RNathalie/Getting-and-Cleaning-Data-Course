“Getting and Cleaning Data” Couse Project


#CODE BOOK



*Content*

I.	*Project description*
II.	*Project (raw) dataset description*
III.	*Study design, tidy data variables description*



##I. Project description 

The Project data represent the results of Smartlab – Non Linear Complex Systems Laboratory –experiment, called Human Activity Recognition Using Smartphones. 
Project data link: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
####Project instructions:
1. Create R script which performs: 
* Merges the training and the test sets to create one data set;
* Extracts only the measurements on the mean and standard deviation for each measurement;
* Uses descriptive activity names to name the activities in the data set;
* Appropriately labels the data set with descriptive variable names. 
* From the data set in previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
2. Present Code books with tidy data variables description
3. Submit tidy dataset, created by performing the R script .



##II. Project (raw) dataset description
Data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
The experiment (Human Activity Recognition Using Smartphones) has been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (walking, walking upstairs, walking downstairs, sitting, standing, laying) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, was captured 3-axial linear acceleration and 3-axial angular velocity. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 
The features selected for the database come from the accelerometer and gyroscope 3-axial raw signals. These time domain signals  were captured at a constant rate of 50 Hz. The acceleration signal was then separated into body and gravity acceleration signals using another low pass Butterworth filter with a corner frequency of 0.3 Hz. The body linear acceleration and angular velocity were derived in time to obtain Jerk signals. The magnitude of three-dimensional signals was calculated using the Euclidean norm. A Fast Fourier Transform (FFT) was applied to some of these signals producing frequency domain signals. 
*These signals were used to estimate variables of the feature vector for each pattern:*
tBodyAcc-XYZ
tGravityAcc-XYZ
tBodyAccJerk-XYZ
tBodyGyro-XYZ
tBodyGyroJerk-XYZ
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-XYZ
fBodyAccJerk-XYZ
fBodyGyro-XYZ
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

*The set of variables that were estimated from these signals are: *
mean(): Mean value
std(): Standard deviation
mad(): Median absolute deviation 
max(): Largest value in array
min(): Smallest value in array
sma(): Signal magnitude area
energy(): Energy measure. Sum of the squares divided by the number of values. 
iqr(): Interquartile range 
entropy(): Signal entropy
arCoeff(): Autorregresion coefficients with Burg order equal to 4
correlation(): correlation coefficient between two signals
maxInds(): index of the frequency component with largest magnitude
meanFreq(): Weighted average of the frequency components to obtain a mean frequency
skewness(): skewness of the frequency domain signal 
kurtosis(): kurtosis of the frequency domain signal 
bandsEnergy(): Energy of a frequency interval within the 64 bins of the FFT of each window.
angle(): Angle between to vectors.



##III. Study design


####Creating a tidy dataset

**Input:**

*The data should be downloaded (link below) and unzipped in R working directory.
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
*Script `run_analysis.R`
*Performing  the script (run_analysis.R) needs R packages:

```
library (dplyr)
library (data.table)
```

**Procedure**

#####1.Reading the train and test data into R, merging them

*1.a. Reading, binding test, train sets*

```
data_x_test<-read.table("UCI HAR Dataset/test/X_test.txt", header=F)
data_x_train<-read.table("UCI HAR Dataset/train/X_train.txt", header=F)
Data_x<-rbind(data_x_test, data_x_train)
```

*1.b. Reading, binding test, train labels*

```
data_y_test<-read.table("UCI HAR Dataset/test/y_test.txt", header=F)
data_y_train<-read.table("UCI HAR Dataset/train/y_train.txt", header=F)
Data_y<-rbind(data_y_test, data_y_train)
colnames(Data_y)<- "Activity"
```

*1.c. Reading, binding test, train subjects*

```
data_sbj_test<-read.table("UCI HAR Dataset/test/subject_test.txt", header=F)
data_sbj_train<-read.table("UCI HAR Dataset/train/subject_train.txt", header=F)
Data_sbj<-rbind(data_sbj_test, data_sbj_train)
colnames(Data_sbj)<-"Subject"
```

*1.d. Merging data in one dataset*

Reading features into R

```
features<-read.table("UCI HAR Dataset/features.txt", header=F)

```
Assigning columns' names into main dataset (Data_x)

```
colnames(Data_x)<- features[,2]

```
Merging datasets `Data_x` , `Activities` and `Subject`  into one dataset

```
R_Data <- cbind(Data_x, Data_y, Data_sbj)
```

#####2. Extracting only mean and standard deviation variables estimated from the signal

*2.a. Getting the columns names, containing "mean" and "std"*

Note: according to the `Project instructions` and `features_info.txt` final dataset should include only variables containing `mean()` and `std()` in their names which indicate the statistical measurements (mean and SD) that were estimated from signals. So they **don’t include** `meanFreq()` and `angle()` measurements (as far as author can judge these are just other types of statistical measurements which are not specified in point 2 project instructions)

```
Var_mean_SD <- grep(".*[[:punct:]]mean[[:punct:]].*|.*std[[:punct:]].*", names(R_Data), value=TRUE, ignore.case=TRUE)

```
*2.b. Extracting the needed columns (with mean and SD measurements) plus activity and subject ones in new dataset*

```
Data_mean_SD<-R_Data[, (c(c(Var_mean_SD), "Activity", "Subject"))]
```


####3. Naming the activities

```
labels<-read.table("UCI HAR Dataset/activity_labels.txt", header=F)
for(i in 1:6){Data_mean_SD$Activity[Data_mean_SD$Activity==i]<-as.character(labels[i,2])}
```


####4. Making the variables names mnemonic and unique

```
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
```


####5. Creating tidy dataset with means of each variable for each activity-subject


*5.a. Making Subject and Activity columns as factors for aggregate function*

```
Data_mean_SD$Subject<-as.factor(Data_mean_SD$Subject)
Data_mean_SD$Activity<-as.factor(Data_mean_SD$Activity)
```

*5.b. Creating new tidy dataset with mean for each variable for each activity-subject*

```
Data_tidy<-aggregate(.~Subject+Activity,Data_mean_SD, mean)
```

*5.c. Sorting the final dataset*

```
Data_tidy<-arrange(Data_tidy, Subject, Activity)
```

*5.d. Creating the file "Tidy data.txt" with final tidy data*

```
write.table(Data_tidy, "Tidy data.txt", row.names=F)
```

**Output**

The `Tidy data.txt` file, which represents next variables

####Tidy dataset variables description

| Variable                                       | Description                                                                                                                 |
|------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| Subject                                        | One of the thirty persons, who took part in experiment                                                                      |
| Activity                                       | One of the  six activities (walking, walking_upstairs, walking_downstairs, sitting, standing, laying) each person performed |
| Time_Body_Accelometre_Mean-X                   | Time domain body acceleration mean X-axial signal, normalized within [-1;1]                                                 |
| Time_Body_Accelometre_Mean-Y                   | Time domain body acceleration mean Y-axial signal, normalized within [-1;1]                                                 |
| Time_Body_Accelometre_Mean-Z                   | Time domain body acceleration mean Z-axial signal, normalized within [-1;1]                                                 |
| Time_Body_Accelometre_SD-X                     | Time domain body acceleration standart deviation X-axial signal, normalized within [-1;1]                                   |
| Time_Body_Accelometre_SD-Y                     | Time domain body acceleration standart deviation Y-axial signal, normalized within [-1;1]                                   |
| Time_Body_Accelometre_SD-Z                     | Time domain body acceleration standart deviation Z-axial signal, normalized within [-1;1]                                   |
| Time_Gravity_Accelometre_Mean-X                | Time domain gravity acceleration mean X-axial signal, normalized within [-1;1]                                              |
| Time_Gravity_Accelometre_Mean-Y                | Time domain gravity acceleration mean Y-axial signal, normalized within [-1;1]                                              |
| Time_Gravity_Accelometre_Mean-Z                | Time domain gravity acceleration mean Z-axial signal, normalized within [-1;1]                                              |
| Time_Gravity_Accelometre_SD-X                  | Time domain gravity acceleration standart deviation X-axial signal, normalized within [-1;1]                                |
| Time_Gravity_Accelometre_SD-Y                  | Time domain gravity acceleration standart deviation Y-axial signal, normalized within [-1;1]                                |
| Time_Gravity_Accelometre_SD-Z                  | Time domain gravity acceleration standart deviation Z-axial signal, normalized within [-1;1]                                |
| Time_Body_Accelometre_Jerk_Mean-X              | Time domain body acceleration Jerk mean X-axial signal, normalized within [-1;1]                                            |
| Time_Body_Accelometre_Jerk_Mean-Y              | Time domain body acceleration Jerk mean Y-axial signal, normalized within [-1;1]                                            |
| Time_Body_Accelometre_Jerk_Mean-Z              | Time domain body acceleration Jerk mean Z-axial signal, normalized within [-1;1]                                            |
| Time_Body_Accelometre_Jerk_SD-X                | Time domain body acceleration Jerk standart deviation X-axial signal, normalized within [-1;1]                              |
| Time_Body_Accelometre_Jerk_SD-Y                | Time domain body acceleration Jerk standart deviation Y-axial signal, normalized within [-1;1]                              |
| Time_Body_Accelometre_Jerk_SD-Z                | Time domain body acceleration Jerk standart deviation Z-axial signal, normalized within [-1;1]                              |
| Time_Body_Gyroscope_Mean-X                     | Time domain body gydroscope mean X-axial signal, normalized within [-1;1]                                                   |
| Time_Body_Gyroscope_Mean-Y                     | Time domain body gydroscope mean Y-axial signal, normalized within [-1;1]                                                   |
| Time_Body_Gyroscope_Mean-Z                     | Time domain body gydroscope mean Z-axial signal, normalized within [-1;1]                                                   |
| Time_Body_Gyroscope_SD-X                       | Time domain body gydroscope standart deviation X-axial signal, normalized within [-1;1]                                     |
| Time_Body_Gyroscope_SD-Y                       | Time domain body gydroscope standart deviation Y-axial signal, normalized within [-1;1]                                     |
| Time_Body_Gyroscope_SD-Z                       | Time domain body gydroscope standart deviation Z-axial signal, normalized within [-1;1]                                     |
| Time_Body_Gyroscope_Jerk_Mean-X                | Time domain body gydroscope Jerk mean X-axial signal, normalized within [-1;1]                                              |
| Time_Body_Gyroscope_Jerk_Mean-Y                | Time domain body gydroscope Jerk mean Y-axial signal, normalized within [-1;1]                                              |
| Time_Body_Gyroscope_Jerk_Mean-Z                | Time domain body gydroscope Jerk mean Z-axial signal, normalized within [-1;1]                                              |
| Time_Body_Gyroscope_Jerk_SD-X                  | Time domain body gydroscope Jerk standart deviation X-axial signal, normalized within [-1;1]                                |
| Time_Body_Gyroscope_Jerk_SD-Y                  | Time domain body gydroscope Jerk standart deviation Y-axial signal, normalized within [-1;1]                                |
| Time_Body_Gyroscope_Jerk_SD-Z                  | Time domain body gydroscope Jerk standart deviation Z-axial signal, normalized within [-1;1]                                |
| Time_Body_Accelometre_Magnitude_Mean           | Time domain body acceleration magnitude mean signal, normalized within [-1;1]                                               |
| Time_Body_Accelometre_Magnitude_SD             | Time domain body acceleration magnitude signal standart deviation, normalized within [-1;1]                                 |
| Time_Gravity_Accelometre_Magnitude_Mean        | Time domain gravity acceleration magnitude mean signal, normalized within [-1;1]                                            |
| Time_Gravity_Accelometre_Magnitude_SD          | Time domain gravity acceleration magnitude signal standart deviation, normalized within [-1;1]                              |
| Time_Body_Accelometre_Jerk_Magnitude_Mean      | Time domain body acceleration Jerk magnitude mean signal, normalized within [-1;1]                                          |
| Time_Body_Accelometre_Jerk_Magnitude_SD        | Time domain body acceleration Jerk magnitude signal standart deviation, normalized within [-1;1]                            |
| Time_Body_Gyroscope_Magnitude_Mean             | Time domain body gydroscope magnitude mean signal, normalized within [-1;1]                                                 |
| Time_Body_Gyroscope_Magnitude_SD               | Time domain body gydroscope magnitude signal standart deviation, normalized within [-1;1]                                   |
| Time_Body_Gyroscope_Jerk_Magnitude_Mean        | Time domain body gydroscope Jerk magnitude mean signal, normalized within [-1;1]                                            |
| Time_Body_Gyroscope_Jerk_Magnitude_SD          | Time domain body gydroscope Jerk magnitude signal standart deviation, normalized within [-1;1]                              |
| Frequency_Body_Accelometre_Mean-X              | Frequency domain body acceleration mean X-axial signal, normalized within [-1;1]                                            |
| Frequency_Body_Accelometre_Mean-Y              | Frequency domain body acceleration mean Y-axial signal, normalized within [-1;1]                                            |
| Frequency_Body_Accelometre_Mean-Z              | Frequency domain body acceleration mean Z-axial signal, normalized within [-1;1]                                            |
| Frequency_Body_Accelometre_SD-X                | Frequency domain body acceleration standart deviation X-axial signal, normalized within [-1;1]                              |
| Frequency_Body_Accelometre_SD-Y                | Frequency domain body acceleration standart deviation Y-axial signal, normalized within [-1;1]                              |
| Frequency_Body_Accelometre_SD-Z                | Frequency domain body acceleration standart deviation Z-axial signal, normalized within [-1;1]                              |
| Frequency_Body_Accelometre_Jerk_Mean-X         | Frequency domain body acceleration Jerk mean X-axial signal, normalized within [-1;1]                                       |
| Frequency_Body_Accelometre_Jerk_Mean-Y         | Frequency domain body acceleration Jerk mean Y-axial signal, normalized within [-1;1]                                       |
| Frequency_Body_Accelometre_Jerk_Mean-Z         | Frequency domain body acceleration Jerk mean Z-axial signal, normalized within [-1;1]                                       |
| Frequency_Body_Accelometre_Jerk_SD-X           | Frequency domain body acceleration Jerk standart deviation X-axial signal, normalized within [-1;1]                         |
| Frequency_Body_Accelometre_Jerk_SD-Y           | Frequency domain body acceleration Jerk standart deviation Y-axial signal, normalized within [-1;1]                         |
| Frequency_Body_Accelometre_Jerk_SD-Z           | Frequency domain body acceleration Jerk standart deviation Z-axial signal, normalized within [-1;1]                         |
| Frequency_Body_Gyroscope_Mean-X                | Frequency domain body gydroscope mean X-axial signal, normalized within [-1;1]                                              |
| Frequency_Body_Gyroscope_Mean-Y                | Frequency domain body gydroscope mean Y-axial signal, normalized within [-1;1]                                              |
| Frequency_Body_Gyroscope_Mean-Z                | Frequency domain body gydroscope mean Z-axial signal, normalized within [-1;1]                                              |
| Frequency_Body_Gyroscope_SD-X                  | Frequency domain body gydroscope standart deviation X-axial signal, normalized within [-1;1]                                |
| Frequency_Body_Gyroscope_SD-Y                  | Frequency domain body gydroscope standart deviation Y-axial signal, normalized within [-1;1]                                |
| Frequency_Body_Gyroscope_SD-Z                  | Frequency domain body gydroscope standart deviation Z-axial signal, normalized within [-1;1]                                |
| Frequency_Body_Accelometre_Magnitude_Mean      | Frequency domain body acceleration magnitude mean signal, normalized within [-1;1]                                          |
| Frequency_Body_Accelometre_Magnitude_SD        | Frequency domain body acceleration magnitude signal standart deviation, normalized within [-1;1]                            |
| Frequency_Body_Accelometre_Jerk_Magnitude_Mean | Frequency domain body acceleration Jerk magnitude mean signal, normalized within [-1;1]                                     |
| Frequency_Body_Accelometre_Jerk_Magnitude_SD   | Frequency domain body acceleration Jerk magnitude signal standart deviation, normalized within [-1;1]                       |
| Frequency_Body_Gyroscope_Magnitude_Mean        | Frequency domain body gydroscope magnitude mean signal, normalized within [-1;1]                                            |
| Frequency_Body_Gyroscope_Magnitude_SD          | Frequency domain body gydroscope magnitude signal standart deviation, normalized within [-1;1]                              |
| Frequency_Body_Gyroscope_Jerk_Magnitude_Mean   | Frequency domain body gydroscope Jerk magnitude mean signal, normalized within [-1;1]                                       |
| Frequency_Body_Gyroscope_Jerk_Magnitude_SD     | Frequency domain body gydroscope Jerk magnitude signal standart deviation, normalized within [-1;1]                         |

Note: System info - MWinXP Pro SPark3, R version 3.1.2 Patched