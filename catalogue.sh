#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

VALIDATE(){

if [ $1 -ne 0 ]
    
    then

    echo -e "$R Error::$N $2 is $R FAILED"
    exit 1

    else

    echo -e "  $2 is $G success $N"
fi
}

if [ $ID -ne 0 ]
    then 

    echo "ERROR:: Please run this script with root access"
    exit 1

else

    echo "You are a root user"

fi


dnf module disable nodejs -y &>> $LOGFILE

VALIDATE $? "Disabling current version of Node JS" 

dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "Enabling current version of Node JS"  

dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "Installing NodeJS" 

#useradd roboshop1 &>> $LOGFILE
#VALIDATE $? "User Roboshop Added" 

#mkdir /app &>> $LOGFILE 
#VALIDATE $? "Creating new Directory App"

#curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE 
#VALIDATE $? "Downloading App files"

#cd /app  &>> $LOGFILE
#VALIDATE $? "Changing Directory" 

#unzip /tmp/catalogue.zip &>> $LOGFILE 
#VALIDATE $? "Unzip and Extract the files in Directory App"

#npm install  &>> $LOGFILE 
#VALIDATE $? "Installing Dependencies-NPM files"

cp /home/centos/roboshop/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE 
VALIDATE $? "Copying Catalogue file"

systemctl daemon-reload &>> $LOGFILE 
VALIDATE $? "Loading the service"

systemctl enable catalogue &>> $LOGFILE 
VALIDATE $? "Enabling the catalogue"

systemctl start catalogue &>> $LOGFILE 
VALIDATE $? "Starting the service"

cp /home/centos/roboshop/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "Copying Mongo" 

dnf install mongodb-org-shell -y &>> $LOGFILE
VALIDATE $? "Installing MongoDB"

mongo --host MONGODB-SERVER-IPADDRESS </app/schema/catalogue.js &>> $LOGFILE
VALIDATE $? "Loading the schema"

