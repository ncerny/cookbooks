#!/bin/bash

DEV=$1
IP=$2
/usr/bin/ip address add ${IP}/24 brd + dev ${DEV}
/usr/bin/ip neigh flush dev ${DEV}

for host in unifi-sg1 unifi-sw1; do
  arping -s ${IP} -c 15 -I ens2 ${host}.home.cerny.cc -f
done
