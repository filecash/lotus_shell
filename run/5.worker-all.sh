#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


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

# commit_argu
#export FFI_REMOTE_COMMIT2=true
#export FFI_REMOTE_COMMIT2_BASE_URL=$localip:$ENV_LOTUS_WORKER_PORT

# max_argu
if [ ! -z $1 ]; then 
  max_argu=$1
else
  max_num=`lotus-worker run -h|grep precommit1max|wc -l`
  if (($max_num == 1)); then
    diskAvailable_mb=`df -m $LOTUS_WORKER_PATH |awk 'NR==2{print $4}'`  ## MiB
    diskAvailable_gb=`expr $diskAvailable_mb / 1024`  ## GiB
    task_num=`expr $diskAvailable_gb / 60`  ## task_number
    
    max_argu="--precommit1max=$task_num"
  fi
fi

check_pid_exist "${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT"
if [ $pid -le 0 ]; then
  
  # gpu_num
  gpu_num=`nvidia-smi -q |grep 'Product Name' |awk -F : '{print $2}'|wc -l`
  if [ $gpu_num -eq 0 ]; then
    # tips
    echo -e "\033[31m GPU not detected. $num \033[0m"

    export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=0
    export FIL_PROOFS_USE_GPU_TREE_BUILDER=0
    nogpu="-nogpu"
  else
    for ((i=0;i<${gpu_num};i++))
    do
    {
      if [ $i -eq 0 ]; then
        gpu_argu="${i}"
      else
        gpu_argu="${gpu_argu},${i}"
      fi
    }
    done
    export RUST_FIC_OPTION_1=$gpu_argu
  fi

  # log
  export marklog="worker-$ENV_SECTOR_SIZE$nogpu-all.log"
  # backup log
  if [ -f "$marklog" ]; then 
    mv $marklog $marklog.$localip.$marktime.log
  fi
  
  # tips
  echo -e "\033[34m nohup ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT $max_argu $huge_argu > $marklog 2>&1 & \033[0m"

  nohup ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT $max_argu $huge_argu > $marklog 2>&1 &
else
  # tips
  echo -e "\033[31m ${EXE_LOTUS_WORKER} run --listen=$localip:$ENV_LOTUS_WORKER_PORT is exist. \033[0m"
fi
echo " "
