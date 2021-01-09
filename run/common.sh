#!/bin/bash

#ifconfig |grep 'inet ' |awk '{print $2}'
#ifconfig |grep 'inet ' | sed 's/^.*addr://g' | sed s/Bcast.*$//g | head -1
#ip addr show |awk -F '[ /]+' '$0~/inet/ && $0~/brd/ {print $3}'
export localip=`ip addr show |awk -F '[ /]+' '$0~/inet/ && $0~/brd/ {print $3}'|awk 'NR==1{print $1}'`
export marktime=`date "+%Y%m%d-%H%M%S"`

#swappiness=1
swappint=`cat /proc/sys/vm/swappiness`
if [ $swappint -gt 1 ]; then
  echo -e "\033[34m Warn: swappiness > 1. \033[0m"
  #swappiness
  sysctl vm.swappiness=1
  sudo sed -i "/swappiness/d" /etc/sysctl.conf
  sudo echo "vm.swappiness=1" >> /etc/sysctl.conf
  
  swapoff -a
fi

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

check_pid_exist() {
  #count=`ps -ef |grep $1 |grep -v "grep" |wc -l`
  #echo $count
  #echo $1
  pid=`ps -ef |grep "$1" |grep -v "grep" |awk '{print $2}'|wc -l`
  #echo $pid
  if [ -z $pid ]; then
    pid=0
  fi
}

check_killprocess() {
  #myselfpath=$(cd "$(dirname $0)";pwd)
  myself=$1
  echo " "
  num=`ps -ef |grep $myself|gawk '$0 !~/grep/ {print $2}'| wc -l`
  if [ $num > 0 ]; then
    ps -ef |grep $myself
    echo " "

    #info
    echo -e "\033[31m killall $myself \033[0m"

    kill -9 $(ps -ef |grep $myself|gawk '$0 !~/grep/ {print $2}' |tr -s '\n' ' ')
    echo " "
  fi
}

check_areyousure() {
  if [ ! -z $1 ]; then
    count=$1
  fi
  #echo $count
  if [ -z $tips ]; then
    unset areyousure
  fi
  while [ -z $areyousure ]
  do
    echo " "
    read -e -r -p "Are you sure? [[Y]es/[N]o/[A]llow] " input
    if [ ! -z $1 ]; then
      if [ ! -z $count ]; then
        count=$(($count-1))
      fi
      if [ $count -eq 0 ]; then
        input="yes"
      fi
    fi
    case $input in
      [yY][eE][sS]|[yY])
        echo -e "\033[34m Yes \033[0m"
        areyousure=1
        ;;
      
      [nN][oO]|[nN])
        echo -e "\033[34m No \033[0m"
        areyousure=0
        ;;
      
      [aA][lL][lL][oO][wW]|[aA])
        echo -e "\033[34m Allow \033[0m"
        areyousure=1
        tips=99
        ;;
      
      *)
        echo -e "\033[31m Invalid input... \033[0m"
        ;;
    esac
  done
  return $areyousure
}

check_yesorno() {
  if [ ! -z $1 ]; then
    count=$1
  fi
  #echo $count
  unset yesorno
  while [ -z $yesorno ]
  do
    echo " "
    read -e -r -p "Are you sure? [[Y]es/[N]o " input
    if [ ! -z $1 ]; then
      if [ ! -z $count ]; then
        count=$(($count-1))
      fi
      if [ $count -eq 0 ]; then
        input="yes"
      fi
    fi
    case $input in
      [yY][eE][sS]|[yY])
        echo -e "\033[34m Yes \033[0m"
        yesorno=1
        ;;

      [nN][oO]|[nN])
        echo -e "\033[34m No \033[0m"
        yesorno=0
        ;;

      *)
        echo -e "\033[31m Invalid input... \033[0m"
        ;;
    esac
  done
  return $yesorno
}

# Colorefull print 加粗

function red_print() {
    local text=$@

    # echo ""
    echo -e "\033[1m\033[31m[$text]\033[0m"   # 红色加粗, 并复原
    # echo ""
}

function green_print() {
    local text=$@

    echo ""
    echo -e "\033[1m\033[32m[$text]\033[0m"   # 绿色加粗, 并复原
    # echo ""
}

function blue_print() {
    local text=$@

    # echo ""
    echo -e "\033[1m\033[36m[$text]\033[0m"   # 蓝色加粗, 并复原
    # echo ""
}

# Colorefull print2 不加粗

function red_print2() {
    local text=$@

    # echo ""
    echo -e "\033[31m[$text]\033[0m"   # 红色, 并复原
    # echo ""
}

function green_print2() {
    local text=$@

    echo ""
    echo -e "\033[32m[$text]\033[0m"   # 绿色, 并复原
    # echo ""
}

function blue_print2() {
    local text=$@

    # echo ""
    echo -e "\033[36m[$text]\033[0m"   # 蓝色, 并复原
    # echo ""
}


