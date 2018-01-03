#!/bin/sh -x
#Firewall (IPTables) Configuration

#Flush/remove all existing rules
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -F

#Allow stablished/related connetions
sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# https://www.digitalocean.com/community/tutorials/iptables-essentials-common-firewall-rules-and-commands
#Allow All Incoming SSH
sudo iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED -j ACCEPT


#Allow Outgoing SSH
#sudo iptables -A OUTPUT -p tcp --dport 22 -m conntrack --ctstate NEW,ESTABLISHED,RELATED -j ACCEPT
#sudo iptables -A INPUT -p tcp --sport 22 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT


#Allowing ALL DNS lookups (tcp, udp port 53)
sudo iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
sudo iptables -A INPUT  -p udp --sport 53 -m state --state ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
sudo iptables -A INPUT  -p tcp --sport 53 -m state --state ESTABLISHED -j ACCEPT

#Allow connections to subnet 142.34.0.0
sudo iptables -A OUTPUT -d 142.34.0.0/16 -m state --state NEW,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -d marketplace-cdn.atlassian.com -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "marketplace-cdn.atlassian.com"
sudo iptables -A OUTPUT -d marketplace.atlassian.com -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "marketplace.atlassian.com"
sudo iptables -A OUTPUT -d updates.jenkins-ci.org -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "updates.jenkins-ci.org"
sudo iptables -A OUTPUT -d mirrors.jenkins-ci.org -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "mirrors.jenkins-ci.org"
sudo iptables -A OUTPUT -d ftp-chi.osuosl.org -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "mirrors.jenkins-ci.org/ftp-chi.osuosl.org"
sudo iptables -A OUTPUT -d ftp-nyc.osuosl.org -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "mirrors.jenkins-ci.org/ftp-nyc.osuosl.org"


sudo iptables -A OUTPUT -d 63.246.22.32/27 -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "Atlassian's servers"
sudo iptables -A OUTPUT -d 63.246.22.192/27 -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "Atlassian's servers"
sudo iptables -A OUTPUT -d 67.221.237.0/27 -m state --state NEW,ESTABLISHED -j ACCEPT -m comment --comment "Atlassian's servers"

sudo iptables -A INPUT -s localhost -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A OUTPUT -d localhost -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT

#YUM repositories/mirrors
sudo iptables -A OUTPUT -d mirror.csclub.uwaterloo.ca -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED -m comment --comment "mirror.csclub.uwaterloo.ca"
sudo iptables -A OUTPUT -d mirror.it.ubc.ca -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED -m comment --comment "mirror.it.ubc.ca"
sudo iptables -A OUTPUT -d centos.mirror.vexxhost.com -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED -m comment --comment "centos.mirror.vexxhost.com"
sudo iptables -A OUTPUT -d fedora-epel.mirror.lstn.net -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED -m comment --comment "fedora-epel.mirror.lstn.net"

sudo iptables -A OUTPUT -d muug.ca -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED -m comment --comment "muug.ca"
sudo iptables -A OUTPUT -d mirror.its.sfu.ca -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED -m comment --comment "mirror.its.sfu.ca"
sudo iptables -A OUTPUT -d centos.mirror.iweb.ca -j ACCEPT -m state --state NEW,RELATED,ESTABLISHED -m comment --comment "centos.mirror.iweb.ca"


#Logs all traffic about to be blocked
#iptables -A INPUT -j LOG --log-prefix "DROP INPUT: " --log-level 7
#iptables -A OUTPUT -j LOG --log-prefix "DROP OUTPUT: " --log-level 7

#Blocks all other traffic not explicitly previously allowed
#sudo iptables -D OUTPUT -j DROP
sudo iptables -A OUTPUT -j DROP

#show iptables
sudo iptables -nL --line-numbers