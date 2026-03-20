#!/bin/sh

################make sure "/etc/ppp/peers/" exists############
if [ ! -d "/etc/ppp/peers/" ];then
	mkdir -p /etc/ppp/peers/;
	if [ ! -f "/etc/ppp/ip-down" ];then
		ln -s /sbin/vpn-ip-down.sh  /etc/ppp/ip-down
	fi
	if [ ! -f "/etc/ppp/ip-up" ];then
		ln -s /sbin/vpn-ip-up.sh  /etc/ppp/ip-up
	fi
else
	if [ ! -f "/etc/ppp/ip-down" ];then
		ln -s /sbin/vpn-ip-down.sh  /etc/ppp/ip-down
	fi
	if [ ! -f "/etc/ppp/ip-up" ];then
		ln -s /sbin/vpn-ip-up.sh  /etc/ppp/ip-up
	fi
	rm -f /etc/ppp/peers/connectvpn;
fi

#############make sure "/etc/ppp/" exists##############
if [ ! -d "/etc/ppp/" ];then
        mkdir -p /etc/ppp/;
else         
        rm -f /etc/ppp/options.pptp;
fi

################################################################
write_cfg_file(){
	cfg_file="/etc/ppp/peers/connectvpn";

	rm -rf /etc/ppp/peers/connectvpn;

	server_ip=$1;
	user=$2;
	passwd=$3;
	pptpname=$4;
	auth_type=$5;
	

cat > $cfg_file <<EOF
pty "pptp $server_ip --nolaunchpppd"
noauth
refuse-eap
name $user
password $passwd
remotename $pptpname
file /etc/ppp/options.pptp
EOF

	opt_file="/etc/ppp/options.pptp";
	rm -rf /etc/ppp/options.pptp;
	
cat > $opt_file <<EOF
lock
require-$auth_type
nobsdcomp
nodeflate
noauth
mtu 1500
mru 1500
EOF
}


##################if enable then connect, else exit.#################
killall -9 pptp;

if [ `nv get "pptp_enable"` != 1 ];then
	exit 1;
else
	server_addr=`nv get "pptp_server"`;
	user_name=`nv get "pptp_user"`;
	pass_word=`nv get "pptp_passwd"`;
	pptp_name=`nv get "pptp_name"`;
	auth_type=`nv get "pptp_auth_type"`;
	if [ $auth_type == auto ];then
		auth_type=chap;
	fi

	write_cfg_file $server_addr $user_name $pass_word $pptp_name $auth_type;
	
	/usr/sbin/pppd call connectvpn;
fi

