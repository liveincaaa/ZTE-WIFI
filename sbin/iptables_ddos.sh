if [[ $1 == "ddos_defense" ]];then
if [[ $(nv get ddos_defense) == "1" ]]; then
#Sync Flood, DDOS
echo "start ddos,Sync Flood  defense!!!"
iptables -A FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -p tcp --syn -m limit --limit 1/s  -j ACCEPT
else
iptables -D FORWARD -p tcp --syn -m limit --limit 1/s -j ACCEPT
iptables -D INPUT -p tcp --syn -m limit --limit 1/s  -j ACCEPT
fi
fi

if [[ $1 == "tcp_scan" ]];then
if [[ $(nv get tcp_scan) == "1" ]]; then
#Port Scan, Tcp Scan
echo "start tcp_scan defense!!!"
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
else
iptables -D FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
iptables -D INPUT -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
fi
fi

if [[ $1 == "ping_to_death" ]];then
if [[ $(nv get ping_to_death) == "1" ]]; then
#Ping to death
echo "start ping_to_death defense!!!"
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
else
iptables -D FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
iptables -D INPUT -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
fi
fi
