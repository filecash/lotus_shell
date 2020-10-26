#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


if [ -z $1 ]; then ## run

  exist_num=`ls -lh $LOTUS_MINER_PATH |wc -l`
  if [ $exist_num -eq 3 ]; then
    # tips
    echo -e "\033[31m $LOTUS_MINER_PATH/api already exists. \033[0m"
    echo " "
    exit 1
  fi

  check_pid_exist "${EXE_LOTUS_MINER} run"
  if [ $pid -le 0 ]; then
    # log
    export marklog="miner-$ENV_SECTOR_SIZE.log"
    # backup log
    if [ -f "$marklog" ]; then 
      mv $marklog $marklog.$localip.$marktime.log
    fi

    # tips
    echo -e "\033[34m nohup ${EXE_LOTUS_MINER} run > $marklog 2>&1 & \033[0m"

    nohup ${EXE_LOTUS_MINER} run > $marklog 2>&1 &
  else
    # tips
    echo -e "\033[31m ${EXE_LOTUS_MINER} run is exist. \033[0m"
  fi
  echo " "
elif [ "$1" == "kill" ]; then ## stop
  check_pid_exist "${EXE_LOTUS_MINER} run"
  if [ $pid -eq 1 ]; then
    # log
    export marklog="miner-$ENV_SECTOR_SIZE.log"

    # tips
    echo -e "\033[34m nohup ${EXE_LOTUS_MINER} stop >> $marklog 2>&1 & \033[0m"

    nohup ${EXE_LOTUS_MINER} stop >> $marklog 2>&1 &
  else
    # tips
    echo -e "\033[31m ${EXE_LOTUS_MINER} run is not exist. \033[0m"
  fi
  echo " "
elif [ "$1" == "store" ]; then ## storage attach --store
  if [ -f "$LOTUS_MINER_STORE_PATH/sectorstore.json" ]; then
    echo -e "\033[31m ERROR: \033[0m\033[34m $LOTUS_MINER_STORE_PATH is already initialized. \033[0m"
    exit
  fi

  if [ ! -d $LOTUS_MINER_STORE_PATH ]; then
    mkdir -p $LOTUS_MINER_STORE_PATH
  fi

  # fix $LOTUS_MINER_PATH/sectorstore.json
  num=`grep -i "\"CanStore\": false" $LOTUS_MINER_PATH/sectorstore.json |awk '{print length($0)}'`
  if [ -z $num ]; then
    sed -i "s/\"CanStore\": true/\"CanStore\": false/g"  $LOTUS_MINER_PATH/sectorstore.json
  fi

  check_pid_exist "${EXE_LOTUS_MINER} storage"
  if [ $pid -le 0 ]; then
    # tips
    echo -e "\033[34m ${EXE_LOTUS_MINER} storage attach --store --weight=10 --init $LOTUS_MINER_STORE_PATH \033[0m"

    ${EXE_LOTUS_MINER} storage attach --store --weight=10 --init $LOTUS_MINER_STORE_PATH

    # log
    export marklog="miner-$ENV_SECTOR_SIZE.log"

    # tips
    echo -e "\033[34m nohup ${EXE_LOTUS_MINER} stop >> $marklog 2>&1 & \033[0m"

    nohup ${EXE_LOTUS_MINER} stop >> $marklog 2>&1 &
  else
    # tips
    echo -e "\033[31m ${EXE_LOTUS_MINER} storage is exist. \033[0m"
  fi
  echo " "
fi
echo " "
