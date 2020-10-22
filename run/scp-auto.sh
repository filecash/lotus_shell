#!/bin/bash

des_pass="password"

#rm -rf /usr/local/bin/pause
if [ ! -f "/usr/local/bin/pause" ]; then 
  sudo echo "#! /bin/bash
  get_char()
  {
    SAVEDSTTY=\`stty -g\` 
    stty -echo 
    stty raw 
    dd if=/dev/tty bs=1 count=1 2> /dev/null 
    stty -raw 
    stty echo 
    stty \$SAVEDSTTY 
  }
  if [ -z '$1' ]; then 
    echo ' ' 
    echo -e '\033[34m Please press any key to continue... \033[0m' 
    echo ' ' 
  else
    echo -e '$1' 
  fi
  get_char
  " > /usr/local/bin/pause
  
  sudo chmod 0755 /usr/local/bin/pause
fi

check_expect() {
  RESULT=$(expect -v)
  RESULT=${RESULT:15:5}
  #echo $RESULT
  if [ -z $RESULT ] || [ `expr $RESULT \> 5.0` -eq 0 ]; then
    echo "expect version must > 5.0 . "
    # expect install
    sudo apt install expect -y
    # check
    expect -v
  fi
  return 1
}

while true
do
  #init
  check_expect
  
  #file
  echo " "
  while [[ -z $path ]]
  do
    echo -e "\033[34m 
    Select path:      [`hostname`]  $localip
      
      0 - /usr/local/bin/lotus*
      1 - /mnt/lotus/api /mnt/lotus/token
      2 - /mnt/miner/api /mnt/miner/token
      3 - /mnt/proofs/v*
      4 - /mnt/logs/*.sh
      5 - ~/.ssh/authorized_keys
      6 - ~/.ssh/id_rsa

      \033[0m "

    while [[ -z $path ]]
    do
      read -e -p "  scp path:" method
      if  [ ! -n "$method" ] && [ -n "$path_old" ]; then
        method=$path_old
      fi
      if echo $method |grep -q '[^0-9]'; then
        path=$method
      else 
        if [ -z $method ]; then
          unset path
        elif [ $method -eq 0 ]; then 
          path='/usr/local/bin/lotus*'
        elif [ $method -eq 1 ]; then 
          cat /mnt/lotus/api
          path='/mnt/lotus/api /mnt/lotus/token'
        elif [ $method -eq 2 ]; then 
          cat /mnt/miner/api
          path='/mnt/miner/api /mnt/miner/token'
        elif [ $method -eq 3 ]; then 
          path='/mnt/proofs/v*'
        elif [ $method -eq 4 ]; then 
          path='/mnt/logs/*.sh'
        elif [ $method -eq 5 ]; then 
          path='~/.ssh/authorized_keys'
        elif [ $method -eq 6 ]; then 
          path='~/.ssh/id_rsa'
        else
          echo "Input error"
        fi
      fi
    done
    echo " "
  done
  echo " "
  
  # 多文件拷贝还是单文件拷贝
  if [ "${path##*/}" == "*" ] || [ "${path:0-1}" == "/" ]; then
    argu="-r"
  else
    unset argu
  fi
  
  # 获取拷贝目录
  topath="${path%/*}" #获取目录
  if [ "$topath" == "$path" ] || [ "$topath" == "*" ]; then
    topath=`pwd`
  fi
  srcfile=$topath/"${path##*/}"
  #echo "${path%/*}".$topath.$srcfile
  
  # 显示符合条件文件
  ls -lhrt $srcfile
  
  host=192.168.
  echo " "
  if [ -z $segment ]; then 
    #read -e -r -p  "  输入执行网段:" segment
    while [ -z $segment ]
    do
      read -e -p "  please input ip segment: " segment
      if [ -z $segment ]; then
        segment=`ip addr show |awk -F '[ /]+' '$0~/inet/ && $0~/brd/ {print $3}' |awk -F "." '{print $3}'`
      elif echo $segment |grep -q '[^0-9]'; then
        unset segment
      elif [ $segment -le 0 ] && [ $segment -ge 255 ]; then
        unset segment
      fi
    done
  fi
  echo " "
  #read -e -r -p  "  输入起始主机:" start
  #read -e -r -p  "  输入结束主机:" end
  while [ -z $start ]
  do
    read -e -p "  please input start ip: " start
    if [ -z $start ]; then
      unset start
    elif echo $start |grep -q '[^0-9]'; then
      unset start
    elif [ $start -le 0 ] && [ $start -ge 255 ]; then
      unset start
    fi
  done
  while [ -z $end ]
  do
    read -e -p "  please input  end ip: " end
    if [ -z $end ]; then
      end=$start
    elif echo $end |grep -q '[^0-9]'; then
      unset end
    elif [ $end -le 0 ] && [ $end -ge 255 ]; then
      unset end
    fi
  done
  echo " "
  for ((i=${start};i<=${end};i++))
  do
    echo -e "\033[34m 
--------------------------------------------------
------------- 执行到: ${host}${segment}.${i} -------------
-------------------------------------------------- \033[0m"
    ping -c1 -w5 ${host}${segment}.${i} > /dev/null
    if (($? == 0)); then
    {
      # tips
      echo -e "\033[34m  scp $argu $srcfile ${host}${segment}.${i}:$topath/ \033[0m"
      
      expect -c "
spawn bash -c \"scp $argu $srcfile ${host}${segment}.${i}:$topath/ \"
expect {
\"*assword\" {set timeout 300; send \"${des_pass}\r\";}
\"yes/no\" {send \"yes\r\"; exp_continue;}
}
"
    }
    else
    {
      echo -e "\033[31m 
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \033[0m\033[34m scp $argu $srcfile ${host}${segment}.${i}:$topath/ \033[0m\033[31m
    ------------- 失败主机: ${host}${segment}.${i} -------------
    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \033[0m"
    }
    fi
  done
  
  path_old="$path"
  echo " "
  pause && unset path start end
  
done
