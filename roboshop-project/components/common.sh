LOG_FILE=/tmp/roboshop.log

#when we run multiple times, to remove the old output we are using below command
rm -f $LOG_FILE

stat()
{
  if [ $1 -eq 0 ]; then
    echo -e "\e[1;32m success \e[0m"
  else
    echo -e "\e[1,31m failed \e[0m"
    exit 2
  fi
}


NODEJS()
{
component=$1
echo "Setup NodeJS Repo"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE
stat $?

echo "Install NodeJS"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
stat $?

echo "Create App User"
id roboshop &>>$LOG_FILE
if [ $? -ne 0 ]; then
useradd roboshop &>>$LOG_FILE
fi
stat $?

echo "Download ${component} code"
curl -s -L -o /tmp/${component}.zip "https://github.com/roboshop-devops-project/${component}/archive/main.zip" &>>$LOG_FILE
stat $?

echo "Extract ${component} Code"
cd /tmp/
unzip -o ${component}.zip &>>$LOG_FILE
stat $?

echo "Clean Old COntent"
rm -rf /home/roboshop/${component}
stat $?

echo "Copy user COntent"
cp -r ${component}-main /home/roboshop/${component} &>>$LOG_FILE
stat $?

echo "Install NodeJs Dependencies"
cd /home/roboshop/${component}
npm install &>>$LOG_FILE
stat $?

chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE
stat $?

echo "Update ${component} Systemd file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' -e 's/CARTHOST/cart.roboshop.internal/' -e 's/USERHOST/user.roboshop.internal/' -e 's/AMQPHOST/rabbitmq.roboshop.internal/' -e 's/RABBITMQ-IP/rabbitmq.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG_FILE

echo "setup ${component} SystemD  file"
 mv /home/roboshop/${component}/systemd.service  /etc/systemd/system/${components}.service &>>$LOG_FILE
stat $?

echo "Start ${component}"
systemctl daemon-reload &>>$LOG_FILE
systemctl enable ${component} &>>$LOG_FILE
systemctl restart ${component} &>>$LOG_FILE
stat $?
}