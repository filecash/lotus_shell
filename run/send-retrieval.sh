#!/bin/bash

#> bash find-deal.sh datacid 
#> bash find-deal.sh 

tmp_path=./tmp

if echo $1 |grep -q '^bafyre[0-9]\{4,8\}$' ; then
  datacid=$1
else
  while [ -z $datacid ]
  do
    read -e -p '  please input datacid:' datacid
    if echo $datacid |grep -q '^bafyre[0-9]\{4,8\}$' ; then
      echo $datacid
    else
      unset datacid
    fi
  done
fi

filetime=$(date "+%Y%m%d%H%M%S")
newfile=fil-retrieve-${datacid}-${filetime}.dat

echo -e "\033[34m  lotus client find $datacid \033[0m"
lotus client find $datacid

echo " "
echo -e "\033[34m  lotus client retrieve $datacid \033[0m"
lotus client retrieve $datacid $tmp_path/${newfile}

echo " `date`  $tmp_path/${newfile}  actor=$actor  DataCID=$datacid " >> $tmp_path/deal-retrieve.log

pause
