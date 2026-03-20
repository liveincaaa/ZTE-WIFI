#!/bin/sh

lan_ipaddr=`nv get lan_ipaddr`

net_selfcheck_ip=`nv get net_selfcheck_ip`

O_IFS="$IFS"
IFS=";"
pingok="no"
for ip in $net_selfcheck_ip ; do
	if ( ping -c 5 $ip ) ; then
		pingok=yes
		break;
	fi
done
IFS="$O_IFS"

if ( ping -c 5 www.msftconnecttest.com ) ; then
	pingok=yes
	break;
fi

if test "${pingok}" = "yes" ; then
	nv set interneted=1
	o_lan_ipaddr=`nv get o_lan_ipaddr`
	iptables -t nat -D PREROUTING -p tcp --dport 80  -j DNAT --to ${o_lan_ipaddr}:80
	iptables -t nat -D PREROUTING -p tcp --dport 443 -j DNAT --to ${o_lan_ipaddr}:443
	nv set o_lan_ipaddr=
else
	nv set interneted=
	o_lan_ipaddr=`nv get o_lan_ipaddr`
	if test -n "${o_lan_ipaddr}" ; then
		iptables -t nat -D PREROUTING -p tcp --dport 80  -j DNAT --to ${o_lan_ipaddr}:80
		iptables -t nat -D PREROUTING -p tcp --dport 443 -j DNAT --to ${o_lan_ipaddr}:443
	fi
	nv set o_lan_ipaddr=${lan_ipaddr}
	iptables -t nat -A PREROUTING -p tcp --dport 80  -j DNAT --to ${lan_ipaddr}:80
	iptables -t nat -A PREROUTING -p tcp --dport 443 -j DNAT --to ${lan_ipaddr}:443
fi
