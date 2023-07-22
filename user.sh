log=/tmp/roboshop.log

echo -e "\e[36m>>>>>>>>> Create user Service <<<<<<<<<<\e[0m"
cp user.service /etc/systemd/system/user.service &>>${log}

echo -e "\e[36m>>>>>>>>> Create MongoRepo <<<<<<<<<<\e[0m"
cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

echo -e "\e[36m>>>>>>>>> Install NodeJs Repo <<<<<<<<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<<\e[0m"
yum install nodejs -y &>>${log}

echo -e "\e[36m>>>>>>>>> Create Application User <<<<<<<<<<\e[0m"
useradd roboshop &>>${log}

echo -e "\e[36m>>>>>>>>> Removing the content <<<<<<<<<<\e[0m"
rm -rf /app &>>${log}

echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<<<\e[0m"
mkdir /app &>>${log}

echo -e "\e[36m>>>>>>>>> Download application content <<<<<<<<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>${log}

echo -e "\e[36m>>>>>>>>> Extract application content <<<<<<<<<<\e[0m"
cd /app
unzip /tmp/user.zip &>>${log}
cd /app

echo -e "\e[36m>>>>>>>>> Download NodeJs Dependencies <<<<<<<<<<\e[0m"
npm install &>>${log}

echo -e "\e[36m>>>>>>>>> Install Mongo Client <<<<<<<<<<\e[0m" | tee -a ${log}
yum install mongodb-org-shell -y &>>${log}

echo -e "\e[36m>>>>>>>>> Load user schema <<<<<<<<<<\e[0m" | tee -a ${log}
mongo --host mongodb.kdevops304.online </app/schema/user.js &>>${log}

echo -e "\e[36m>>>>>>>>> Restart the server <<<<<<<<<<\e[0m" | tee -a ${log}
systemctl daemon-reload &>>${log}
systemctl enable user &>>${log}
systemctl restart user &>>${log}
