COMPONENT=rabbitmq
source common.sh
LOG_FILE=/tmp/${COMPONENT}

echo "Install Erlang Dependencies for RabbitMQ"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | sudo bash &>>$LOG_FILE
yum install erlang -y &>>$LOG_FILE
StatusCheck $?

echo "Setup RabbitMQ Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>$LOG_FILE
StatusCheck $?

echo "Install RabbitMQ"
yum install rabbitmq-server -y &>>$LOG_FILE
StatusCheck $?

echo "Start RabbitMQ Server"
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl restart rabbitmq-server &>>$LOG_FILE
StatusCheck $?

echo "Add Application User in RabbitMQ"
if [ $? -ne 0 ]; then
 rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
 StatusCheck $?
fi

rabbitmqctl list_users | grep roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
 echo "Add Application User Tags in RabbitMQ"
 rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
 StatusCheck $?
fi

echo "Add Permissions for App User in RabbitMQ"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
StatusCheck $?