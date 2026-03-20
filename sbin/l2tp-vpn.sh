#!/bin/sh

################make sure "/etc/xl2tpd/" exists############
if [ ! -d "/etc/xl2tpd/" ];then
	mkdir -p /etc/xl2tpd/;
else
	rm -f /etc/xl2tpd/xl2tpd.conf;
fi

#############make sure "/etc/ppp/peers/" exists##############
if [ ! -d "/etc/ppp/peers/" ];then
        mkdir -p /etc/ppp/peers/;
else         
        rm -f /etc/ppp/peers/test.l2tpd;
fi

###########make sure "/var/run/xl2tpd/l2tp-control" exists##########
if [ ! -d "/var/run/xl2tpd/" ];then
        mkdir -p /var/run/xl2tpd/;
	touch /var/run/xl2tpd/l2tp-control;
elif [ ! -f "/var/run/xl2tpd/l2tp-control" ];then
	touch /var/run/xl2tpd/l2tp-control;                                
fi

################################################################
write_cfg_file(){
	ip_file="/etc/xl2tpd/xl2tpd.conf";
	usr_file="/etc/ppp/peers/test.l2tpd";

	rm -rf /etc/xl2tpd/xl2tpd.conf;
	rm -rf /etc/ppp/peers/test.l2tpd;

	lns_ip=$1;
	l2tp_name=$4;
cat > $ip_file <<EOF
[global]
access control = no
port = 1701

[lac test]
name = $l2tp_name
lns = $lns_ip
pppoptfile = /etc/ppp/peers/test.l2tpd
ppp debug = no
EOF

	user=$2;
	passwd=$3;
	

cat > $usr_file <<EOF
remotename test
user "$user"
password "$passwd"
unit 0
lock
nodeflate
nobsdcomp
noauth
persist
nopcomp
noaccomp
maxfail 5
debug
mtu 1500
EOF
}


##################if enable then connect, else exit.#################
killall -9 xl2tpd;

if [ `nv get "l2tp_enable"` != 1 ];then
	exit 1;
else
	lns_ip=`nv get "l2tp_server"`;
	user_name=`nv get "l2tp_user"`;
	pass_word=`nv get "l2tp_passwd"`;
	l2tp_name=`nv get "l2tp_name"`;
	
	write_cfg_file $lns_ip $user_name $pass_word $l2tp_name;	
	
	xl2tpd -c /etc/xl2tpd/xl2tpd.conf;
	sleep 1;
	echo 'c test' > /var/run/xl2tpd/l2tp-control;
fi

