#!/bin/bash

#> bash send-deal.sh minerid filecount circle
#> bash send-deal.sh filecount circle
#> bash send-deal.sh 

tmp_path=./tmp
filesize=10240 #10K
filecount=1 #
circle=1

create_file() {
  #echo $1 
  newfile=$1
  if [ ! -d "$tmp_path" ]; then 
    mkdir $tmp_path
  fi
  
  start_time=$[$(date +%s%N)/1000000]
  
  echo " "
  echo -e "\033[34m  od /dev/urandom |dd bs=${filesize} count=${count} iflag=fullblock > $tmp_path/${newfile} \033[0m"
  
  od /dev/urandom |dd bs=${filesize} count=${count} iflag=fullblock > $tmp_path/${newfile}
  wait
  #ls -lh $tmp_path/${newfile} |grep root
  
  end_time=$[$(date +%s%N)/1000000]
  echo "create ${newfile} time: `expr $end_time - $start_time` ms "
}

if echo $1 |grep -q '^t0[0-9]\{4,8\}$' ; then
  actor=$1
elif echo ! $1 |grep -q '[^0-9]'; then
  count=$1
  if [ ! -z $2 ]; then 
    circle=${2:-1}
  fi
fi
#echo $1 $actor $count
if [ -z $actor ]; then 
  actor=`lotus-miner info |grep "Miner" |awk 'NR==1 {print $2}'`
fi
if [ -z $actor ]; then
  echo -e "\033[34m  miner_id abnormal. \033[0m"
  exit 1
fi

echo -e "\033[34m  lotus client query-ask $actor \033[0m"
lotus client query-ask $actor

if [ -z $count ]; then 
  if [ -z $2 ]; then 
    count=$filecount
  else 
    count=${2:-1}
  fi
fi
if [ ! -z $3 ]; then 
  circle=${3:-1}
fi


for ((i=1;i<=${circle};i++))
do
    echo -e "\033[34m 
-------------------------------------------------- 
---------------------  ${i}  ---------------------
-------------------------------------------------- \033[0m"
  
  start=$[$(date +%s%N)/1000000]
  filerandom=$(openssl rand -base64 40|sed 's#[^a-z]##g'|cut -c 2-11)
  filetime=$(date "+%Y%m%d%H%M%S")
  newfile=fil-storage-${filerandom}-${filetime}.dat
  
  create_file ${newfile}
  
  middle=$[$(date +%s%N)/1000000]
  if [ ! -z $actor ]; then 
    echo " "
    echo -e "\033[34m  lotus client import $tmp_path/${newfile} |awk '{print \$4}' \033[0m"
    DataCID=`lotus client import $tmp_path/${newfile} |awk '{print $4}'`
    echo -e "\033[31m  $DataCID \033[0m"
    
    if [ "$DataCID" != "no" ]; then 
      echo -e "\033[34m  lotus client deal $DataCID $actor 0.0000000005 622080 \033[0m"
      DealCID=`lotus client deal $DataCID $actor 0.00000005 622080`
      echo -e "\033[31m  $DealCID \033[0m"

      echo " `date`  $tmp_path/${newfile}  actor=$actor  DataCID=$DataCID  DealCID=$DealCID" >> $tmp_path/deal-storage.log

      echo -e "\033[34m  lotus client get-deal $DealCID \033[0m"
      #sleep 5
      #lotus client get-deal $DealCID
    fi
    
    echo " "
  fi
  end=$[$(date +%s%N)/1000000]
  
  echo "upload ${newfile} time: `expr $end - $middle` ms "
  echo " "
  echo "All ${newfile} the time interval is $(( $end - $start )) ms "
  echo " "
done

pause
