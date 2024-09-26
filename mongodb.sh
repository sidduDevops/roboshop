#!/bin/bash

ID=$(id -u)

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)

LOGFILE="/tmp/$0-$TIMESTAMP.log"

if [ $ID -ne 0 ]
    then 

    echo "ERROR:: Please run this script with root access"
    exit 1

else

    echo "You are a root user"

fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

VALIDATE $? "Copied Mongo" 

dnf install mongodb-org -y >>& $LOGFILE

VALIDATE $? "Install Mongo" 

systemctl enable mongod >>& $LOGFILE
VALIDATE $? "Enable MongoD" 

systemctl start mongod >>& $LOGFILE
VALIDATE $? "Start MongoD" 

sed -e 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf