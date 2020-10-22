#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


if [ ! -d $LOTUS_WORKER_PATH ]; then
  mkdir -p $LOTUS_WORKER_PATH
fi

# huge_argu
huge_num=`cat /proc/meminfo | grep HugePages_Total | awk -F ":" '{print $2}' | sed -e 's/^[ ]*//g' | sed -e 's/[ ]*\$//g'`
if [ $huge_num -gt 0 ]; then
  export RUST_FIC_OPTION_HUGEPAGE=1
  huge_argu="--hugepage=$huge_num"
  # tips
  echo -e "\033[34m HugePages is opened. $huge_num \033[0m"
else
  export RUST_FIC_OPTION_HUGEPAGE=0
  # tips
  echo -e "\033[31m HugePages is closed. $huge_num \033[0m"
fi
echo " "

# gpu_num
gpu_num=`nvidia-smi -q |grep 'Product Name' |awk -F : '{print $2}'|wc -l`
if [ $gpu_num -eq 0 ]; then
  # tips
  echo -e "\033[31m GPU not detected. $num \033[0m"

  export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=0
  export FIL_PROOFS_USE_GPU_TREE_BUILDER=0
  nogpu="-nogpu"
fi

# log
export marklog="bench-$ENV_SECTOR_SIZE$nogpu-all.log"
# backup log
if [ -f "$marklog" ]; then 
  mv $marklog $marklog.$localip.$marktime.log
fi

# tips
echo -e "\033[34m nohup ${EXE_LOTUS_BENCH} sealing --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH $huge_argu > $marklog 2>&1 & \033[0m"

nohup ${EXE_LOTUS_BENCH} sealing --sector-size=$ENV_SECTOR_SIZE --storage-dir=$LOTUS_BENCH_PATH $huge_argu > $marklog 2>&1 &
echo " "
