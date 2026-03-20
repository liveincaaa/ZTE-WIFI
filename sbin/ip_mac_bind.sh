init_file_rule()
{
#if [ -f /etc_rw/static_macip_file ];then
#	for i in `cat /etc_rw/static_macip_file|awk -F' ' '{print $1}'`
#	do
	#echo $i
#	iptables -D FORWARD -m mac --mac-source $i -j DROP
#	iptables -I FORWARD -m mac --mac-source $i -j DROP

#	iptables -D INPUT -m mac --mac-source $i -j DROP
#	iptables -A INPUT -m mac --mac-source $i -j DROP
#	done
#fi

#  set_segment_drop="1"
  cat /etc_rw/static_macip_file | while read line
  do
      bip=$( echo $line |awk -F' ' '{print $2}')
      bmac=$( echo $line |awk -F' ' '{print $1}')
      if [ $bip != "" -a $bmac != "" ]; then
#          if [ $set_segment_drop == "1" ]; then
#              set_segment_drop="0"
#              iptables -D FORWARD -s 192.168.150.0/24 -j DROP
#              iptables -I FORWARD -s 192.168.150.0/24 -j DROP
#          fi
          iptables -D FORWARD -m mac --mac-source $bmac -j DROP
          iptables -I FORWARD -m mac --mac-source $bmac -j DROP

          iptables -D FORWARD -s $bip -m mac --mac-source $bmac  -j ACCEPT
          iptables -I FORWARD -s $bip -m mac --mac-source $bmac  -j ACCEPT
      fi
  done
}

del_file_rule()
{
if [ -f /etc_rw/static_macip_file ];then
	for i in `cat /etc_rw/static_macip_file|awk -F' ' '{print $1}'`
	do
	#echo $i
	iptables -D FORWARD -m mac --mac-source $i -j DROP
	#iptables -D FORWARD -m mac --mac-source $i -j DROP
	iptables -D INPUT -m mac --mac-source $i -j DROP
	#iptables -D INPUT -m mac --mac-source $i -j DROP
	done
fi
}

no_use_func()
{
	for i in `cat /proc/wlan0-va0/sta_info|grep hwaddr|awk -F' ' '{print $2}'`
	do 
		is_old_have=0
		for m in `cat /tmp/sta_info_old|awk -F' ' '{print $2}'`
		do
			if [ "-$i" == "-$m" ];then
				is_old_have=1
			fi
		done

		if [ "-$is_old_have" == "-0" ];then
			mac_sta=$(echo $i|tr [a-z] [A-Z])
			if [ -f /etc_rw/static_macip_file ];then
				for j in `cat /etc_rw/static_macip_file|awk -F' ' '{print $1}'`
				do
					mac_str=`echo $j|awk -F':' '{print $1$2$3$4$5$6}'`
					#echo $mac_str
					if [ "$mac_str" == "$mac_sta" ];then
						echo "del $mac_str rule wifi"
						iptables -D FORWARD -m mac --mac-source $j -j DROP
						iptables -D INPUT -m mac --mac-source $j -j DROP
					fi
				done
			fi
		fi
	done
}

refresh_wifirule()
{
	for y in `cat /proc/wlan0-va0/sta_info|grep hwaddr|awk -F' ' '{print $2}'`
	do
		mac_old=$(echo $y|tr [a-z] [A-Z])
		if [ -f /etc_rw/static_macip_file ];then
			for j in `cat /etc_rw/static_macip_file|awk -F' ' '{print $1}'`
			do
				mac_str=`echo $j|awk -F':' '{print $1$2$3$4$5$6}'`
				#echo $mac_str
				if [ "$mac_str" == "$mac_old" ];then
					echo "del $mac_str rule wifi"
					iptables -D FORWARD -m mac --mac-source $j -j DROP
					iptables -D INPUT -m mac --mac-source $j -j DROP
				fi
			done
		fi
	done
}

if [ "-$1" == "-start" ];then
if [[ $(nv get mac_ip_bind) == "1" ]]; then
	sleep 3
	iptables -D INPUT -p udp --dport 67 -j ACCEPT
	iptables -I INPUT -p udp --dport 67 -j ACCEPT
	init_file_rule
#	refresh_wifirule
#	/sbin/tw_ip_mac_refresh in &
fi
fi

if [ "-$1" == "-change" ];then
if [[ $(nv get mac_ip_bind) == "1" ]]; then

	if [ -f /proc/wlan0-va0/sta_info ];then
		#no_use_func  #just mark, not use now
	
		for c in `cat /tmp/sta_info_old|awk -F' ' '{print $2}'`
		do
			is_new_have=0
			for s in `cat /proc/wlan0-va0/sta_info|grep hwaddr|awk -F' ' '{print $2}'`
			do
				if [ "-$c" == "-$s" ];then
					is_new_have=1
				fi
			done

			if [ "-$is_new_have" == "-0" ];then
				mac_sta=$(echo $c|tr [a-z] [A-Z])
				if [ -f /etc_rw/static_macip_file ];then
					for x in `cat /etc_rw/static_macip_file|awk -F' ' '{print $1}'`
					do
						mac_str=`echo $x|awk -F':' '{print $1$2$3$4$5$6}'`
						#echo $mac_str
						if [ "$mac_str" == "$mac_sta" ];then
							#echo "add $mac_str rule wifi"
							iptables -D FORWARD -m mac --mac-source $x -j DROP
							iptables -I FORWARD -m mac --mac-source $x -j DROP
							iptables -D INPUT -m mac --mac-source $x -j DROP
							iptables -A INPUT -m mac --mac-source $x -j DROP
						fi
					done
				fi
			fi
		done
	fi

	cat /proc/wlan0-va0/sta_info|grep hwaddr > /tmp/sta_info_old
fi
fi

if [ "-$1" == "-eth" ];then
if [[ $(nv get mac_ip_bind) == "1" ]]; then
	if [ "-$2" == "-in" ];then
		if [ "-$3" != "-" ];then
			#echo $3
			mac_eth=$(echo $3|tr [a-z] [A-Z])
			#echo $mac_eth
			if [ -f /etc_rw/static_macip_file ];then
				for k in `cat /etc_rw/static_macip_file|awk -F' ' '{print $1}'`
				do
					if [ "-$mac_eth" == "-$k" ];then
						#echo "del $mac_eth rule eth"
						iptables -D FORWARD -m mac --mac-source $k -j DROP
						iptables -D INPUT -m mac --mac-source $k -j DROP
					fi
				done
			fi
			echo $3 > /tmp/eth_mac_old
		fi
	else
		mac_eth=`cat /tmp/eth_mac_old`
		#echo $mac_eth
		if [ -f /etc_rw/static_macip_file ];then
			for q in `cat /etc_rw/static_macip_file|awk -F' ' '{print $1}'`
			do
				if [ "-$mac_eth" == "-$q" ];then
					#echo "add $mac_eth rule eth"
					iptables -D FORWARD -m mac --mac-source $q -j DROP
					iptables -I FORWARD -m mac --mac-source $q -j DROP
					iptables -D INPUT -m mac --mac-source $q -j DROP
					iptables -A INPUT -m mac --mac-source $q -j DROP
				fi
			done
		fi
		echo "" > /tmp/eth_mac_old
	fi
fi
fi

if [ "-$1" == "-del" ];then
if [[ $(nv get mac_ip_bind) == "1" ]]; then
	mac_del=$(echo $2|tr [a-z] [A-Z])
	if [ -f /etc_rw/static_macip_file ];then
		for z in `cat /etc_rw/static_macip_file|awk -F' ' '{print $1}'`
		do
			if [ "-$mac_del" == "-$z" ];then
				#echo "del $mac_del rule eth"
				iptables -D FORWARD -m mac --mac-source $z -j DROP
				iptables -D INPUT -m mac --mac-source $z -j DROP
			fi
		done
	fi
fi
fi
