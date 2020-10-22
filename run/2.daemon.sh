#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


if [ -z $1 ]; then ## daemon
  exist_num=`ls -lh $LOTUS_PATH |wc -l`
  if [ $exist_num -eq 3 ]; then
    # tips
    echo -e "\033[31m $LOTUS_PATH already exists. \033[0m"
    echo " "
    exit 1
  fi

  check_pid_exist "${EXE_LOTUS} daemon"
  if [ $pid -le 0 ]; then
    # log
    export marklog="daemon-all.log"
    # backup log
    if [ -f "$marklog" ]; then 
      mv $marklog $marklog.$localip.$marktime.log
    fi

    # tips
    echo -e "\033[34m nohup ${EXE_LOTUS} daemon > $marklog 2>&1 & \033[0m"

    nohup ${EXE_LOTUS} daemon > $marklog 2>&1 &
  else
    # tips
    echo -e "\033[31m ${EXE_LOTUS} daemon is exist. \033[0m"
  fi
  echo " "
else if [ "$1" == "kill" ]; then ## daemon stop
  check_pid_exist "${EXE_LOTUS} daemon"
  if [ $pid -eq 1 ]; then
    # log
    export marklog="daemon-all.log"

    # tips
    echo -e "\033[34m nohup ${EXE_LOTUS} daemon stop >> $marklog 2>&1 & \033[0m"

    nohup ${EXE_LOTUS} daemon stop >> $marklog 2>&1 &
  else
    # tips
    echo -e "\033[31m ${EXE_LOTUS} daemon is not exist. \033[0m"
  fi
  echo " "
fi
echo " "