log=/tmp/roboshop.log

func_apppreq() {
    echo -e "\e[36m>>>>>>>>> Create Application User <<<<<<<<<<\e[0m"
    useradd roboshop &>>${log}

    echo -e "\e[36m>>>>>>>>> Removing the existing content <<<<<<<<<<\e[0m"
    rm -rf /app &>>${log}

    echo -e "\e[36m>>>>>>>>> Create Application Directory <<<<<<<<<<\e[0m"
    mkdir /app &>>${log}

    echo -e "\e[36m>>>>>>>>> Download application content <<<<<<<<<<\e[0m"
    curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log}

    echo -e "\e[36m>>>>>>>>> Extract application content <<<<<<<<<<\e[0m"
    cd /app
    unzip /tmp/${component}.zip &>>${log}
    cd /app
}

func_systemd() {
  echo -e "\e[36m>>>>>>>>> Restart the server <<<<<<<<<<\e[0m" | tee -a ${log}
    systemctl daemon-reload &>>${log}
    systemctl enable ${component} &>>${log}
    systemctl restart ${component} &>>${log}
}

func_nodejs(){


  echo -e "\e[36m>>>>>>>>> Create ${component} Service <<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[36m>>>>>>>>> Create MongoRepo <<<<<<<<<<\e[0m"
  cp mongo.repo /etc/yum.repos.d/mongo.repo &>>${log}

  echo -e "\e[36m>>>>>>>>> Install NodeJs Repo <<<<<<<<<<\e[0m"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log}

  echo -e "\e[36m>>>>>>>>> Install NodeJS <<<<<<<<<<\e[0m"
  yum install nodejs -y &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>> Download NodeJs Dependencies <<<<<<<<<<\e[0m"
  npm install &>>${log}

  echo -e "\e[36m>>>>>>>>> Install Mongo Client <<<<<<<<<<\e[0m" | tee -a ${log}
  yum install mongodb-org-shell -y &>>${log}

  echo -e "\e[36m>>>>>>>>> Load user schema <<<<<<<<<<\e[0m" | tee -a ${log}
  mongo --host mongodb.kdevops304.online </app/schema/${component}.js &>>${log}

  func_systemd

}

func_java() {
  echo -e "\e[36m>>>>>>>>> create a ${component} service file <<<<<<<<<<\e[0m"
  cp ${component}.service /etc/systemd/system/${component}.service &>>${log}

  echo -e "\e[36m>>>>>>>>> Install Maven <<<<<<<<<<\e[0m"
  yum install maven -y &>>${log}

  func_apppreq

  echo -e "\e[36m>>>>>>>>> Build ${component} Service  <<<<<<<<<<\e[0m"
  mvn clean package &>>${log}
  mv target/${component}-1.0.jar ${component}.jar &>>${log}

  echo -e "\e[36m>>>>>>>>> Install MySql Client  <<<<<<<<<<\e[0m"
  yum install mysql -y &>>${log}

  echo -e "\e[36m>>>>>>>>> Load Schema  <<<<<<<<<<\e[0m"
  mysql -h mysql.kdevops304.online -uroot -pRoboShop@1 < /app/schema/${component}.sql &>>${log}

  func_systemd

}
