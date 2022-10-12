#!/bin/bash

read -p "Enter your Extenal IP address: " external_ip
internal_ip=$(hostname -I | awk '{print $1}')
echo $internal_ip


sysctl -w net.ipv4.ip_forward=1
iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
iptables -t nat -A PREROUTING -d $internal_ip/32 -p tcp -m tcp --dport 80  -j DNAT --to-destination $external_ip:80
iptables -t nat -A PREROUTING -d $internal_ip/32 -p tcp -m tcp --dport 443 -j DNAT --to-destination $external_ip:443
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -A FORWARD -j ACCEPT
