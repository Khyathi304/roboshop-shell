echo -e "\e[36m>>>>>>>>> Create Catalouge Service <<<<<<<<<<\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Create MongoRepo <<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Install NodeJs Repo <<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<<\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Create Application User <<<<<<<<<<\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Removing the content <<<<<<<<<<\e[0m"
rm -rf /app &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<<<\e[0m"
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Download application content <<<<<<<<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Extract application content <<<<<<<<<<\e[0m"
cd /app
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[36m>>>>>>>>> Download NodeJs Dependencies <<<<<<<<<<\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Install Mongo Client <<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Load Catalogue schema <<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
mongo --host mongodb.kdevops304.online </app/schema/catalogue.js &>>/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Restart the server <<<<<<<<<<\e[0m" | tee -a /tmp/roboshop.log
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable catalogue &>>/tmp/roboshop.log
systemctl restart catalogue &>>/tmp/roboshop.log
