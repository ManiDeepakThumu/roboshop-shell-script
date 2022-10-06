 LOG_FILE=/tmp/frontend

source common.sh

echo installing Nginx
yum install nginx -y &>>$LOG_FILE
StatusCheck $?

echo downloading Nginx Web Content
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
StatusCheck $?$?

cd /usr/share/nginx/html

echo Removing Old Web Content
rm -rf * &>>$LOG_FILE
StatusCheck $?

echo Extracting Web Content
unzip /tmp/frontend.zip &>>$LOG_FILE
StatusCheck $?

mv frontend-main/static/* . &>>$LOG_FILE
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE

echo Starting Nginx Service
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
echo status = $?