#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


check_pid_exist "${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT"
if [ $pid -eq 1 ]; then

  # log
  export marklog="worker-$ENV_SECTOR_SIZE.log"

  # tips
  echo -e "\033[34m pid=`ps aux |grep "${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT" |grep -v grep |awk '{print \$2}'`;kill -9 $pid; \033[0m"

  pid=`ps aux |grep "${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT" |grep -v grep |awk '{print \$2}'`;kill -9 $pid;

else
  # tips
  echo -e "\033[31m ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT is not exist. \033[0m"
fi
echo " "
