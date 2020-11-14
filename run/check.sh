#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


#export LOTUS_MINER_STORE_PATH=/mnt/miner_store
#export LOTUS_MINER_STORE_PATH=/opt/lotusdata/miner-storage
#export marktime=`date "+%Y%m%d-%H%M%S"`

# log
export marklog="sector-check.log"
# backup log
if [ -f "$marklog" ]; then
  mv $marklog $marklog.$marktime.log
fi

minerid=`lotus-miner info |grep "Miner" |awk 'NR==1 {print $2}'`
echo "checking $minerid"

#string_online=`lotus state sectors $minerid |awk -F ':' '{print $1}'`

echo " "
echo " "
echo "#获取落盘文件大小不对的扇区 请手动删除"
echo "#获取落盘文件大小不对的扇区 请手动删除"  >> $marklog
du -sh $LOTUS_MINER_STORE_PATH/cache/s-* |grep -v "9.2M"  #9.2M
du -sh $LOTUS_MINER_STORE_PATH/cache/s-* |grep -v "9.2M" |awk -F '$minerid-' '{print $2}' | sort -n | sed 's/^[0-9]\+ //'
du -k $LOTUS_MINER_STORE_PATH/sealed/s-* |grep -v "4198404\|4194308\|4194304"  #4.0G
du -k $LOTUS_MINER_STORE_PATH/sealed/s-* |grep -v "4198404\|4194308\|4194304" |awk -F '$minerid-' '{print $2}' | sort -n | sed 's/^[0-9]\+ //'

echo " "
echo " "
echo "#获取落盘文件 Proving 大小不对的扇区 请手动删除"
echo "#获取落盘文件 Proving 大小不对的扇区 请手动删除"  >> $marklog
string_local=`lotus-miner sectors list |grep Proving |awk -F ':' '{print $1}'`
string=`echo $string_local | tr "\n" ","`
array=(${string//,/ })
for var in ${array[@]}
do
  #echo "check  $var "
  if [ ! -f "$LOTUS_MINER_STORE_PATH/cache/s-$minerid-$var/t_aux" ]; then
    #echo " "
    #echo "check Proving $var  $LOTUS_MINER_STORE_PATH/cache/s-$minerid-$var/t_aux"
    # 删除问题扇区
    echo "lotus-miner sectors remove --really-do-it  $var"
    #lotus-miner sectors remove --really-do-it $var
    echo "lotus-miner sectors remove --really-do-it $var"  >> $marklog
  fi
  du -b $LOTUS_MINER_STORE_PATH/cache/s-$minerid-$var/p_aux |grep -v "64"  # 64 B
  du -b $LOTUS_MINER_STORE_PATH/cache/s-$minerid-$var/sc-02-data-tree-r-last.dat |grep -v "9586976"  # 9586976 B
  du -k $LOTUS_MINER_STORE_PATH/sealed/s-$minerid-$var |grep -v "4198404\|4194308\|4194304"  # 4198404 KB
done

echo " "
echo " "
echo "#获取 PreCommit 状态不对的扇区 请手动删除"
echo "#获取 PreCommit 状态不对的扇区 请手动删除"  >> $marklog
string_local=`lotus-miner sectors list |grep "PreCommit" |grep -v "tktH: 0\|seedH: 0" |awk -F ':' '{print $1}'`
string=`echo $string_local | tr "\n" ","`
array=(${string//,/ })
for var in ${array[@]}
do
  #echo " "
  #echo "check PreCommit $var"
  # 删除问题扇区
  echo "lotus-miner sectors remove --really-do-it  $var"
  #lotus-miner sectors remove --really-do-it $var
  echo "lotus-miner sectors remove --really-do-it  $var"  >> $marklog
done

echo " "
echo " "
echo "#获取 Fail 状态不对的扇区 请手动删除"
echo "#获取 Fail 状态不对的扇区 请手动删除"  >> $marklog
string_local=`lotus-miner sectors list |grep Failed |awk -F ':' '{print $1}'`
string=`echo $string_local | tr "\n" ","`
array=(${string//,/ })
for var in ${array[@]}
do
  #echo " "
  #echo "check Fail $var"
  # 删除问题扇区
  echo "lotus-miner sectors remove --really-do-it  $var"
  #lotus-miner sectors remove --really-do-it $var
  echo "lotus-miner sectors remove --really-do-it  $var"  >> $marklog
done

echo " "
echo " "
echo "#获取 FinalizeSector 状态扇区 请谨慎删除"
echo "#获取 FinalizeSector 状态扇区 请谨慎删除"  >> $marklog
string_local=`lotus-miner sectors list |grep FinalizeSector |awk -F ':' '{print $1}'`
string=`echo $string_local | tr "\n" ","`
array=(${string//,/ })
for var in ${array[@]}
do
  #echo " "
  #echo "check FinalizeSector $var"
  # 删除问题扇区
  echo "lotus-miner sectors remove --really-do-it  $var"
  #lotus-miner sectors remove --really-do-it $var
  echo "lotus-miner sectors remove --really-do-it  $var"  >> $marklog
done

echo " "
echo " "
echo "#获取 Committing 状态扇区 请谨慎删除"
echo "#获取 Committing 状态扇区 请谨慎删除"  >> $marklog
string_local=`lotus-miner sectors list |grep Committing |awk -F ':' '{print $1}'`
string=`echo $string_local | tr "\n" ","`
array=(${string//,/ })
for var in ${array[@]}
do
  #echo " "
  #echo "check Committing $var"
  # 删除问题扇区
  echo "lotus-miner sectors remove --really-do-it  $var"
  #lotus-miner sectors remove --really-do-it $var
  echo "lotus-miner sectors remove --really-do-it  $var"  >> $marklog
done

echo " "
