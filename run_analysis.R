dir.create("~/ProjectGetCleanData")
setwd("~/ProjectGetCleanData")
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="./UCI_Har.zip",mode="wb",method="curl")
unzip("UCI_Har.zip")
library(reshape2)
library(dplyr)
activity<-read.table("./UCI HAR Dataset/activity_labels.txt")
names(activity)<-c("ActivityId","Activity")
features<-read.table("./UCI HAR Dataset/features.txt")
subject_test<-read.table("./UCI HAR Dataset/test/subject_test.txt")
names(subject_test)<-"Subject"
x_test<-read.table("./UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("./UCI HAR Dataset/test/y_test.txt")
names(x_test)<-features[[2]]
names(y_test)<-"ActivityId"
runtest<-cbind(y_test,x_test)
runtest<-cbind(subject_test,runtest)
runtest<-merge(activity,runtest,by.x="ActivityId",by.y="ActivityId", all=TRUE)


subject_train<-read.table("./UCI HAR Dataset/train/subject_train.txt")
names(subject_train)<-"Subject"
x_train<-read.table("./UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("./UCI HAR Dataset/train/y_train.txt")
names(x_train)<-features[[2]]
names(y_train)<-"ActivityId"
runtrain<-cbind(y_train,x_train)
runtrain<-cbind(subject_train,runtrain)
runtrain<-merge(activity,runtrain,by.x="ActivityId",by.y="ActivityId", all=TRUE)

run<-rbind(runtest,runtrain)
x<-lapply(c("std()","mean()"),grep, names(run))
x<-c(x[[1]],x[[2]],c(1,2,3)) %>% sort
run<-run[,x]
rm(x)
n<-names(run)
n<-gsub("std","StdDev",n)
n<-gsub("mean","Mean",n)
n<-gsub("[()]",replacement="",n)
names(run)<-n
rm(n)
tidyData <- ddply(run, .(Subject, Activity), function(x) colMeans(x[, 3:length(names(x))]))
write.table(tidyData, "tidyData.txt", row.name=FALSE)
