#!/bin/sh

#echo " vpn up"  > /dev/pts/1

#echo "ifname :$1 devname:$2 local:$4 remote :$5"  >/dev/pts/1

configure_vpn_subnet()
{
ip1=$(echo $1 | awk -F "." '{print $1}')
ip2=$(echo $1 | awk -F "." '{print $2}')
ip3=$(echo $1 | awk -F "." '{print $3}')
ip4=$(echo $1 | awk -F "." '{print $4}')
#echo $ip1 $ip2 $ip3 $ip4 >/dev/pts/1
route add -net $ip1.$ip2.$ip3.0/24 dev $2
}
#configure_vpn_subnet 192.168.42.5 ppp0
configure_vpn_subnet $4  $1

# part2 for pptp vpn
# nv set pptp_status=connected                                                   

process_pid=$$
#cat "/proc/$process_pid/status" >/dev/pts/1
#get ppid
get_ppid=$(cat /proc/$process_pid/status | sed -n '5p' )
#delete space char, PPid:986
get_ppid=$(echo $get_ppid | sed 's/ //g')
#delete PPid: sample PPid:986>> 986  
get_ppid=$(echo ${get_ppid##*:})
#echo "$get_ppid"    >/dev/pts/1
ppcmdline=$(cat /proc/$get_ppid/cmdline) 
#echo "$ppcmdline"    >/dev/pts/1

result=$(echo $ppcmdline | grep "connectvpn")
if [[ "$result" != "" ]]
then
   #echo "foound" >/dev/pts/1
   nv set pptp_status=connected
   sleep 6
   #echo "6s later .start vpninfo"  >/dev/pts/1
   /sbin/vpn_info.sh connect pptp &
fi



