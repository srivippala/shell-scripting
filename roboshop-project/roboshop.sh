#!/bin/bash

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo -e "\[1,31m you should be root user to perform this..\e[0m"
  exit 1
fi

if [ -f components/$1.sh ]; then
bash components/$1.sh

else
  echo -e "\e[1,31minvalid input\e[0m"
  echo -e "\e[1,33mAvailable inputs - frontend|mongodb|catalogue|redis|user|cart|mysql|shipping|payment|rabbitmq|dispatch\e[0m"
  exit 1
fi