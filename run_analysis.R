##Course Project

##Step 1: Merge the training and test sets to create one data set

#read the data from training files
xTraining = read.table('./train/x_train.txt', header=FALSE);
yTraining= read.table('./train/y_train.txt', header= FALSE);
features = read.table('./features.txt', header= FALSE);
activityType = read.table('./activity_labels.txt', header=FALSE);
subjectTraining = read.table('./train/subject_train.txt', header=FALSE);

#merging and creating final training set
trainingData= cbind(yTraining,subjectTraining,xTraining);

#read data from test files
subjectTest = read.table('./test/subject_test.txt', header=FALSE);
xTest= read.table('./test/x_test.txt',header=FALSE);
yTest= read.table('./test/y_test.txt',header=FALSE);

#merging and creating final test set
testData= cbind(yTest,subjectTest,xTest);

#assign column names
colnames(activityType) = c('activityId','activityType');
colnames(subjectTraining) = "subjectId";
colnames(xTraining)= features[,2];
colnames(yTraining)="activityId";
colnames(subjectTest)="subjectId";
colnames(xTest)= features[,2];
colnames(yTest)="activityId";

#Combine both sets to create final data set
finalData=rbind(trainingData,testData);

colNames= colnames(finalData);

##Step 2: Extract only the measurements on mean and standard deviation
##for each measurement

KeepColumns = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames));
finalData=finalData[KeepColumns==TRUE];

##Step 3: Use descriptive activity names to name activities in data set

finalData= merge(finalData,activityType,by= 'activityId', all.x = TRUE);
colNames= colnames(finalData);

##Step 4: Appropriately label the data set with descriptive variable names

#to clean up variable names and remove special characters
for(i in 1:length(colNames)){
  colNames[i]=gsub("\\()","",colNames[i])
  colNames[i]=gsub("^t","time",colNames[i])
  colNames[i]=gsub("^f","frequency",colNames[i])
  colNames[i]=gsub("AccMag","accMagnitude",colNames[i])
  colNames[i]=gsub("JerkMag","jerkMagnitude",colNames[i])
  colNames[i]=gsub("GyroMag","gyroMagnitude",colNames[i])
  colNames[i]=gsub("BodyBody","Body",colNames[i])
  colNames[i]=gsub("-std$","StdDev",colNames[i])
  colNames[i]=gsub("-mean","Mean",colNames[i])
};

colnames(finalData)=colNames;

##Step 5: create second, independent tidy data set with average of each
##variable for each activity and each subject

finalData2 = finalData[,names(finalData) !='activityType'];
tidyData= aggregate(finalData2[,names(finalData2) !=c('activityId','subjectId')],by=list(activityId=finalData2$activityId, subjectId=finalData2$subjectId),mean);
tidyData= merge(tidyData,activityType,by='activityId',all.x=TRUE);

#export tidyData to tidyData.txt
write.table(tidyData,'./tidyData.txt',row.names=TRUE,sep='\t')
