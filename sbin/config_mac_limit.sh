#!/bin/sh
path_conf=`nv get path_conf`
fname=$path_conf"/mac_speed_limit_file"
fbak=$path_conf"/mac_speed_limit_file_bak"

limit_config()
{
	if [ "x$1" = "x" ]; then
        echo "insufficient arguments.."
	elif [ "x$2" = "x" ]; then
        sed -e "/$1/d" $fname > $fbak
        cat $fbak > $fname
        rm -f $fbak
	elif [ "x$3" = "x" ]; then
        echo "insufficient arguments.."
	elif [ "x$4" = "x" ]; then
        echo "insufficient arguments.."
	else # $1 mac, $2 ip, $3 upload, $4 download 
        sed -e "/$1/d" $fname > $fbak
        echo "$1 $2 $3 $4" >> $fbak
        cat $fbak > $fname
        rm -f $fbak
	fi
}

device_add()
{
	if [ "x$1" = "x" ]; then
        echo "insufficient arguments.."
	elif [ "x$2" = "x" ]; then
        echo "insufficient arguments.."
	elif [ "x$3" = "x" ]; then
        echo "insufficient arguments.."
	else # $1 ip, $2 upload, $3 download 
		iptables -A FORWARD -m limit -d $1 --limit $2/s -j ACCEPT 
		iptables -A FORWARD -d $1 -j DROP
		iptables -A FORWARD -m limit -s $1 --limit $3/s -j ACCEPT 
		iptables -A FORWARD -s $1 -j DROP
	fi
}

device_del()
{
	if [ "x$1" = "x" ]; then
        echo "insufficient arguments.."
	elif [ "x$2" = "x" ]; then
        echo "insufficient arguments.."
	elif [ "x$3" = "x" ]; then
        echo "insufficient arguments.."
	else # $1 ip, $2 upload, $3 download 
		iptables -D FORWARD -m limit -d $1 --limit $2/s -j ACCEPT 
		iptables -D FORWARD -d $1 -j DROP
		iptables -D FORWARD -m limit -s $1 --limit $3/s -j ACCEPT 
		iptables -D FORWARD -s $1 -j DROP
	fi
}

init_device()
{
	if [ ! -f $fname ]; then
		exit 0
	fi
	while read line
	do
		ipaddr=`echo $line|awk '{print $2}'`
		upload=`echo $line|awk '{print $3}'`
		download=`echo $line|awk '{print $4}'`
		upload_s=`expr ${upload} \* 1024 / 1500`
		download_s=`expr ${download} \* 1024 / 1500`
		device_add $ipaddr $upload_s $download_s
	done < $fname
}

if [ "$1" = "config" ]; then
	limit_config $2 $3 $4 $5
elif [ "$1" = "device_add" ]; then
	device_add $2 $3 $4
elif [ "$1" = "device_del" ]; then
	device_del $2 $3 $4
elif [ "$1" = "init" ]; then
	init_device
fi
