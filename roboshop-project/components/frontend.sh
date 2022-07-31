source components/common.sh
echo "Installing Nginx"

yum install nginx -y &>>$LOG_FILE
stat $?

echo "Download frontend content"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
stat $?

#Stat is a function which declared in common.sh

echo "Clean Old Content"
rm -rf /usr/share/nginx/html/* $>>$LOG_FILE
stat $?

echo "Extract Frontend Content"
cd /tmp
unzip -o /tmp/frontend.zip $>>$LOG_FILE
stat $?

echo "Copy Extracted Content to Nginx Path"
cp -r frontend-main/static/* /usr/share/nginx/html/ &>>$LOG_FILE
stat $?

echo "Copy Nginx RoboShop Config"
cp frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
stat $?

echo "Start Nginx Service"
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx  &>>$LOG_FILE
stat $?