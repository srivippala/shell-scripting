source components/common.sh

echo "Configuring redis repo"
 curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
 stat $?

 echo "Installing redis"
yum install redis -y &>>$LOG_FILE
stat $?

echo "Update redis configuration"
if [ -f /etc/redis.conf ]; then
sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf
elif [ -f /etc/redis/redis.conf ]; then
 sed -i -e "s/127.0.0.1/0.0.0.0/g" /etc/redis.conf
 fi
stat $?

echo "start redis"
systemctl enable  redis  &>>$LOG_FILE
systemctl start redis &>>$LOG_FILE
stat $?
