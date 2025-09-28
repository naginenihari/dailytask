#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[37m"

echo "Script started executed at:$(date)" |tee -a $LOG_FILE
## Check the root access or not##
if [ $USERID -ne 0 ]; then
echo "Error:you don't have root priveleages"
exit 1
#define source directory path##
SOURCE_DIR=/home/ec2-user/app_logs
#check source directory exist or not#
if [ ! -d $SOURCE_DIR ]; then
echo "source directory is not available"
exit 1
fi
#find the 14 days old logs and pass out put to other command in put##
FILES_TO_DELETE=$(find $SOURCE_DIR -type f -name '*.log' -mtime +10) 
#once we found the file then delete the file using while condition##
while IFS=read -r oldfiles #reading the files line by line##
do
echo "deleting the $oldfiles" 
rm -rf $oldfiles
echo "deleted the $oldfiles"
done <<< $FILES_TO_DELETE