#!/bin/bash

if [ `id -u` == "0" ]; then
  ROOTARG="--allow-root"
fi

# If we are not using --network=host, then tell jupyter how to bind
if ! grep -q docker /proc/net/dev ; then
  IPADDR=`ip addr show dev eth0 | grep inet | cut -d/ -f1 | awk '{print $2}'`
  IPARG="--ip=${IPADDR}"
fi

jupyter notebook ${ROOTARG} ${IPARG}
