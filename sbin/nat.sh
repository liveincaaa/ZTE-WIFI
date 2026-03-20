#!/bin/sh
#
# $Id: nat.sh,v 1.4 2009-12-09 08:45:37 steven Exp $
#
# usage: nat.sh
#

path_sh=`nv get path_sh`
. $path_sh/global.sh
echo "Info: nat.sh start " >> $test_log

ZTE_FORWARD_CHAIN=port_forward
ZTE_DMZ_CHAIN=DMZ
ZTE_MAPPING_CHAIN=port_mapping

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

#clear nat
iptables -t nat -F
iptables -t nat -X $ZTE_FORWARD_CHAIN
iptables -t nat -X $ZTE_DMZ_CHAIN
iptables -t nat -X $ZTE_MAPPING_CHAIN


#Make a new chain for nat
iptables -t nat -N $ZTE_FORWARD_CHAIN
iptables -t nat -N $ZTE_DMZ_CHAIN
iptables -t nat -N $ZTE_MAPPING_CHAIN

iptables -t nat -I PREROUTING 1 -j $ZTE_FORWARD_CHAIN
iptables -t nat -I PREROUTING 1 -j $ZTE_DMZ_CHAIN
iptables -t nat -I PREROUTING 1 -j $ZTE_MAPPING_CHAIN
	
	lan_en=`nv get LanEnable`
	nat_en=`nv get natenable`
	lte_bridge=`nv get lte_bridge_enable`
	echo "nat.sh defwan_rel=$defwan_rel" >> $test_log
	if [ "-$lte_bridge" == "-1" ] && [ "-$defwan_rel" == "-wan1" ]; then
		pswan_ip=`nv get wan1_ip`
		echo "nat.sh pswan_ip=$pswan_ip" >> $test_log
		if [ "-$nat_en" != "-0" -a "-$lan_en" == "-2" ]; then
	    		iptables -t nat -A POSTROUTING -o ${defwan_rel%:*} -j SNAT --to-source $pswan_ip
		elif [ "-$nat_en" != "-0" -a "-$lan_en" != "-0" ]; then
			iptables -t nat -A POSTROUTING -o $defwan_rel -j SNAT --to-source $pswan_ip
		fi
	else
		if [ "-$nat_en" != "-0" -a "-$lan_en" == "-2" ]; then
	    		iptables -t nat -A POSTROUTING -o ${defwan_rel%:*} -j MASQUERADE
		elif [ "-$nat_en" != "-0" -a "-$lan_en" != "-0" ]; then
			iptables -t nat -A POSTROUTING -o $defwan_rel -j MASQUERADE
		fi
	fi

clat46_en=1
	if [ "-$clat46_en" = "-1" ]; then
		iptables -t nat -A POSTROUTING -o clat4 -j MASQUERADE
	fi
	
flag=`nv get soft_for_sgk`

if [ "$flag" == "1" ]; then
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

