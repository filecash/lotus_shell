#!/bin/bash

unset all_proxy http_proxy https_proxy

# ENV_LOG_DIR  *.sh
export ENV_LOG_DIR=$(cd `dirname $0`; pwd)
if [ ! -d $ENV_LOG_DIR ]; then
  mkdir -p $ENV_LOG_DIR
fi

unset ENV_LOTUS_BIN  ENV_LOTUS_ROOT  ENV_LOTUS_NetWORK  ENV_SECTOR_SIZE  ENV_LOTUS_WORKER_PORT  ENV_LOG_LEVEL
# ENV_LOTUS_BIN  ENV_LOTUS_ROOT  ENV_LOTUS_NetWORK  ENV_SECTOR_SIZE  ENV_LOTUS_WORKER_PORT  ENV_LOG_LEVEL
source $ENV_LOG_DIR/env_lotus

# ENV_LOTUS_BIN  lotus lotus-miner lotus-worker  #export ENV_LOTUS_BIN=/usr/local/bin
if [ -z $ENV_LOTUS_BIN ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_BIN=/usr/local/bin   (default) \033[0m"
  
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
    # tips
    echo -e "\033[34m ENV_LOTUS_BIN=$lotus_bin \033[0m"
  done
  echo " "
fi
# ENV_LOTUS_ROOT  .lotus .lotusminer .lotusworker  #export ENV_LOTUS_ROOT=/mnt
if [ -z $ENV_LOTUS_ROOT ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_ROOT=/mnt   (default) \033[0m"
  
  while [ -z $lotus_root ]
  do
    #lotus_root
    while [ -z $lotus_root ]
    do
      read -e -p '  please input lotus_root:' lotus_root
      if [ -z $lotus_root ]; then
        lotus_root=/mnt
        #lotus_root=$(cd `dirname $0`; pwd)
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_ROOT=$lotus_root" >> $ENV_LOG_DIR/env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_ROOT=$lotus_root \033[0m"
  done
  echo " "
fi
# ENV_LOTUS_PATH  #export ENV_LOTUS_PATH=/mnt/lotus 
if [ -z $ENV_LOTUS_PATH ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_PATH=/mnt/lotus   (default) \033[0m"
  
  while [ -z $lotus_path ]
  do
    #lotus_path
    while [ -z $lotus_path ]
    do
      read -e -p '  please input lotus_path:' lotus_path
      if [ -z $lotus_path ]; then
        lotus_path=/mnt/lotus
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_PATH=$lotus_path" >> $ENV_LOG_DIR/env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_PATH=$lotus_path \033[0m"
  done
  echo " "
fi
# LOTUS_MINER_PATH  #export LOTUS_MINER_PATH=/mnt/miner 
if [ -z $ENV_LOTUS_MINER_PATH ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_MINER_PATH=/mnt/miner   (default) \033[0m"
  
  while [ -z $lotus_miner_path ]
  do
    #lotus_miner_path
    while [ -z $lotus_miner_path ]
    do
      read -e -p '  please input lotus_miner_path:' lotus_miner_path
      if [ -z $lotus_miner_path ]; then
        lotus_miner_path=/mnt/miner
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_MINER_PATH=$lotus_miner_path" >> $ENV_LOG_DIR/env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_MINER_PATH=$lotus_miner_path \033[0m"
  done
  echo " "
fi
# LOTUS_WORKER_PATH  #export LOTUS_WORKER_PATH=/mnt/worker 
if [ -z $ENV_LOTUS_WORKER_PATH ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_WORKER_PATH=/mnt/worker   (default) \033[0m"
  
  while [ -z $lotus_worker_path ]
  do
    #lotus_worker_path
    while [ -z $lotus_worker_path ]
    do
      read -e -p '  please input lotus_worker_path:' lotus_worker_path
      if [ -z $lotus_worker_path ]; then
        lotus_worker_path=/mnt/worker
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_WORKER_PATH=$lotus_worker_path" >> $ENV_LOG_DIR/env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_WORKER_PATH=$lotus_worker_path \033[0m"
  done
  echo " "
fi
# ENV_LOTUS_PROOFS_PATH  #export LOTUS_PROOFS_PATH=/mnt/proofs 
if [ -z $ENV_LOTUS_PROOFS_PATH ]; then
  # tips
  echo -e "\033[34m ENV_LOTUS_PROOFS_PATH=/mnt/proofs   (default) \033[0m"
  
  while [ -z $lotus_proofs_path ]
  do
    #lotus_proofs_path
    while [ -z $lotus_proofs_path ]
    do
      read -e -p '  please input lotus_proofs_path:' lotus_proofs_path
      if [ -z $lotus_proofs_path ]; then
        lotus_proofs_path=/mnt/worker
      fi
    done
    #echo ' '
    echo "export ENV_LOTUS_PROOFS_PATH=$lotus_proofs_path" >> $ENV_LOG_DIR/env_lotus
    # tips
    echo -e "\033[34m ENV_LOTUS_PROOFS_PATH=$lotus_proofs_path \033[0m"
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
    2 - filestar
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
      elif [ $lotus_network -eq 2 ]; then  #filestar
        echo "export ENV_LOTUS_NetWORK=filestar" >> $ENV_LOG_DIR/env_lotus
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
# ENV_LOG_LEVEL  #export ENV_LOG_LEVEL=info #trace/debug/info/warn/error/fatal/off
if [ -z $ENV_LOG_LEVEL ]; then
  while [ -z $log_level ]
  do
    echo -e "\033[34m 
  Select log_level:      [`hostname`]  $localip
    
    0 - trace
    1 - debug
    2 - info
    3 - warn (default)
    4 - error
    5 - fatal
    6 - off
    \033[0m"
    read -e -p "  please input log_level:" log_level
    if [ -z $log_level ]; then
      log_level=3
    fi

    if [ -z $log_level ]; then
      unset log_level
    elif echo $log_level |grep -q '[^0-9]'; then
      unset log_level
    elif [ $log_level -le 0 ] && [ $log_level -ge 2 ]; then
      unset log_level
    else
      if [ $log_level -eq 0 ]; then    #trace
        echo "export ENV_LOG_LEVEL=trace" >> $ENV_LOG_DIR/env_lotus
      elif [ $log_level -eq 1 ]; then  #debug
        echo "export ENV_LOG_LEVEL=debug"   >> $ENV_LOG_DIR/env_lotus
      elif [ $log_level -eq 2 ]; then  #info
        echo "export ENV_LOG_LEVEL=info"  >> $ENV_LOG_DIR/env_lotus
      elif [ $log_level -eq 3 ]; then  #warn (default)
        echo "export ENV_LOG_LEVEL=warn"  >> $ENV_LOG_DIR/env_lotus
      elif [ $log_level -eq 4 ]; then  #error
        echo "export ENV_LOG_LEVEL=error"  >> $ENV_LOG_DIR/env_lotus
      elif [ $log_level -eq 5 ]; then  #fatal
        echo "export ENV_LOG_LEVEL=fatal"  >> $ENV_LOG_DIR/env_lotus
      elif [ $log_level -eq 6 ]; then  #off
        echo "export ENV_LOG_LEVEL=off"  >> $ENV_LOG_DIR/env_lotus
      else
        echo -e "\033[31m Input error \033[0m"
      fi
    fi
    #echo ' '
  done
  echo " "
fi

export LOTUS_PATH=$ENV_LOTUS_ROOT/lotus
export LOTUS_MINER_PATH=$ENV_LOTUS_ROOT/miner
export LOTUS_WORKER_PATH=$ENV_LOTUS_ROOT/worker

# ENV_LOTUS_BIN  ENV_LOTUS_ROOT  ENV_LOTUS_NetWORK  ENV_SECTOR_SIZE  ENV_LOTUS_WORKER_PORT 
source $ENV_LOG_DIR/env_lotus
export PATH="${ENV_LOTUS_BIN}:/usr/local/go/bin:${HOME}/go/bin:${HOME}/.cargo/bin:${HOME}/.bin:${PATH}"

# exe
export EXE_LOTUS=lotus
export EXE_LOTUS_MINER=lotus-miner
export EXE_LOTUS_WORKER=lotus-worker
export EXE_LOTUS_SHED=lotus-shed
export EXE_LOTUS_SEED=lotus-seed
export EXE_LOTUS_BENCH=lotus-bench
export EXE_LOTUS_FOUNTAIN=lotus-fountain

# rust log 
export RUST_BACKTRACE=full
export RUST_LOG=$ENV_LOG_LEVEL
# go log 
export GOLOG_LOG_LEVEL=$ENV_LOG_LEVEL


# gpu_num
check_gpu_num
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
export FIL_PROOFS_MULTICORE_SDR_PRODUCERS=1 #lscpu -e | grep ':0   '
#export FIL_PROOFS_SDR_PARENTS_CACHE_SIZE=1073741824
#export FIL_PROOFS_PARENT_CACHE_SIZE=1073741824

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
export TMPDIR=$ENV_LOTUS_ROOT/tmp
export CIRCLE_ARTIFACTS=$TMPDIR
export FIL_PROOFS_PARENT_CACHE=$ENV_LOTUS_ROOT/proofs_parent_cache
export FIL_PROOFS_PARAMETER_CACHE=$ENV_LOTUS_ROOT/proofs

if [ ! -z $ENV_LOTUS_MINER_PATH ]; then 
  export LOTUS_PATH=$ENV_LOTUS_PATH
fi
if [ ! -z $ENV_LOTUS_MINER_PATH ]; then 
  export LOTUS_MINER_PATH=$ENV_LOTUS_MINER_PATH
fi
if [ ! -z $ENV_LOTUS_WORKER_PATH ]; then 
  export LOTUS_WORKER_PATH=$ENV_LOTUS_WORKER_PATH
fi
if [ ! -z $ENV_LOTUS_PROOFS_PATH ]; then 
  export FIL_PROOFS_PARAMETER_CACHE=$ENV_LOTUS_PROOFS_PATH
fi

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
echo -e "\033[44;37m                                                       -- Powered  by  filecash            \033[0m"
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
  export IPFS_GATEWAY="https://proofs.file.cash/ipfs/"
elif [[ "$ENV_LOTUS_NetWORK" == "filestar" ]]; then
  export IPFS_GATEWAY="https://filestar-proofs.s3.cn-east-1.jdcloud-oss.com/ipfs/"
else
  unset IPFS_GATEWAY
fi
