#!/bin/sh

#echo " vpn down"  > /dev/pts/1

#echo "ifname :$1 devname:$2 local:$4 remote :$5"  >/dev/pts/1

configure_vpn_subnet()
{
ip1=$(echo $1 | awk -F "." '{print $1}')
ip2=$(echo $1 | awk -F "." '{print $2}')
ip3=$(echo $1 | awk -F "." '{print $3}')
ip4=$(echo $1 | awk -F "." '{print $4}')
#echo $ip1 $ip2 $ip3 $ip4 
route del  -net $ip1.$ip2.$ip3.0/24 dev $2
}
#configure_vpn_subnet 192.168.42.5 ppp0
configure_vpn_subnet $4  $1
