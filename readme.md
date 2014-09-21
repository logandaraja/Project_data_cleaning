# Data Cleaning Project

The data set was on recognizing human activities using smartphone. The raw form of the original data set was obtained from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip]. It is a zip file containing training and test data sets respectively in the subdirectory train and test. The predictive variables are in the file prefixed by X (X_train.txt and X_test.txt). The training and test data sets have 561 variables which include the signal directly observed and derived.

The project involves writing R scripts to achieve the following 5 steps
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Step 1
To achieve the first step, X_test.txt and X_train.text files are read into x_test and x_train respectively. brined is used to merge x_test and x_train into x_merged. The known activity of each observation is recoded (coding of activity) in a file prefixed Y (Y_train.txt and Y_test.txt). Each file is read and combined activities are in Y_merged (again we have used brined). The people participated in the experiment are stored in files prefixed by subject (subject_train.txt, subject_test.txt). The combined subject is in subject_merged. The order of combining training and test instances must be preserved across all the data sets. We have used appended test instances after training instances. 

Results of step 1.
The merged data of X-train.txt and X_test.txt is in data frame x_merged
The merged data of Y_train.txt and Y_test.txt is in data frame y_merged
The merged data of subject_train.txt subject_test.txt is in data frame subject_merged

## Step 2
There are 561 predictor variables (X_merged). To extract only the variables denoting mean and standard deviation, we have used grep command. The set of features are in file features.txt and are in the same order as the column order of X_merged. Column index of mean and std are obtained first followed by obtaining the column names for these indexes. Using the column index the corresponding X data are extracted (x_merged_mean and x_merged_std). These were combined into x_merged_clean using data.frame.

The extracted data having mean and std of predictor variables X is in data frame X_merged_clean

## Step 3
The file Y_train.txt and Y_test.text has the numerical coding of the activity. The file activity_labels.txt has the descriptive name for each numerical coding. Each coded element in y_merged is replaced by details description given in activity_label. The subject data frame and activity data frame are combined into x_merged data frame into a data frame called merged_data with the respective column heading

## Step 4
The combined data frame named merged_data which includes the subjects, activities and the predictive X variables are appropriately named in their column header.

## Step 5
There is no built in function to find the average of each predictive variables (X) for each subject and for each activity. We have written a function called ApplyList1List2 which takes a data frame, list1 and list2 and the function to perform (default is mean). For each elements of List1 and for each element of List2 it create a mean value of each predictive X variable. It returns a new data frame. The column name of the returned data frame is changed to reflect the mean value of the selected rows of each column except for the first two column which are respectively subject and activity.

The result is written in a file names "clean_data_project_q5.txt" in the current working directory of the local machine
