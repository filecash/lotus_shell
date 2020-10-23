#!/bin/bash

unset all_proxy http_proxy https_proxy
#export all_proxy=http://192.168.0.8:10809/
#export http_proxy=http://192.168.0.8:10809/
#export https_proxy=http://192.168.0.8:10809/

# ENV_LOG_DIR  *.sh
export ENV_LOG_DIR=$(cd `dirname $0`; pwd)
if [ ! -d $ENV_LOG_DIR ]; then
  mkdir -p $ENV_LOG_DIR
fi

# ENV_LOTUS_BIN  ENV_LOTUS_ROOT  ENV_LOTUS_NetWORK  ENV_SECTOR_SIZE  ENV_LOTUS_WORKER_PORT 
source $ENV_LOG_DIR/env_lotus

# ENV_LOTUS_BIN  lotus lotus-miner lotus-worker  #export ENV_LOTUS_BIN=/usr/local/bin
if [ -z $ENV_LOTUS_BIN ]; then
  while [ -z $lotus_bin ]
  do
    #lotus_bin
    while [ -z $lotus_bin ]
    do
      read -e -p '  please input lotus_bin:' lotus_bin
      if [ -z $lotus_bin ]; then
        lotus_bin=/usr/local/bin
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_BIN=$lotus_bin" >> $ENV_LOG_DIR/env_lotus
  done
  echo " "
fi
# ENV_LOTUS_ROOT  .lotus .lotusminer .lotusworker  #export ENV_LOTUS_ROOT=/mnt
if [ -z $ENV_LOTUS_ROOT ]; then
  while [ -z $lotus_root ]
  do
    #lotus_root
    while [ -z $lotus_root ]
    do
      read -e -p '  please input lotus_root:' lotus_root
      if [ -z $lotus_root ]; then
        #lotus_root=/mnt
        lotus_root=$(cd `dirname $0`; pwd)
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_ROOT=$lotus_root" >> $ENV_LOG_DIR/env_lotus
  done
  echo " "
fi
# ENV_LOTUS_NetWORK  #export ENV_LOTUS_NetWORK=filecoin
if [ -z $ENV_LOTUS_NetWORK ]; then
  while [ -z $lotus_network ]
  do
    echo -e "\033[34m 
  Select lotus_network:      [`hostname`]  $localip
    
    0 - filecoin (default)
    1 - filecash
    \033[0m"
    read -e -p "  please input lotus_network:" lotus_network
    if [ -z $lotus_network ]; then
      lotus_network=0
    fi

    if [ -z $lotus_network ]; then
      unset lotus_network
    elif echo $lotus_network |grep -q '[^0-9]'; then
      unset lotus_network
    elif [ $lotus_network -le 0 ] && [ $lotus_network -ge 2 ]; then
      unset lotus_network
    else
      if [ $lotus_network -eq 0 ]; then  #filecoin (default)
        echo "export ENV_LOTUS_NetWORK=filecoin" >> $ENV_LOG_DIR/env_lotus
      elif [ $lotus_network -eq 1 ]; then  #filecash
        echo "export ENV_LOTUS_NetWORK=filecash" >> $ENV_LOG_DIR/env_lotus
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    fi
  done
  echo " "
fi
# ENV_SECTOR_SIZE  #export ENV_SECTOR_SIZE=32GB
if [ -z $ENV_SECTOR_SIZE ]; then
  while [ -z $sector_size ]
  do
    echo -e "\033[34m 
  Select sector_size:      [`hostname`]  $localip
    
    0 - 512MiB
    1 - 4GiB
    2 - 16GiB
    3 - 32GiB (default)
    4 - 64GiB
    \033[0m"
    read -e -p "  please input sector_size:" sector_size
    if [ -z $sector_size ]; then
      sector_size=3
    fi

    if [ -z $sector_size ]; then
      unset sector_size
    elif echo $sector_size |grep -q '[^0-9]'; then
      unset sector_size
    elif [ $sector_size -le 0 ] && [ $sector_size -ge 2 ]; then
      unset sector_size
    else
      if [ $sector_size -eq 0 ]; then  #512M
        echo "export ENV_SECTOR_SIZE=512MiB" >> $ENV_LOG_DIR/env_lotus
      elif [ $sector_size -eq 1 ]; then  #4G
        echo "export ENV_SECTOR_SIZE=4GiB"   >> $ENV_LOG_DIR/env_lotus
      elif [ $sector_size -eq 2 ]; then  #16G
        echo "export ENV_SECTOR_SIZE=16GiB"  >> $ENV_LOG_DIR/env_lotus
      elif [ $sector_size -eq 3 ]; then  #32G (default)
        echo "export ENV_SECTOR_SIZE=32GiB"  >> $ENV_LOG_DIR/env_lotus
      elif [ $sector_size -eq 4 ]; then  #64G
        echo "export ENV_SECTOR_SIZE=64GiB"  >> $ENV_LOG_DIR/env_lotus
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    fi
  done
  echo " "
fi
# ENV_LOTUS_WORKER_PORT  #export ENV_LOTUS_WORKER_PORT=2222
if [ -z $ENV_LOTUS_WORKER_PORT ]; then
  while [ -z $lotus_worker_port ]
  do
    #lotus_worker_port
    while [ -z $lotus_worker_port ]
    do
      read -e -p '  please input lotus_worker_port:' lotus_worker_port
      if [ -z $lotus_worker_port ]; then
        lotus_worker_port=2222
      elif [ "$lotus_worker_port" -gt "$processor" ]; then
        unset lotus_worker_port
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_WORKER_PORT=$lotus_worker_port" >> $ENV_LOG_DIR/env_lotus
  done
  echo " "
fi

# ENV_LOTUS_BIN  ENV_LOTUS_ROOT  ENV_LOTUS_NetWORK  ENV_SECTOR_SIZE  ENV_LOTUS_WORKER_PORT 
source $ENV_LOG_DIR/env_lotus
export PATH="${ENV_LOTUS_BIN}:/usr/local/go/bin:${HOME}/go/bin:${HOME}/.cargo/bin:${HOME}/.bin:${PATH}"

# exe
export EXE_LOTUS=lotus
export EXE_LOTUS_MINER=lotus-miner
export EXE_LOTUS_WORKER=lotus-worker
export EXE_LOTUS_BENCH=lotus-bench
export EXE_LOTUS_SEED=lotus-seed
export EXE_LOTUS_FOUNTAIN=lotus-fountain

# log  all/trace/debug/info/warn/error/fatal/off
export RUST_BACKTRACE=full
export RUST_LOG=info
export GOLOG_LOG_LEVEL=info

# gpu_num
gpu_num=`nvidia-smi -q |grep 'Product Name' |awk -F : '{print $2}'|wc -l`
if [ $gpu_num -eq 0 ]; then
  # nogpu
  export BELLMAN_NO_GPU=1
  # tree_c
  unset FIL_PROOFS_USE_GPU_COLUMN_BUILDER
  # tree_r_last
  unset FIL_PROOFS_USE_GPU_TREE_BUILDER
else
  # gpu
  unset BELLMAN_NO_GPU
  # tree_c
  export FIL_PROOFS_USE_GPU_COLUMN_BUILDER=1
  # tree_r_last
  export FIL_PROOFS_USE_GPU_TREE_BUILDER=1

  # tree_c
  #export FIL_PROOFS_MAX_GPU_COLUMN_BATCH_SIZE=400000
  #export FIL_PROOFS_COLUMN_WRITE_BATCH_SIZE=262144
  # tree_r_last
  #export FIL_PROOFS_MAX_GPU_TREE_BATCH_SIZE=700000
fi

# multi sdr
export FIL_PROOFS_USE_MULTICORE_SDR=1
export FIL_PROOFS_SDR_PARENTS_CACHE_SIZE=2048
#export FIL_PROOFS_PARENT_CACHE_SIZE=2048

# speed or memory
export FIL_PROOFS_MAXIMIZE_CACHING=1
#unset FIL_PROOFS_MAXIMIZE_CACHING

# support small sector
#export FIL_USE_SMALL_SECTORS=true 
unset FIL_USE_SMALL_SECTORS

# lotus_env
export LOTUS_PATH=$ENV_LOTUS_ROOT/lotus
export LOTUS_MINER_PATH=$ENV_LOTUS_ROOT/miner
export LOTUS_WORKER_PATH=$ENV_LOTUS_ROOT/worker
export LOTUS_BENCH_PATH=$ENV_LOTUS_ROOT/bench
export LOTUS_MINER_STORE_PATH=$ENV_LOTUS_ROOT/miner_store
export CIRCLE_ARTIFACTS=$ENV_LOTUS_ROOT/tmp
export TMPDIR=$ENV_LOTUS_ROOT/tmp
export FIL_PROOFS_PARENT_CACHE=$ENV_LOTUS_ROOT/proofs_parent_cache
export FIL_PROOFS_PARAMETER_CACHE=$ENV_LOTUS_ROOT/proofs

if [ ! -d $LOTUS_PATH ]; then
  mkdir -p $LOTUS_PATH
fi
if [ ! -d $LOTUS_MINER_PATH ]; then
  mkdir -p $LOTUS_MINER_PATH
fi
if [ ! -d $LOTUS_WORKER_PATH ]; then
  mkdir -p $LOTUS_WORKER_PATH $LOTUS_WORKER_PATH/cache $LOTUS_WORKER_PATH/sealed $LOTUS_WORKER_PATH/unsealed
fi
if [ ! -d $TMPDIR ]; then
  mkdir -p $TMPDIR
fi
if [ ! -d $FIL_PROOFS_PARAMETER_CACHE ]; then
  mkdir -p $FIL_PROOFS_PARAMETER_CACHE
fi
if [ ! -d $FIL_PROOFS_PARENT_CACHE ]; then
  mkdir -p $FIL_PROOFS_PARENT_CACHE
fi

# source shell
source $ENV_LOG_DIR/common.sh

# banner
echo -e "\033[44;37m                                                                                           \033[0m"
echo -e "\033[44;37m                                     lotus shell                                           \033[0m"
echo -e "\033[44;37m                                                       -- Powered  by gongming             \033[0m"
echo -e "\033[44;37m                                                                                           \033[0m"
echo " "
echo -e "\033[31m TIPS:\033[0m\033[34m LOTUS_BIN is \033[0m\033[31m$ENV_LOTUS_BIN \033[0m"
echo -e "\033[31m TIPS:\033[0m\033[34m LOTUS_ROOT is \033[0m\033[31m$ENV_LOTUS_ROOT \033[0m"
echo -e "\033[31m TIPS:\033[0m\033[34m SECTOR_SIZE is \033[0m\033[31m$ENV_SECTOR_SIZE \033[0m"
echo -e "\033[31m TIPS:\033[0m\033[34m LOTUS_NetWORK is \033[0m\033[31m$ENV_LOTUS_NetWORK \033[0m"
echo " "

if [ -z $ENV_LOTUS_ROOT ]; then
  echo -e "\033[31m TIPS: LOTUS_ROOT is empty. \033[0m"
  pause
fi

if [ -z $ENV_SECTOR_SIZE ]; then
  echo -e "\033[31m TIPS: SECTOR_SIZE is empty. \033[0m"
  pause
fi

if [ -z $ENV_LOTUS_NetWORK ]; then
  echo -e "\033[31m TIPS: LOTUS_NetWORK is empty. \033[0m"
  pause
elif [[ "$ENV_LOTUS_NetWORK" == "filecoin" ]]; then
  export IPFS_GATEWAY="https://proof-parameters.s3.cn-south-1.jdcloud-oss.com/ipfs/"
elif [[ "$ENV_LOTUS_NetWORK" == "filecash" ]]; then
  unset IPFS_GATEWAY
fi
