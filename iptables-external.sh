#!/bin/bash

read -p "Enter your Intenal IP address: " internal_ip

iptables -A INPUT -s $internal_ip/32 -p tcp -m tcp --dport 443 -j ACCEPT
iptables -A INPUT -s $internal_ip/32 -p tcp -m tcp --dport 80  -j ACCEPT
