mysql_root_password=$1
if [ -z "${mysql_root_password}" ]; then
  echo Input Password Missing
  exit
fi
yum module disable mysql -y
cp mysql.repo /etc/yum.repos.d/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl restart mysqld
mysql_secure_installation --set-root-pass ${mysql_root_password}