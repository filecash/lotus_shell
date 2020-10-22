#!/bin/bash

#> vi lotus/build/bootstrap/bootstrappers.pi

if [ -z $1 ]; then 
  bootstrap="
/dns4/bootstrap1.testnet.filfox.info/tcp/16666/p2p/12D3KooW9uSxsSh3qwAPxSwwRDVqTTPg8HTBthujVYFXy7Dizb6Q
/dns4/bootstrap2.testnet.filfox.info/tcp/16666/p2p/12D3KooWKths1fzziHsmeMdTdV7dgB9DzoeiGVSwcW2HCygztH9e
/dns4/bootstrap-0.testnet.fildev.network/tcp/1347/p2p/12D3KooWJTUBUjtzWJGWU1XSiY21CwmHaCNLNYn2E7jqHEHyZaP7
/dns4/bootstrap-1.testnet.fildev.network/tcp/1347/p2p/12D3KooW9yeKXha4hdrJKq74zEo99T8DhriQdWNoojWnnQbsgB3v
/dns4/bootstrap-2.testnet.fildev.network/tcp/1347/p2p/12D3KooWCrx8yVG9U9Kf7w8KLN3Edkj5ZKDhgCaeMqQbcQUoB6CT
/dns4/bootstrap-4.testnet.fildev.network/tcp/1347/p2p/12D3KooWPkL9LrKRQgHtq7kn9ecNhGU9QaziG8R5tX8v9v7t3h34
/dns4/bootstrap-3.testnet.fildev.network/tcp/1347/p2p/12D3KooWKYSsbpgZ3HAjax5M1BXCwXLa6gVkUARciz7uN3FNtr7T
/dns4/bootstrap-5.testnet.fildev.network/tcp/1347/p2p/12D3KooWQYzqnLASJAabyMpPb1GcWZvNSe7JDcRuhdRqonFoiK9W
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
