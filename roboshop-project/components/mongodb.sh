source components/common.sh

echo "download MongoDB repo file"

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo&>>$LOG_FILE

echo "Install MongoDB"
yum install -y mongodb-org &>>LOG_FILE
stat $?

echo "Update MongoDB Config File"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
stat $?

echo "Start Database"
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
stat $?

echo "Download Schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
stat $?

echo "Extract Schema"
cd /tmp/
unzip -o mongodb.zip &>>$LOG_FILE
stat $?

echo "Load Schema"
cd mongodb-main
mongo < catalogue.js &>>$LOG_FILE
mongo < users.js &>>LOG_FILE
stat $?

