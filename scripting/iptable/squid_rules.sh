
ssh anoop@192.168.1.82 'bash -s' < /home/allerin/Desktop/squid/squid_site/./


# 1.  Router 192.168.1.82 traffic to squid
iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.0/24 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.0/24 -p tcp --dport 443 -j DNAT --to-destination 192.168.1.20:3128

iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.0/24 -p tcp --dport 80 -j DNAT --to-destination 127.0.0.1:3128
iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.0/24 -p tcp --dport 443 -j DNAT --to-destination 127.0.0.1:3128

or 

iptables -t nat -I PREROUTING -p tcp -m multiport --dport 80,443 -j DNAT --to-destination 127.0.0.1:3128


# 2. Router the traffic from  range. 

iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.82 -p tcp --dport 80 -m iprange  --src-range 192.168.1.2-192.168.1.120 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.82 -p tcp --dport 443 -m iprange  --src-range 192.168.1.2-192.168.1.120 -j DNAT --to-destination 192.168.1.20:3128

or 

iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.82 -p tcp -m multiport --dport 80,443 -m iprange  --src-range 192.168.1.2-192.168.1.120 -j DNAT --to-destination 192.168.1.20:3128

# 3. Block Forwarding 80 , 443 

iptables -I FORWARD -m mac --mac-source 88:b9:45:47:60:d6 -j DROP

iptables -I FORWARD -p tcp -m multiport --dports 80,443 -m iprange  --src-range 192.168.1.2-192.168.1.120 -j DROP


# If forward will block, then internet run only browser proxy only.





# 1. Route Pre-routing

iptables -t filter -I FORWARD -i enp2s0  -s 192.168.1.0/24 -d 192.168.1.20 -j ACCEPT
iptables -t nat -I PREROUTING -i enp2s0  -s 192.168.1.82 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I PREROUTING -i enp2s0  -s 192.168.1.82 -p tcp --dport 443 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -A POSTROUTING -o enp2s0 -p tcp --dport 443 -d 192.168.1.20 -j SNAT --to-source 192.168.1.82

iptables -t nat -I POSTROUTING -o enp2s0 -j SNAT --to-source 192.168.1.82

iptables -I POSTROUTING -t nat -p tcp -d 192.168.1.82 --dport 3128 -j MASQUERADE


# 2. Route INput

iptables -t nat -I PREROUTING  -p tcp -m multiport --dports 80,443 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I POSTROUTING -p tcp -d 192.168.1.20  -m multiport --dports 80,443 -j SNAT --to-source 192.168.1.82


# 3. Rewrite

iptables -t nat -I PREROUTING  -p tcp -m multiport --dport 80,443 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I POSTROUTING -p tcp -s 192.168.1.20 -m multiport --dport 80,443 -j MASQUERADE

export http_proxy=192.168.1.20:3128
squid -k reconfigure


sudo nano /etc/profile.d/proxy.sh
export http_proxy="192.168.1.20:3128/"
export https_proxy="192.168.1.20:3128/"
export no_proxy="127.0.0.1"
sudo chmod +x  /etc/profile.d/proxy.sh
source /etc/profile.d/proxy.sh
env | grep -i proxy

restart




iptables -t filter -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t filter -A FORWARD -i enp2s0 -p tcp --dport 443 -j ACCEPT
iptables -t nat -A POSTROUTING -o enp2s0 -j SNAT
iptables -t nat -A PREROUTING -i enp2s0 -p tcp -m multiport --dport 80,443 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -A PREROUTING -i enp2s0 -p tcp -m multiport --dport 80,443 -j REDIRECT --to-ports 3128

iptables -t nat -A POSTROUTING -o enp2s0 -p tcp -m multiport --dport 80,443 -d 192.168.1.0/24 -j SNAT --to-source 192.168.1.20



sudo iptables -A PREROUTING -t nat -p tcp --dport 443 -j DNAT --to-destination 192.168.1.20:3128
sudo iptables -A POSTROUTING -t nat -p tcp --dport 443 -j SNAT --to-source 192.168.1.20



iptables -t nat -A OUTPUT -p tcp --dport 443 -j REDIRECT --to-ports 3128

iptables -t nat -I OUTPUT -p tcp --dport 443 -j DNAT --to-destination 192.168.1.20:3128


iptables -t nat -I OUTPUT -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3128
iptables -t nat -I OUTPUT -p tcp -m tcp --dport 80 -j REDIRECT --to-ports 3128

iptables -t nat -I INPUT -p tcp --dport 80 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I INPUT -p tcp --dport 443 -j DNAT --to-destination 192.168.1.20:3128





sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3128
sudo iptables -t nat -I PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 3128

iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.82 -p all -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.82 -p tcp --dport 443 -j DNAT --to-destination 192.168.1.20:3128

iptables -t nat -I PREROUTING -i enp2s0  -p tcp --dport 80 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I PREROUTING -i enp2s0  -p tcp --dport 443 -j DNAT --to-destination 192.168.1.20:3128


iptables -A PREROUTING -t nat -i enp2s0 -p tcp --dport 443 -j REDIRECT --t-port 


tcptrack -i enp2s0 port 3128

iptables -t nat -I POSTROUTING -j MASQUERADE


iptables -t nat -I PREROUTING -s 192.168.1.0/24 -d 192.168.1.20 -p tcp -j DNAT --to-destination 192.168.1.20:3128

iptables -t nat -I PREROUTING -p tcp -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I POSTROUTING -p tcp -d 192.168.1.20 --dport 80 -j SNAT --to-source 192.168.1.82


iptables -t nat -A PREROUTING -s 192.168.1.0/24 -p tcp --dport 3128 -j DNAT --to-destination 192.168.1.20:3128
iptables -t nat -I POSTROUTING -j MASQUERADE


iptables -t mangle -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --set-mss 1452


iptables -t nat -A OUTPUT -p tcp -m tcp --dport 443 -j DNAT --to-destination 127.0.0.1:80

iptables -t nat -A OUTPUT -p tcp -m tcp --dport 443 -j DNAT --to-destination 127.0.0.1:3128



iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -I PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 80

iptables -t nat -A PREROUTING -i enp2s0 -s 0.0.0.0/24 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.20:80
iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.0/24 -p tcp --dport 443 -j DNAT --to-destination 192.168.1.20:3128


iptables -t nat -I PREROUTING -i enp2s0 -s 0.0.0.0/0 -d 0.0.0.0/0 -p tcp --dport 80 -j REDIRECT --to-port 3128
iptables -t nat -I PREROUTING -i enp2s0 -s 0.0.0.0/0 -d 0.0.0.0/0 -p tcp --dport 80 -j DNAT --to-destination 192.168.1.20:80




iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.0/24 -d 192.168.1.20  -p tcp --dport 80 -j DNAT --to-destination 127.0.0.1:3128
iptables -t nat -I PREROUTING -i enp2s0 -s 192.168.1.0/24 -d 192.168.1.20  -p tcp --dport 443 -j DNAT --to-destination 127.0.0.1:312
iptables -I PREROUTING -t nat -i enp2s0  -p tcp --dport 443 -j REDIRECT --to-port 3128

firewall-cmd --permanent --zone=public --add-forward-port=port=3128:proto=tcp:toaddr=192.168.1.20:toport=443
firewall-cmd --permanent --zone=public --add-forward-port=port=443:proto=tcp:toport=3128:toaddr=192.168.1.20
firewall-cmd --permanent --zone=public --add-masquerade
firewall-cmd --reload

sudo cp -pR /etc/firewalld/zones /etc/firewalld/zones.bak
sudo rm -f /etc/firewalld/zones/*
sudo systemctl restart firewalld

firewall-cmd --permanent --zone=public --add-forward-port=port=443:proto=tcp:toaddr=192.168.1.20:toport=3128
firewall-cmd --permanent --zone=public --add-masquerade
firewall-cmd --reload
firewall-cmd --list-all

firewall-cmd --permanent --zone=public --add-forward-port=port=443:proto=tcp:toport=3128:toaddr=192.168.1.20
firewall-cmd --permanent --zone=public --add-port=3128/tcp
firewall-cmd --reload
firewall-cmd --list-all



