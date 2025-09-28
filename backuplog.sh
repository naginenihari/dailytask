#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[37m"
SOURCE_DIR=$1
DEST_DIR=$2
NO_DAYS=${3:-14} # if not provided considered as 14 days

LOGS_FOLDER="/var/log/shell-scripting"
SCRIPT_NAME=$(echo $0 |cut -d '.' -f1)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"

mkdir -p $LOGS_FOLDER
echo "Script started executed at:$(date)" |tee -a $LOG_FILE

#Checking user is root user or not

if [ $USERID -ne 0 ]; then
    echo "ERROR :: please run this scripts with root privelege"
    exit 1
fi

USAGE(){
    echo -e "$R USAGE:: sudo sh 24-backup.sh <SOURCE_DIR> <DEST_DIR> <NO_DAYS> $N"
    exit 1
}

if [ $# -lt 2 ]; then
    USAGE 
fi

if [ ! -d $SOURCE_DIR ]; then
    echo -e "$R source $SOURCE_DIR is not exist $N"
    exit 1
fi

if [ ! -d $DEST_DIR ]; then
    echo -e "$R destination $DEST_DIR is not exist $N"
    exit 1
fi

FILES=$(find $SOURCE_DIR -type f -name '*.log' -mtime +$NO_DAYS)

if [ ! -z "$FILES" ]; then
 echo "Files are Found: $FILES"
TIMESTAMP=$(date +%F-%H-%M)
ZIP_FILE_NAME="$DEST_DIR/app-logs-$TIMESTAMP.zip"
 echo "Zip file name: $ZIP_FILE_NAME"
 echo "$FILES" |zip -@ -j "$ZIP_FILE_NAME"

 ### Check Archieval Success or not ###
    if [ -f $ZIP_FILE_NAME ]; then
        echo -e "Archeival ... $G SUCCESS $N"

        ### Delete if success ###
        while IFS= read -r filepath
        do
            echo "Deleting the file: $filepath"
            rm -rf $filepath
            echo "Deleted the file: $filepath"
        done <<< $FILES
    else
        echo -e "Archieval ... $R FAILURE $N"
        exit 1
    fi
 else
    echo -e "No files to archeive ... $Y SKIPPING $N"
fi