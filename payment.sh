component=payment
source common.sh
rabbitmq_app_password=$1
if [ -z "${rabbitmq_app_password}" ]; then
  echo Input rabbitmq user Password Missing
  exit
fi
func_python