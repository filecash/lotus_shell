#!/bin/bash

#> vi lotus/build/bootstrap/bootstrappers.pi

if [ -z $1 ]; then 
  bootstrap="
/dns4/a1.filecoincash.com/tcp/8911/p2p/12D3KooWMAQi4qTg69a683R1Dvz2XzKhjTCHq8uuwd5PkhM45vff
/dns4/a2.filecoincash.com/tcp/8911/p2p/12D3KooWEhptW8M7NDR4Um9fgVVck42YoTbHDBE3qF3iLonCkPn9
/dns4/a3.filecoincash.com/tcp/8911/p2p/12D3KooWB2Pim8E1aj9DhcccJSDk93pJYpmm5LAtuinLXVVttYZo
/dns4/a5.filecoincash.com/tcp/8911/p2p/12D3KooWJibEA5yyFxPq2NHkP9aaiPLfMTbXhUqtRtwbTU4gMaBB
/dns4/a6.filecoincash.com/tcp/8911/p2p/12D3KooWFE5TZk8BANmY6w3WXD2gPfbfkaRnZNFtao1unaXYg47E
/dns4/a8.filecoincash.com/tcp/8911/p2p/12D3KooWADZTsmBWQuZQjyruSpVNoX4XB1JTXFWtsVMz8bwhtGUr
"
else 
  bootstrap="$1"
fi


for i in $bootstrap
do 
  if [ ! -z $i ]; then
    echo $i
    lotus-miner net connect $i
  fi
done
