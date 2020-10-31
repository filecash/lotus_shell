#/bin/bash

#> nohup bash pledge-auto.sh 1200 20 >> ./auto-pledge.log 2>&1 &

count=100000       # count

## interval=600    # sec    $1
if [ -z $1 ]; then 
  interval=600
else 
  interval=$1
fi

## limit=28        # limit  $2
if [ -z $2 ]; then 
  limit=28
else 
  limit=$2
fi

check_pid_exist() {
  pid=`ps -ef |grep "$1" |grep -v "grep" |awk '{print $2}'|wc -l`
  #echo "pid=$pid"
  if [ -z $pid ]; then
    pid=0
  fi
}

check_pid_exist "pledge-auto.sh"
if [ $pid -le 2 ]; then
  
  # tips
  echo -e "\033[34m nohup bash pledge-auto.sh >> ./auto-pledge.log 2>&1 & \033[0m"
  
  processor=$(grep 'processor' /proc/cpuinfo |sort |uniq |wc -l)
  echo -e "\033[34m processor = $processor \033[0m" 
  
  for i in $(seq ${count}); 
  do 
    
    num_c2=`lotus-miner sealing jobs |grep C2 |wc -l`
    num_p2=`lotus-miner sealing jobs |grep PC2 |wc -l`
    num_p1=`lotus-miner sealing jobs |grep PC1 |wc -l`
    num_ap=`lotus-miner sealing jobs |grep AP |wc -l`
    
    #num=`expr $num_ap + $num_p1 + $num_p2 + $num_c2`
    #echo "$num_ap + $num_p1 + $num_p2 + $num_c2 = $num < $limit    ap: $num_ap < $processor"
    #num=`expr $num_ap + $num_p1 + $num_c2`
    #echo "$num_ap + $num_p1 + $num_c2 = $num < $limit    ap: $num_ap < $processor"
    #num=`expr $num_ap + $num_p1 + $num_p2`
    #echo "$num_ap + $num_p1 + $num_p2 = $num < $limit    ap: $num_ap < $processor"
    num=`expr $num_ap + $num_p1`
    echo "$num_ap + $num_p1 = $num < $limit    ap: $num_ap < $processor"
    
    if [ "$num" -lt "$limit" ] && [ "$num_ap" -lt "$processor" ]; then
      echo "  `date`  pledge all ${count} run $i "
      lotus-miner actor withdraw
      lotus-miner sectors pledge
    else
      echo "  `date`  no task " 
    fi
    
    sleep ${interval}
  done

else
  # tips
  echo -e "\033[31m pledge-auto.sh run is exist. \033[0m"
  
  exit 1
fi

