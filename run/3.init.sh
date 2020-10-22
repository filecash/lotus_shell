#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


#owner=`${EXE_LOTUS} wallet list |grep -E "t3|f3" |awk 'NR==1 {print $1}'`
owner=`${EXE_LOTUS} wallet default`
balance=`${EXE_LOTUS} wallet balance |awk '{print $1}' |awk -F "." '{print $1}'`
if [ -z $owner ]; then
  # tips
  echo -e "\033[34m ${EXE_LOTUS} wallet new bls \033[0m"
  ${EXE_LOTUS} wallet new bls

  # tips
  #echo -e "\033[34m ${EXE_LOTUS} wallet list |grep -E "t3|f3" |awk 'NR==1 {print $1}' \033[0m"
  #owner=`${EXE_LOTUS} wallet list |grep -E "t3|f3" |awk 'NR==1 {print $1}'`
  echo -e "\033[34m ${EXE_LOTUS} wallet default' \033[0m"
  owner=`${EXE_LOTUS} wallet default`
  # tips
  echo -e "\033[34m ${EXE_LOTUS} wallet balance \033[0m"
  balance=`${EXE_LOTUS} wallet balance |awk '{print $1}' |awk -F "." '{print $1}'`
  if [ -z $balance ] || [ `expr $balance \> 100` -eq 0 ]; then
    # tips
    echo -e "\033[34m ${EXE_LOTUS} wallet balance must > 100 FIL \033[0m"
    exit 1
  fi
fi

read -e -p "  owner is $owner , please input actor ID:" actor
echo ' '
#echo  $actor  $owner

check_pid_exist "${EXE_LOTUS_MINER} init"
if [ $pid -le 0 ]; then
  if [ ! -z $owner ]; then
    # log
    export marklog="init-$ENV_SECTOR_SIZE.log"
    # backup log
    if [ -f "$marklog" ]; then 
      mv $marklog $marklog.$localip.$marktime.log
    fi
    
    if [ -d $LOTUS_MINER_PATH/config.toml ]; then 
      # tips
      echo -e "\033[34m $LOTUS_MINER_PATH already initialized, Please delete the files manually and try again. \033[0m"
      
      exit 1
    fi

    if [ -z $actor ]; then 
      # tips
      echo -e "\033[34m nohup ${EXE_LOTUS_MINER} init --owner=$owner --sector-size=$ENV_SECTOR_SIZE > $marklog 2>&1 & \033[0m"

      nohup ${EXE_LOTUS_MINER} init --owner=$owner --sector-size=$ENV_SECTOR_SIZE > $marklog 2>&1 &
      
      # backup wallet
      ${EXE_LOTUS} wallet export $owner > ./new-$owner-$ENV_SECTOR_SIZE.wallet
    else
      # tips
      echo -e "\033[34m nohup ${EXE_LOTUS_MINER} init --actor=$actor --owner=$owner --sector-size=$ENV_SECTOR_SIZE > $marklog 2>&1 & \033[0m"

      nohup ${EXE_LOTUS_MINER} init --actor=$actor --owner=$owner --sector-size=$ENV_SECTOR_SIZE > $marklog 2>&1 &
      
      # backup wallet
      ${EXE_LOTUS} wallet export $owner > ./$actor-$ENV_SECTOR_SIZE.wallet
    fi
  fi
else
  # tips
  echo -e "\033[31m ${EXE_LOTUS_MINER} init is exist. \033[0m"
fi
echo " "
