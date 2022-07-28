source components/common.sh

echo "download MongoDB repo file"

curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo&>>$LOG_FILE

echo" Install MongoDB"
yum install -y mongodb.org &>>LOG_FILE

