
## need to set the working directory to 
## setwd("./UCI HAR Dataset")

testdata <- read.delim("./test/X_test.txt",stringsAsFactors = FALSE,sep = "", header = FALSE);
testlabel <- read.delim("./test/y_test.txt",stringsAsFactors = FALSE, sep ="", header = FALSE);

## change testlabel variable "V1" to "ActivityNo" and then add it to the testdata 
colnames(testlabel)[1]<-"ActivityNo";
testdata <- cbind(testlabel,testdata);

## read subject_test.txt", change the variable name "V1" to "SubjectNo", and then merge the Subject No. into the testdata. 
testsubject <- read.delim("./test/subject_test.txt",stringsAsFactors = FALSE,sep = "", header = FALSE);
colnames(testsubject)[1]<-"SubjectNo";
testdata <-cbind(testsubject,testdata);

## read X.train.txt and y_train.txt for the training set into R
traindata <- read.delim("./train/X_train.txt",stringsAsFactors = FALSE, sep ="", header = FALSE);
trainlabel <- read.delim("./train/y_train.txt",stringsAsFactors = FALSE, sep ="", header = FALSE);

## change testlabel variable "V1" to "ActivityNo" and then add it to the testdata 
colnames(trainlabel)[1]<-"ActivityNo";
traindata <- cbind(trainlabel,traindata);


## read subject_train.txt", change the variable name "V1" to "SubjectNo", 
## and then merge the Subject No. into the traindata 
trainsubject <-read.delim("./train/subject_train.txt",stringsAsFactors = FALSE, sep ="", header = FALSE);
colnames(trainsubject)[1]<-"SubjectNo";
traindata <-cbind(trainsubject,traindata);

## merge testdata and traindata together into totaldata using rbind() 
totaldata <-rbind(traindata,testdata); 

## read "features.txt" into R 
features <- read.delim("features.txt",stringsAsFactors = FALSE,sep = "", header = FALSE);
## change the testdata variable ("V1"-"V561") names to the names in features
colnames(totaldata)[3:563]<- features[,2];

## read activity labels into R and change colname "V1" to "ActivityNo" and "V2" to "ActivityName"
activitylabel <- read.delim("activity_labels.txt",stringsAsFactors = FALSE,sep = "", header = FALSE);
colnames(activitylabel)[1]<-"ActivityNo";
colnames(activitylabel)[2]<-"ActivityName";
        
## Merge totaldata with activitylabel, and "ActivityName" from activitylabel is added in the last col.
totaldata<-merge(totaldata,activitylabel,by.x="ActivityNo",by.y="ActivityNo", all=TRUE, sort=FALSE);

## choose columns named as "SubjectNo", "ActivityName" or with "mean" or "std" from totaldata
chooseind <- c(grep("SubjectNo|ActivityName",names(totaldata)), grep("mean|std",names(totaldata)));
## selectdata is the  data set required in Step 4. 
selectdata <- totaldata[,chooseind];
## change all variable names to lower cases and remove -() symbols. 
colnames(selectdata)<-tolower(gsub("\\(|-|\\)","",names(selectdata)));

## creates an independent tidy data set with the average of each variable for each activity and each subject.
finaltidydata <- selectdata %>% group_by(subjectno,activityname) %>% summarise_all(mean);

## write the final tidy data set in a ".txt" file.
write.table(finaltidydata,"finaltidydata.txt",row.name=FALSE)
            
