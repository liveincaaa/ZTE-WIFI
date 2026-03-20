#!/bin/sh

flag=`nv get soft_for_kunwei`

if [ "$flag" == "1" ]; then
    echo "Starting kunwei static_ip & port map......!"
	
    lan_ipaddr=192.168.1.254
    dst_ip=192.168.1.100

    iptables -t nat -A PREROUTING -p tcp -m tcp -d $lan_ipaddr --dport 80 -j DNAT --to-destination $dst_ip:80
    iptables -t nat -A POSTROUTING -d $dst_ip -p tcp -m tcp --dport 80 -j SNAT --to-source $lan_ipaddr	

    iptables -t nat -A PREROUTING -p tcp -m tcp -d $lan_ipaddr --dport 8192 -j DNAT --to-destination $dst_ip:8192
    iptables -t nat -A POSTROUTING -d $dst_ip -p tcp -m tcp --dport 8192 -j SNAT --to-source $lan_ipaddr

    iptables -t nat -A PREROUTING -p tcp -m tcp -d $lan_ipaddr --dport 554 -j DNAT --to-destination $dst_ip:554
    iptables -t nat -A POSTROUTING -d $dst_ip -p tcp -m tcp --dport 554 -j SNAT --to-source $lan_ipaddr

    iptables -t nat -A PREROUTING -p tcp -m tcp -d $lan_ipaddr --dport 3333 -j DNAT --to-destination $dst_ip:3333
    iptables -t nat -A POSTROUTING -d $dst_ip -p tcp -m tcp --dport 3333 -j SNAT --to-source $lan_ipaddr


    iptables -t nat -A PREROUTING -p udp -m udp -d $lan_ipaddr --dport 80 -j DNAT --to-destination $dst_ip:80
    iptables -t nat -A POSTROUTING -d $dst_ip -p udp -m udp --dport 80 -j SNAT --to-source $lan_ipaddr

    iptables -t nat -A PREROUTING -p udp -m udp -d $lan_ipaddr --dport 8192 -j DNAT --to-destination $dst_ip:8192
    iptables -t nat -A POSTROUTING -d $dst_ip -p udp -m udp --dport 8192 -j SNAT --to-source $lan_ipaddr

    iptables -t nat -A PREROUTING -p udp -m udp -d $lan_ipaddr --dport 554 -j DNAT --to-destination $dst_ip:554
    iptables -t nat -A POSTROUTING -d $dst_ip -p udp -m udp --dport 554 -j SNAT --to-source $lan_ipaddr

    iptables -t nat -A PREROUTING -p udp -m udp -d $lan_ipaddr --dport 3333 -j DNAT --to-destination $dst_ip:3333
    iptables -t nat -A POSTROUTING -d $dst_ip -p udp -m udp --dport 3333 -j SNAT --to-source $lan_ipaddr
fi
