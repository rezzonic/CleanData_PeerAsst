#### SECTION 1 ####

# read colNames
colNames <- as.character(read.table("features.txt")[,2])

# replace dashes, parentheses and commas with dots
colNames <- gsub("[-|()|,]",".",colNames)
# oops, too many dots. Reduce dots
colNames <- gsub("\\.+",".",colNames)
# remove dots at the end of the string
colNames <- gsub("\\.$","",colNames)

# read activity labels (fot y_test, y_train)
activities <- read.table('activity_labels.txt')

# read data for test set
Xtest <- read.table("test/X_test.txt")
Ytest <- read.table("test/y_test.txt")

colnames(Xtest)=colNames

subjectid <- read.table("test/subject_test.txt")
names(subjectid)="subject.id"
activity <- factor(as.character(Ytest$V1),labels=activities$V2)
set <- rep("test",length(activity))
test <- cbind(Xtest, activity, subjectid, set)

#### SECTION 2 ####

# read data for training set

Xtrain <- read.table("train/X_train.txt")
Ytrain <- read.table("train/y_train.txt")

colnames(Xtrain)=colNames

subjectid <- read.table("train/subject_train.txt")
names(subjectid)="subject.id"
activity <- factor(as.character(Ytrain$V1),labels=activities$V2)
set <- rep("train",length(activity))
train <- cbind(Xtrain, activity, subjectid, set)

# all the data is merged in the data variable, 0th tidy dataset
data <- rbind(test, train)

# identify last 3 columns as ids
ids=c("activity", "subject.id", "set")

# now look for mean and std
meanstd <- colnames(data)[grep("mean|std",colnames(data))]

# there are some meanFreq to eliminate
meanstd <- meanstd[grep("meanFreq", meanstd, invert=TRUE)]

# data saved in tidy1, 1th tidy dataset
tidy1 <- data[,c(ids,meanstd)]

#### SECTION 3 ####

# now we work on the column names

x<-sub("^t","time.",meanstd)
x<-sub("^f","frequency.",x)
x<-sub("Acc",".accelerometer.",x)
x<-sub("Gyro",".gyroscope.",x)
x<-sub("Mag",".magnitude.",x)
x<-sub("BodyBody","Body.Body",x)
x<-gsub("\\.+",".",x)
meanstd <- tolower(x)

colnames(tidy1)=c(ids,meanstd)

#### SECTION 4 ####

# do some cleanup

# just for fun, how much memory are we using
myObjSize <- function (x) {
	object.size(eval(as.symbol(x)))
	}
mem1 <- sum(sapply(ls(all.names=TRUE),myObjSize))
# 138 MB

rm(colNames, activities, Xtest, Ytest, Xtrain, Ytrain, subjectid, activity, set, train, test, ids, meanstd, data)
mem2 <- sum(sapply(ls(all.names=TRUE),myObjSize))

(mem1-mem2)/1024^2


#### SECTION 5 ####

# point 5, even tidier data set
# average of each variable for each activity and each subject

tidy2<-aggregate(tidy1[,4:69],by=list(tidy1$activity,tidy1$subject.id),FUN=mean)
colnames(tidy2)[1:2]=c("activity", "subject.id")

# dump to file
write.csv(tidy2,file="tidy2.csv", row.names=F)

