# ProxyHotspot

Proxy the traffic from all your devices on your local network!

## What is the idea here?

There is a SOCKS5 proxy available via ssh dynamic port forwarding. We want to share this proxy with other devices on the local network.

For example, you have a SOCKS5 proxy on your PC at localhost:1234 and you want your phone to use this proxy as well.

## What are the requirements?

- A server which can be reached by SSH
- A linux distro on local PC (e.g. Ubuntu)
- Redsocks

## How to can I do it?

- You need to have a wired connection to the internet. Like by using an ethernet cable or connecting your phone's LTE to your PC using your phone cable.
- Your PC will act as a hotspot and your other devices will need to connect to your PC to access the Internet.
	- The way you can set up your hotspot is available on the Internet.
	- For Ubuntu, you can start your hotspot by using network manager cli. nmcli up for starting and nmcli down for stopping your hotspot.
	- Also, you need to run `nmcli c modify Hotspot 802-11-wireless-security.pmf 1` in case the hotspot does not start. c is for connection in the command!
- Now that your hotspot is on and reachable by your devices, you need to start your proxy server.
	- You need a vps or any server that has ssh access for this step. ssh dynamic port forwarding (poor man's VPN) is used here.
	- By running `ssh -D PROXY_PORT -p SSH_PORT USER@SERVER_IP` you can start the local SOCKS5 proxy server on localhost:PROXY_PORT which makes any traffic that goes through PROXY_PORT look like it is going through SERVER_IP at another location.
		- On a side note, you can use this proxy server on Firefox to browse the web through SERVER_IP location!
		- You can add the proxy details in Network Settings of Firefox.
		- Remember to proxy DNS as well!
- With proxy server on, you now need to make any incoming traffic from the hotspot go through your local proxy server.
	- You first need to know that the hotspot and proxy server act differently as they use different protocols. The hostspot is using TCP but the proxy server is using SOCKS5 protocol. So, by just simply forwarding any traffic coming in from your hotspot to the local proxy server you can not achieve what we want to do here. You need to first somehow make these two different protocols understand each other and be able to interact. Like a conversion from TCP to SOCKS5. This is where redsocks comes to play.
	- redsocks is available on apt-get but you NEED to clone the project from Github for it to work in this method since the Github version has couple more features that you have to use.
	- Before working with redsocks, run `sudo sysctl -w net.ipv4.ip_forward=1`.
	- You need to make a config file for redsocks to work with. In the redsocks folder there is a `redsocks.conf.example` which has the default config in it. You can either use that file to write your config or start one from scratch if you like.
	- In the `redsocks.conf.example`, you need to change a couple of values. In the redsocks section, you need to change local_ip to 0.0.0.0 which means from any ip. You can also specifically mention the interface that you need the forwarding for. Like if you set 0.0.0.0 everything including your PC will route its traffic through the proxy. But if you say for example 1.2.3.0 this will only apply to ips starting with 1.2.3 which can be for example your hotspot.
	- ip and port needs to be your proxy address which is localhost:PROXY_PORT (127.0.0.1:PROXY_PORT)
	- type must be SOCKS5. The other part can stay the same.
	- Now that the config file is ready you can start redsocks by running `./redsocks -c redsocks.conf.example`
	- With redsocks on, you need to run `./iptables-proxify` to forward all traffic through the local proxy server.
	- For returning to normal and stop the forwarding, you can simply run `./iptables-nuke`

## But, what is happening in this iptables-proxify script?

This script is simply just forwarding your tcp and udp packets through the ports redsocks provides. For TCP, the script is routing all ports except PROXY_PORT through port 12345 which is the port redsocks mentions in the config file for local_port. Like redsocks is telling you that instead of sending your traffic directly to PROXY_PORT, send it through local_port that I provide for the conversion issue you had. That's the whole point of redsocks! You send your traffic to local_port and then redsocks does its conversion and sent it to PROXY_PORT. Also, the reason for excluding PROXY_PORT is that otherwise there will be an endless cycle of forwarding which means nothing can actually reach the server and proxying fails. For correct traffic forwading, you MUST set the rules for both OUTPUT and PREROUTING in iptables. Doing just these steps can make what we want happen in most cases. But, you can have issues with your DNS. You need to send the DNS traffic through proxy as well. For that, port 53 is important because the DNS traffic goes through this port. So, forwarding port 53 is also required. For DNS, UDP is used but you need to forward TCP from port 53 as well. You need to forward this traffic to port 5313 which is again provided by redsocks just like TCP from before in the config file. The port 5313 is mentioned in the config file under dnsu2t local_port. The need for forwarding DNS traffic is the reason you must clone redsocks from Github. On the apt-get version of redsocks, the dnsu2t is not available.

## What is happening in iptables-nuke script?

Basically it's just resetting everything in iptables. Accepting connections, clearning nat and resetting iptables. By running this script, you will undo everything and return to just sending your traffic the normal way.


## Notes

- run `sudo apt-get purge --auto-remove redsocks` to completely remove redsocks in case you mistakenly installed it using apt-get.

- If you have rules in your iptables be carful with `./iptables-nuke`. This will return your iptables to default.