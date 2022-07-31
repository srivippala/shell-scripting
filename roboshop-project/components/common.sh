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