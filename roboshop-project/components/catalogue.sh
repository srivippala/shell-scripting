source components/common.sh

echo "Setup NodeJS Repo"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOG_FILE

echo "Install NodeJS"
yum install nodejs -y &>>$LOG_FILE

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
cp -r catalogue-main /home/roboshop/catalogue

echo "Install NodeJs Dependencies"
cd /home/roboshop/catalogue
npm install &>>$LOG_FILE

chown roboshop:roboshop /home/roboshop/ -R
