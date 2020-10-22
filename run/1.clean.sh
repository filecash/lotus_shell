#!/bin/bash

source $(cd `dirname $0`; pwd)/env.sh

if [ -z $ENV_LOG_DIR ]; then
  echo "please config env.sh"
  exit
fi

cd $ENV_LOG_DIR


#info
echo " "
echo -e "\033[34m rm -rf $LOTUS_PATH/* $LOTUS_MINER_PATH/* $LOTUS_WORKER_PATH/* $TMPDIR/*  \033[0m"
echo " "
echo -e "\033[31m Warn: Are all data clear? \033[0m"

check_yesorno
if [ $yesorno -eq 1 ]; then
  #clean
  rm -rf $LOTUS_PATH/* $LOTUS_MINER_PATH/* $LOTUS_WORKER_PATH/* $TMPDIR/* 
  #rm -rf $ENV_LOG_DIR/*
  #rm -rf $FIL_PROOFS_PARAMETER_CACHE/*

  # tips
  echo -e "\033[34m ${EXE_LOTUS} fetch-params $ENV_SECTOR_SIZE \033[0m"

  ${EXE_LOTUS} fetch-params $ENV_SECTOR_SIZE
fi
