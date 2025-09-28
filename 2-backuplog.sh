#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[37m"
SOURCE_DIR=$1
DEST_DIR=$2
NO_DAYS=${3:-14}

echo "Script started executed at:$(date)" |tee -a $LOG_FILE

#check the user having root priveleages or not
if [ $USERID -ne 0 ]; then
echo "error:$R please run the script with root priveleages$N"
exit 1
fi
# here we needs pass the our script dynamically #
USAGE(){
#echo : "execution script <sourcedir><dest dir><nodays>
echo : "$R sudo sh 2-backuplog.sh $SOURCE_DIR $DEST_DIR $NO_DAYS $N"
exit 1
}
#checking the argments provide or not
if [ $# -lt 2 ]; then           #That means the script would run even if <NO_DAYS> is missing.
   USAGE
fi

#checking the source directory is exist or not
if [ ! -d $SOURCE_DIR ]; then
 echo "$R Source $SOURCE_DIR directory is not exist"
 exit 1
 fi

 #checking the destination directory is exist or not
if [ ! -d $DEST_DIR ]; then
 echo "$R Destion $DEST_DIR directory is not exist"
 exit 1
 fi

 #find the 14 days old logs and pass out put to other command in put##
FILES=$(find $SOURCE_DIR -type f -name '*.log' -mtime +14) 

#check files are empty are not 
if [ ! -z $FILES ]; then
echo " Files are found: $FILES"

#if we found file then zip it,if you needs to zip the file we want file name
TIMESTAMP=(date +%F-%H-%M)
ZIP_FILE_NAME=$DEST_DIR/app_logs-$TIMESTAMP.zip
echo "zip file name is: $ZIP_FILE_NAME"

#check archival is success or not
 
 if [ -f  $ZIP_FILE_NAME ]; then
 echo =e "$G Files are archived sucess $N "

#once files are archived then delete the files in source directory
while IFS= read -r oldlogfiles
do
echo "old logs files are deleting :$oldlogfiles"
rm -rf $oldlogfiles
echo "deleted old logs :$oldlogfiles"
done <<< $FILES

else 
echo "archived failed skipping "
exit 1
fi

else 
echo "no failes archived failed "
fi
