LOG_FILE=/tmp/dispatch

source common.sh

echo "Install Golang"
yum install golang -y &>>$LOG_FILE
StatusCheck $?

id roboshop &>>${LOG_FILE}
 if [ $? -ne 0 ]; then
  echo "Add RoboShop Application User"
  useradd roboshop &>>${LOG_FILE}
  StatusCheck $?
 fi

echo "Download Application Code"
curl -L -s -o /tmp/dispatch.zip https://github.com/roboshop-devops-project/dispatch/archive/refs/heads/main.zip &>>${LOG_FILE}
StatusCheck $?

echo "Extract Application Code"
unzip /tmp/dispatch.zip &>>${LOG_FILE}
StatusCheck $?

mv dispatch-main dispatch &>>${LOG_FILE}

cd dispatch

echo "Get & Download Dependencies"
go mod init dispatch &>>${LOG_FILE}
go get &>>${LOG_FILE}
go build &>>${LOG_FILE}
StatusCheck $?


mv /home/roboshop/dispatch/systemd.service /etc/systemd/system/dispatch.service &>>${LOG_FILE}

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable dispatch &>>${LOG_FILE}

ehco "Update Systemd"
SYSTEMD_SETUP &>>${LOG_FILE}
StatusCheck $?

echo "Start Service"
systemctl restart dispatch &>>${LOG_FILE}
StatusCheck $?

