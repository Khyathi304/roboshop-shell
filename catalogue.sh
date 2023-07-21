echo "<<<<<<<<< Create Catalouge Service <<<<<<<<<"
cp catalogue.service /etc/systemd/system/catalogue.service

echo "<<<<<<<<< Create MongoRepo <<<<<<<<<"
cp mongo.repo /etc/yum.repos.d/mongo.repo

echo "<<<<<<<<< Install NodeJs Repo <<<<<<<<<"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo "<<<<<<<<< Install NodeJS <<<<<<<<<"
yum install nodejs -y

echo "<<<<<<<<< Create Application User <<<<<<<<<"
useradd roboshop

echo "<<<<<<<<< Create Application Directory <<<<<<<<<"
mkdir /app

echo "<<<<<<<<< Download application content <<<<<<<<<"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip

echo "<<<<<<<<< Extract application content <<<<<<<<<"
cd /app
unzip /tmp/catalogue.zip
cd /app

echo "<<<<<<<<< Download NodeJs Dependencies <<<<<<<<<"
npm install

echo "<<<<<<<<< Install Mongo Client <<<<<<<<<"
yum install mongodb-org-shell -y

echo "<<<<<<<<< Load Catalogue schema <<<<<<<<<"
mongo --host mongodb.kdevops304.online </app/schema/catalogue.js

echo "<<<<<<<<< Restart the server <<<<<<<<<"
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
