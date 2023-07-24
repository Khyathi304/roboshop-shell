

    echo -e "\e[36m>>>>>>>>> Copy Roboshop Configuration <<<<<<<<<<\e[0m"
    cp nginx-roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log}
    func_exit-status

    echo -e "\e[36m>>>>>>>>> Install Nginx <<<<<<<<<<\e[0m"
    yum install nginx -y &>>${log}
    func_exit-status

    echo -e "\e[36m>>>>>>>>> remove the existing content <<<<<<<<<<\e[0m"
    rm -rf /usr/share/nginx/html/* &>>${log}
    func_exit-status


    echo -e "\e[36m>>>>>>>>> Download the content <<<<<<<<<<\e[0m"
    curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log}
    func_exit-status

    echo -e "\e[36m>>>>>>>>> Go into that folder <<<<<<<<<<\e[0m"
    cd /usr/share/nginx/html &>>${log}
    func_exit-status

    echo -e "\e[36m>>>>>>>>> Extract the application content  <<<<<<<<<<\e[0m"
    unzip /tmp/frontend.zip &>>${log}
    func_exit-status


    echo -e "\e[36m>>>>>>>>> start nginx service <<<<<<<<<<\e[0m"
    systemctl enable nginx &>>${log}
    systemctl restart nginx &>>${log}
    func_exit-status


