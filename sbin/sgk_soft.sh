#!/bin/sh

flag=`nv get soft_for_sgk`

if [ "$flag" == "1" ]; then
    echo "Starting sgk static_ip & port map......!"
    eth_auto_connect &
	#Start tftp server
#	udpsvd -vE 0 69 tftpd -c / &
	#SGK port map
	lan_ipaddr=$(nv get lan_ipaddr)
	dst_ip=$(nv get dst_ip)
	src_port=$(nv get src_port)
	dst_port=$(nv get dst_port)
	echo 1 > /proc/sys/net/ipv4/ip_forward
	iptables -t nat -A PREROUTING -p tcp -m tcp -d $lan_ipaddr --dport $src_port -j DNAT --to-destination $dst_ip:$dst_port
	iptables -t nat -A POSTROUTING -d $dst_ip -p tcp -m tcp --dport $dst_port -j SNAT --to-source $lan_ipaddr
	
	ip_filter=`nv get sgk_ip_filter`	
	if [ "$ip_filter" != "0" ]; then
		eth0_ipaddr=$(nv get eth_lan_ip)
		if [ "$eth0_ipaddr" == "" ]; then
			iptables -t filter -A FORWARD -p tcp -s ${lan_ipaddr%.*}.50 -j ACCEPT
			iptables -t filter -A FORWARD -p udp -s ${lan_ipaddr%.*}.50 -j ACCEPT
			iptables -t filter -A FORWARD -p tcp -m iprange --src-range ${lan_ipaddr%.*}.2-${lan_ipaddr%.*}.254 -j DROP	
			iptables -t filter -A FORWARD -p udp -m iprange --src-range ${lan_ipaddr%.*}.2-${lan_ipaddr%.*}.254 -j DROP
		else	
			iptables -t filter -A FORWARD -p tcp -s $eth0_ipaddr -j ACCEPT
			iptables -t filter -A FORWARD -p udp -s $eth0_ipaddr -j ACCEPT
			iptables -t filter -A FORWARD -p tcp -m iprange --src-range ${eth0_ipaddr%.*}.2-${eth0_ipaddr%.*}.254 -j DROP
			iptables -t filter -A FORWARD -p udp -m iprange --src-range ${eth0_ipaddr%.*}.2-${eth0_ipaddr%.*}.254 -j DROP
		fi
	fi
fi
