#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


# commit_argu
#export FFI_REMOTE_COMMIT2=true
#export FFI_REMOTE_COMMIT2_BASE_URL=$localip:$ENV_LOTUS_WORKER_PORT

check_pid_exist "${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT"
if [ $pid -le 0 ]; then
  
  # log
  export marklog="worker-$ENV_SECTOR_SIZE-ap.log"
  # backup log
  if [ -f "$marklog" ]; then 
    mv $marklog $marklog.$localip.$marktime.log
  fi

  # tips
  echo -e "\033[34m nohup ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT --precommit1=false --precommit2=false --commit=false > $marklog 2>&1 & \033[0m"

  nohup ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT --precommit1=false --precommit2=false --commit=false > $marklog 2>&1 &
else
  # tips
  echo -e "\033[31m ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT is exist. \033[0m"
fi
echo " "
