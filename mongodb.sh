cp mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y
# Update listen address 127.0.0.0 to 0.0.0.0 [vim /etc/mongod.conf]
systemctl enable mongod
systemctl restart mongod