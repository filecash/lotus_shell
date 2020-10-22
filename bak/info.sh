#!/bin/bash

#cpu
CPU_num=`lscpu |grep 'NUMA node(s):' |awk 'NR==1{print $3}'`
CPU_name=`lscpu |grep 'Model name:' |awk 'NR==1' |awk -F':' '{print $2}'`
CPU_core=`lscpu |grep 'CPU(s):' |awk 'NR==1{print $2}'`
#echo "$CPU_num * $CPU_name = $CPU_core"

#mem
free -h |sed -n '2p' |awk '{print $2}'
Mem=`free -h |grep "Mem:" |awk '{print $2}'`
Swap=`free -h |grep "Swap:" |awk '{print $2}'`
Mem_num=`sudo dmidecode -t memory |grep 'Size:' | wc -L`
Mem_size=`sudo dmidecode -t memory |grep 'Size:' |awk 'NR==3{print $2}'`
Mem_type=`sudo dmidecode -t memory |grep 'Type:' |awk 'NR==3{print $2}'`
Mem_speed=`sudo dmidecode -t memory |grep 'Speed:' |awk 'NR==3{print $2}'`
#echo "$Mem_num * $Mem_size $Mem_type $Mem_speed    Mem=$Mem Swap=$Swap "

#gpu
GPU_name=`lspci |grep VGA |awk -F':' '{print $3}'`

echo "# Info
  $CPU_num * $CPU_name = $CPU_core
  $Mem_num * $Mem_size $Mem_type $Mem_speed    Mem=$Mem Swap=$Swap 
  $GPU_name
  "

pause

#gpu
lspci |grep VGA |awk 'NR==2' |awk -F'[' '{print $2}' |awk -F']' '{print $1}'

MEMUSE=`nvidia-smi -q |grep -A 3 "FB Memory Usage" |grep Used |awk '{print $3}'`
MEMTOL=`nvidia-smi -q |grep -A 3 "FB Memory Usage" |grep Total |awk '{print $3}'`
GPUMEM=100*$MEMUSE/$MEMTOL|bc
echo $GPUMEM

POWUSE=`nvidia-smi -q |grep -A 3 "Power Readings" |grep "Power Draw" |awk '{print $4}'`
POWTOL=`nvidia-smi -q |grep -A 3 "Power Readings" |grep "Power Limit" |awk '{print $4}'`
GPUTOL=100*$POWUSE/$POWTOL|bc
echo $GPUPOW

GPUTMP=`nvidia-smi -q |grep -A 3 "Temperature" |grep "GPU Current Temp" |awk '{print $5}'`
echo $GPUTMP
