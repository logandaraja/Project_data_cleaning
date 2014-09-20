#set the current working directory to UCI HAR Dataset
# change the following setwd as appropriate to your setting
# setwd("~/Documents/Class/CleaningData/Project/UCI HAR Dataset/")

# merging training and test data sets
# merging test and train data sets of x, y and subjects
# 1. Merging training and test data set together
# x_test and x_train into x_merged
# y_test and y_train into y_merged
# subject_test and subject_train into subject_merged

x_test=read.table('./test/X_test.txt')
x_train=read.table('./train/X_train.txt')
x_merged=rbind(x_train,x_test)
y_test=read.table('./test/y_test.txt')
y_train=read.table('./train/y_train.txt')
y_merged=rbind(y_train,y_test)
subject_train=read.table('./train/subject_train.txt')
subject_test=read.table('./test/subject_test.txt')
subject_merged=rbind(subject_train,subject_test)
colnames(subject_merged)="Subject"
# converting the subject as a factor
subject_merged$Subject=as.factor(subject_merged$Subject)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
# Names of the colums are stored in the file features.txt it is read as features to extract
# only the measuremnent on mean and standard deviation
# the extracted cleaned data is in x_merged_clean

features=read.table('features.txt')
# extract the mean and standard deviation 
feature_rename=gsub('-','_',features[,2])
col_index_mean=grep('_mean()',feature_rename,fixed=T)
col_index_std=grep('_std()',feature_rename,fixed=T)
# get the column names of the coloumn index related to mean and std
col_name=feature_rename[c(col_index_mean,col_index_std)]
# rewriting the coloumn names by replacing () by empty string
col_rename=gsub("()","",col_name,fixed=T)
col_rename=gsub("std","standard_deviation",col_rename,fixed=T)
#creating a clean data set by merging testing and trainng data sets involved with mean and std of the signals
x_merged_mean_col=x_merged[,col_index_mean]
x_merged_std_col=x_merged[,col_index_std]
x_merged_clean=data.frame(x_merged_mean_col,x_merged_std_col)
colnames(x_merged_clean)=col_rename

# 3.Uses descriptive activity names to name the activities in the data set
# activity label has the integer coding of activities that are used in files y_test.txt and y_train.txt
# The activity column and the subject column are inserted in the data from step 2
# the activity codes replaced by descriptive activities are in mergedData

activity_label=read.table('activity_labels.txt')
y_merged_vect=y_merged[,1]
# replacing the code in all the instances of in y using gsub
for(i in 1:nrow(activity_label)){y_merged_vect=gsub(activity_label[i,1],activity_label[i,2],y_merged_vect)}
y_merged_df=data.frame(y_merged_vect)
colnames(y_merged_df)="Activities"
#inserting the details of subjects and their activities as column one and column two
mergedData=data.frame(subject_merged,y_merged_df,x_merged_clean)

# 4. Appropriately labels the data set with descriptive variable names.
# The infix notation - is replaced by _
# std and mean () in column names were respectively  replaced by standard deviation 
# and mean() inis replaced by "" (These replacements has been done in script lines 32 though 34.

# 5. From the data set in step 4, creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
# a function named ApplyList1List2 is created to apply the function to a group constrained by 
# each element in List 1 and List2
# dfNew has the average of each variable for each activity and each subject.
# the column names were changed as per the operation and the final results is stored in a
# file clean_data_project_q5.txt of the current directory

ApplyList1List2<-function(df,subjectList,activityList,FUN=mean){
  dfNew=data.frame(matrix(ncol=ncol(df),nrow=0))
  colnames(dfNew)=colnames(df)
  for (subject in subjectList){
    for (activity in activityList){
      set1=df[df$Subject==subject & df$Activities==activity,]
      row1=as.data.frame(apply(set1[,-c(1,2)],2,FUN))
      subjectEventDf=data.frame(subject,activity)
      colnames(subjectEventDf)=c("Subject","Activities")
      row1Df=data.frame(subjectEventDf,t(row1))
      dfNew=rbind(dfNew,row1Df)  
    }
  }
  return(dfNew)
}

subjectList=unique(mergedData$Subject)
activityList=activity_label[,2]
dfNew=ApplyList1List2(mergedData,subjectList,activityList,FUN=mean)
# relabbling the new cleaned data set with the prefix mean valus of for all the columns 
# excepot for the columns on subject and activities
prefix=c(rep("Mean_value_of",ncol(dfNew)-2))
colnames_old=colnames(dfNew)
colnames_dfNew=paste(prefix,colnames_old[3:ncol(dfNew)])
colnames_dfNew=c(colnames_old[1:2],colnames_dfNew)
colnames(dfNew)=colnames_dfNew
#write the data in local file with out the row names 
write.table(dfNew,"clean_data_project_q5.txt",quote=F,row.names=F)






