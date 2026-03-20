#!/bin/sh

flag=`nv get telnetd_enable`

if [ "$flag" == "1" ]; then
    echo "Starting telnetd......!"
    /usr/sbin/telnetd -p 4719 & 
fi


