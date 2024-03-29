#!/bin/bash

sudo iptables -t nat -A OUTPUT -p tcp ! --dport 8569 -j REDIRECT --to-ports 12345
sudo iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5313
sudo iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 5313
sudo iptables -t nat -A PREROUTING -p tcp ! --dport 8569 -j REDIRECT --to-ports 12345
sudo iptables -t nat -A PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5313
sudo iptables -t nat -A PREROUTING -p tcp --dport 53 -j REDIRECT --to-ports 5313
