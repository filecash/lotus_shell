#!/bin/bash

export marktime=`date "+%Y%m%d-%H%M%S"`

# log
export marklog="check-removing2removed.log"
# backup log
if [ -f "$marklog" ]; then 
  mv $marklog $marklog.$marktime.log
fi

string=`lotus-miner sectors list |grep Removing |awk '{print $1}'|sed 's/://g'`
string=`echo $string | tr "\n" ","`

echo "$string"  >> $marklog

minerid=`lotus-miner info |grep "Miner" |awk 'NR==1 {print $2}'`

#将,替换为空格
array=(${string//,/ })

for var in ${array[@]}
do
    mkdir $LOTUS_WORKER_PATH/cache/s-$minerid-$var
    echo "" > $LOTUS_WORKER_PATH/sealed/s-$minerid-$var
    echo "" > $LOTUS_WORKER_PATH/unsealed/s-$minerid-$var
    ls $LOTUS_WORKER_PATH/*/s-$minerid-$var
    
    echo " "
    echo "lotus-miner sectors remove --really-do-it $var"
    echo "lotus-miner sectors remove --really-do-it $var"  >> $marklog
    lotus-miner sectors remove --really-do-it $var
    
    sleep 1
    #rm -rf $LOTUS_WORKER_PATH/cache/s-$minerid-$var
    #rm -rf $LOTUS_WORKER_PATH/sealed/s-$minerid-$var
    #rm -rf $LOTUS_WORKER_PATH/unsealed/s-$minerid-$var
    #ls $LOTUS_WORKER_PATH/*/s-$minerid-$var
    echo " "
    echo " "
done

echo " "

