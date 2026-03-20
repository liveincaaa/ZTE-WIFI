#!/bin/sh

wan_ping_enable=`nv get wan_ping_enable`
wan_remote_enable=`nv get wan_remote_enable`
default_wan_rel=`nv get default_wan_rel`
wan_remote_port=`nv get wan_remote_port`

iptables -F port_control
iptables -t filter -D INPUT -j port_control
iptables -N port_control
iptables -I INPUT -j port_control

wan_ping_enable=`nv get wan_ping_enable`
if [ "x$wan_ping_enable" == "x1" ]; then
    iptables -I port_control -i $default_wan_rel -p icmp --icmp-type echo-request -j ACCEPT
else
    iptables -I port_control -i $default_wan_rel -p icmp --icmp-type echo-request -j DROP
fi

iptables -t nat -D PREROUTING -j ipanel_port_forward
iptables -t nat -X ipanel_port_forward
iptables -t nat -N ipanel_port_forward
iptables -t nat -I PREROUTING -j ipanel_port_forward
iptables -t nat -F ipanel_port_forward
iptables -t nat -D PREROUTING -i $default_wan_rel -p tcp --dport 80 -j REDIRECT --to-port 8080
iptables -t nat -I PREROUTING -i $default_wan_rel -p tcp --dport 80 -j REDIRECT --to-port 8080
if [ "x$wan_remote_enable" == "x1" ]; then
    iptables -I port_control -p tcp --dport 80 -i $default_wan_rel -j ACCEPT
    iptables -t nat -I ipanel_port_forward -i $default_wan_rel -p tcp --dport $wan_remote_port -j REDIRECT --to-port 80
fi

