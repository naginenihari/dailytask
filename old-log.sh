#!/bin/bash
USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e{33m"
N="\e[37m"
SOURCE_DIR=/home/ec2-user/app_logs

 echo "Script execution started:$(date +%s)"

if [ $USERID -ne 0 ]; then
 echo "please execute scripts with root user you dont have priveleges to run this script"
 exit 1
fi

if [ ! -d $SOURCE_DIR ]; then
  echo "Source directory :$SOURCE_DIR is not avaliable"
  exit 1
fi

FILES_TO_DELETE=$(find $SOURCE_DIR -type f -name '*.log' -mtime +14)

while IFS= read -r oldfiles
 do
 echo "previous old logs are $oldfiles
 echo "old files are found and ready to delete"
 rm -rf $oldfiles
 echo "old 14 days logs are deleted"
 done <<<$FILES_TO_DELETE