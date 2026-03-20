#/bin/sh
if [ $1 == "connect" ]; then
	if [ $2 == "l2tp" ]; then
		ppp_used=`nv get pptp_ifname`
		if [ ${#ppp_used} -lt 3 ]; then
			ppp_used=null
		fi
		nv set l2tp_ifname=`route -n|grep ppp|awk -F' ' '{print $NF}'|sed /$ppp_used/d`
		ifname=`nv get l2tp_ifname`
		nv set l2tp_remoteip=`route -n|grep $ifname|awk -F' ' '{print $1}'`
		ifconfig > /ifconfig.txt
		nv set l2tp_localip=`grep -A 6 -i $ifname /ifconfig.txt|grep -i addr:|awk -F'addr:' '{print $2}'|awk -F' ' '{print $1}'`
		nv set l2tp_mtu=`grep -A 6 -i $ifname /ifconfig.txt|grep -i MTU|awk -F'MTU:' '{print $2}'|awk -F' ' '{print $1}'`
		rm /ifconfig.txt
		contime=`nv get run_time`
		contime=`nv get run_time`
		contime=`nv get run_time`
		nv set l2tp_runtime=$contime
	fi

	if [ $2 == "pptp" ]; then
        	ppp_used=`nv get l2tp_ifname`
		if [ ${#ppp_used} -lt 3 ]; then
			ppp_used=null
		fi
        	nv set pptp_ifname=`route -n|grep ppp|awk -F' ' '{print $NF}'|sed /$ppp_used/d`
		ifname=`nv get pptp_ifname`
		nv set pptp_remoteip=`route -n|grep $ifname|awk -F' ' '{print $1}'`
		ifconfig > /ifconfig1.txt
		nv set pptp_localip=`grep -A 6 -i $ifname /ifconfig1.txt|grep -i addr:|awk -F'addr:' '{print $2}'|awk -F' ' '{print $1}'`
		nv set pptp_mtu=`grep -A 6 -i $ifname /ifconfig1.txt|grep -i MTU|awk -F'MTU:' '{print $2}'|awk -F' ' '{print $1}'`
		rm /ifconfig1.txt
		contime=`nv get run_time`
		contime=`nv get run_time`
		contime=`nv get run_time`
                nv set pptp_runtime=$contime
	fi
fi

if [ $1 == "disconnect" ]; then
	if [ $2 == "l2tp" ]; then
		nv set l2tp_ifname=
		nv set l2tp_remoteip=
		nv set l2tp_mtu=
		nv set l2tp_localip=
		nv set l2tp_runtime=
	fi

	if [ $2 == "pptp" ]; then
		nv set pptp_ifname=
		nv set pptp_remoteip=
		nv set pptp_mtu=
		nv set pptp_localip=
		nv set pptp_runtime=
	fi
fi	
	

