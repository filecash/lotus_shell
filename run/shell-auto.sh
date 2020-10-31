#!/bin/bash

des_pass="password"

source $ENV_LOG_DIR/env_lotus

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

while true
do
  while [[ -z $cmd ]]
  do
    echo -e "\033[34m 
    Select method:      [`hostname`]  $localip
      
      0 - lspci |grep -i vga
      1 - nvidia-smi -q |grep 'Product Name' |awk -F : '{print \$2}'
      2 - ls -lhrt $ENV_LOTUS_BIN
      3 - ls -lhrt $ENV_LOTUS_ROOT/worker/cache
      4 - df -h $ENV_LOTUS_ROOT/worker;du -sh $ENV_LOTUS_ROOT/worker
      5 - /bin/bash $ENV_LOTUS_ROOT/logs/5.worker-ap.sh
      6 - /bin/bash $ENV_LOTUS_ROOT/logs/5.worker-p1.sh
      7 - /bin/bash $ENV_LOTUS_ROOT/logs/5.worker-p2c.sh
      8 - ps aux |grep lotus |grep -v grep
      9 - pid=\`ps aux |grep lotus |grep -v grep |awk '{print \$2}'\`;kill -9 \$pid;
      
      # Clean Sectors
        rm -rf $ENV_LOTUS_ROOT/worker/*/s-t*-*; rm -rf $ENV_LOTUS_ROOT/miner/*/s-t*-*
      # Clean All Data
        rm -rf $ENV_LOTUS_ROOT/lotus/*; rm -rf $ENV_LOTUS_ROOT/miner/*; rm -rf $ENV_LOTUS_ROOT/worker/*; rm -rf $ENV_LOTUS_BIN/lotus*

      # password
        echo root:password | chpasswd
      # Board
        sudo dmidecode -t 2
      # BIOS
        sudo dmidecode -t 0
      # CPU
        echo \"\`sudo dmidecode -t 4 |grep 'Version' |awk -F : 'NR==1{print \$2}'| sed -e 's/^[ ]*//g' | sed -e 's/[ ]*\$//g'\` \`sudo dmidecode -t 4 |grep 'Current Speed' |awk -F : 'NR==1{print \$2}'| sed -e 's/^[ ]*//g' | sed -e 's/[ ]*\$//g'\` \"
        echo \"\`sudo dmidecode -t 4 |grep 'Thread Count' |awk -F : 'NR==1{print \$2}'| sed -e 's/^[ ]*//g' | sed -e 's/[ ]*\$//g'\` * \`grep 'physical id' /proc/cpuinfo |sort |uniq |wc -l\` = \`grep 'processor' /proc/cpuinfo |sort |uniq |wc -l\` \"
      # MEM
        echo \"\`free -g |grep 'Mem' |awk '{print \$2}'\`GB \`sudo dmidecode -t memory |grep 'Type:' |awk 'NR==3{print \$2}'\` \`sudo dmidecode -t memory |grep 'Speed:' |awk 'NR==3{print \$2}\` \"

      \033[0m "

    while [[ -z $cmd ]]
    do
      read -e -r -p "  Input command:" method
      if  [ ! -n "$method" ] && [ -n "$method_old" ]; then
        method=$method_old
      fi
      if echo $method |grep -q '[^0-9]'; then
        cmd=$method
      else 
        if [ -z $method ]; then
          unset cmd
        elif [ $method -eq 0 ]; then 
          cmd='lspci |grep -i vga'
        elif [ $method -eq 1 ]; then 
          cmd="nvidia-smi -q |grep 'Product Name' "
        elif [ $method -eq 2 ]; then 
          cmd='ls -lhrt $ENV_LOTUS_BIN'
        elif [ $method -eq 3 ]; then 
          cmd='ls -lhrt $ENV_LOTUS_ROOT/worker/cache'
        elif [ $method -eq 4 ]; then 
          cmd='df -h $ENV_LOTUS_ROOT/worker;du -sh $ENV_LOTUS_ROOT/worker'
        elif [ $method -eq 5 ]; then 
          cmd='bash $ENV_LOTUS_ROOT/logs/5.worker-ap.sh'
        elif [ $method -eq 6 ]; then 
          cmd='bash $ENV_LOTUS_ROOT/logs/5.worker-p1.sh'
        elif [ $method -eq 7 ]; then 
          cmd='bash $ENV_LOTUS_ROOT/logs/5.worker-p2c.sh'
        elif [ $method -eq 8 ]; then 
          cmd='ps aux |grep lotus |grep -v grep'
        elif [ $method -eq 9 ]; then 
          cmd="pid=\`ps aux |grep lotus |grep -v grep |awk '{print \$2}'\`;kill -9 \$pid;"
        else
          echo "Input error"
        fi
      fi
    done
    echo " "
  done
  
  echo -e "\033[34m $cmd \033[0m"
  
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
      elif [ $segment -le 0 ] && [ $segment -ge 65535 ]; then
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
  {
    #info
    #echo -e "\033[34m ssh ${host}${segment}.${i} $cmd \033[0m"

    for ((i=${start};i<=${end};i++))
    do
      echo -e "\033[34m 
-------------------------------------------------- \033[0m\033[31m $cmd \033[0m\033[34m
------------- 执行到: ${host}${segment}.${i} -------------
-------------------------------------------------- \033[0m"
      ping -c1 -w5 ${host}${segment}.${i} > /dev/null
      if (($? == 0)); then
      {
        #ssh ${host}${segment}.${i} $cmd
        expect -c "
spawn bash -c \"ssh ${host}${segment}.${i} $cmd \"
expect {
\"*assword\" {set timeout 300; send \"${des_pass}\r\";}
\"yes/no\" {send \"yes\r\"; exp_continue;}
}
"

      }
      else
      {
        echo -e "\033[31m 
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      ------------- 失败主机: ${host}${segment}.${i} -------------
      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ \033[0m"
      }
      fi
    done
  }

  method_old=$method
  echo " "
  pause
  unset start end cmd

done
