#!/bin/bash

DEV=$1
IP=$2

/usr/bin/ip addr del ${IP}/24 dev ${DEV}
