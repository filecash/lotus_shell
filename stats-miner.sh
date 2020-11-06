#!/bin/bash

export marktime=`date "+%Y%m%d-%H%M%S"`

# log
export marklog="power-miner-all.log"
# backup log
if [ -f "$marklog" ]; then 
  mv $marklog $marklog.$marktime.log
fi

#string=`lotus state list-miners | tr "\n" ","`
stringtmp=`lotus state list-miners | awk '{print length, $0}' | sort -n | sed 's/^[0-9]\+ //'`
echo $stringtmp
string=`echo $stringtmp | tr "\n" ","`
echo $string
echo " "

echo $marktime  >> $marklog
echo " " >> $marklog

#将,替换为空格
array=(${string//,/ })  
for var in ${array[@]}
do
    minerpower=`lotus state power $var`
    minerbalance=`lotus wallet balance $var`
    minerpower="`echo $minerpower |grep -o '(.*) /'` `echo $minerpower |grep -o '/ .*(.*)' |grep -o '(.*)'` `echo $minerpower |grep -o '~= .*'`"
    minerbalance="`echo $minerbalance |grep -o '.* FIC'`"
    echo "$var  $minerpower  $minerbalance"
    echo "$var  $minerpower  $minerbalance"  >> $marklog
    echo " " >> $marklog
done

echo " "

