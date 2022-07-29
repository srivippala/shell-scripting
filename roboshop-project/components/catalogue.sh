source components/common.sh

echo "Setup NodeJS Repo"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>$LOG_FILE

echo "Install NodeJS"
yum install nodejs gcc-c++ -y &>>$LOG_FILE

echo "Create App User"
useradd roboshop &>>$LOG_FILE

echo "Download catalogue code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE

echo "Extract Catalogue Code"
cd /tmp/
unzip -o catalogue.zip &>>$LOG_FILE


echo "Clean Old COntent"
rm -rf /home/roboshop/catalogue

echo "Copy Catalogue COntent"
cp -r catalogue-main /home/roboshop/catalogue &>>$LOG_FILE

echo "Install NodeJs Dependencies"
cd /home/roboshop/catalogue
npm install &>>$LOG_FILE

chown roboshop:roboshop /home/roboshop/ -R &>>$LOG_FILE

echo "Update Systemd file"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/'
/home/roboshop/catalogue/systemd.service &>>$LOG_FILE

echo "setup Catalogue SystemD  file"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>$LOG_FILE

echo "Start catalogue"
systemctl daemon-reload &>>$LOG_FILE
systemctl enable catalogue &>>$LOG_FILE
systemctl start catalogue &>>$LOG_FILE