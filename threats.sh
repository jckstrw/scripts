#!/bin/bash 

#==============================================================================
#Emerging Threats - Shadowserver C&C List, Spamhaus DROP Nets, Dshield Top
#Attackers
#==============================================================================

wget http://rules.emergingthreats.net/fwrules/emerging-Block-IPs.txt -O /tmp/emerging-Block-IPs.txt --no-check-certificate

echo "# Generated: `date`" > /home/jmatthews/threat/emerging_threats_shadowserver_ips.txt

cat /tmp/emerging-Block-IPs.txt | sed -e '1,/# \Shadowserver C&C List/d' -e '/#/,$d' | sed -n '/^[0-9]/p' | sed 's/$/ Shadowserver IP/' >> /home/jmatthews/threat/emerging_threats_shadowserver_ips.txt

echo "# Generated: `date`" > /home/jmatthews/threat/emerging_threats_spamhaus_drop_ips.txt

cat /tmp/emerging-Block-IPs.txt | sed -e '1,/#Spamhaus DROP Nets/d' -e '/#/,$d' | xargs -n 1 prips | sed -n '/^[0-9]/p' | sed 's/$/ Spamhaus IP/' >> /home/jmatthews/threat/emerging_threats_spamhaus_drop_ips.txt

echo "# Generated: `date`" > /home/jmatthews/threat/emerging_threats_dshield_ips.txt

cat /tmp/emerging-Block-IPs.txt | sed -e '1,/#Dshield Top Attackers/d' -e '/#/,$d' | xargs -n 1 prips | sed -n '/^[0-9]/p' | sed 's/$/ Dshield IP/' >> /home/jmatthews/threat/emerging_threats_dshield_ips.txt

rm /tmp/emerging-Block-IPs.txt

#==============================================================================
#Emerging Threats - Compromised IP List
#==============================================================================

wget http://rules.emergingthreats.net/blockrules/compromised-ips.txt -O /tmp/compromised-ips.txt --no-check-certificate

echo "# Generated: `date`" > /home/jmatthews/threat/emerging_threats_compromised_ips.txt

cat /tmp/compromised-ips.txt | sed -n '/^[0-9]/p' | sed 's/$/ Compromised IP/' >> /home/jmatthews/threat/emerging_threats_compromised_ips.txt

rm /tmp/compromised-ips.txt

#==============================================================================
#Binary Defense Systems Artillery Threat Intelligence Feed and Banlist Feed
#==============================================================================

wget http://www.binarydefense.com/banlist.txt -O /tmp/binary_defense_ips.txt --no-check-certificate

echo "# Generated: `date`" > /home/jmatthews/threat/binary_defense_ban_list.txt

cat /tmp/binary_defense_ips.txt | sed -n '/^[0-9]/p' | sed 's/$/ Binary Defense IP/' >> /home/jmatthews/threat/binary_defense_ban_list.txt

rm /tmp/binary_defense_ips.txt

#==============================================================================
#AlienVault - IP Reputation Database
#==============================================================================

wget https://reputation.alienvault.com/reputation.snort.gz -P /tmp --no-check-certificate

gzip -d /tmp/reputation.snort.gz

echo "# Generated: `date`" > /home/jmatthews/threat/av_ip_rep_list.txt

cat /tmp/reputation.snort | sed -n '/^[0-9]/p' | sed "s/# //">> /home/jmatthews/threat/av_ip_rep_list.txt

rm /tmp/reputation.snort

#==============================================================================
#SSLBL - SSL Blacklist
#==============================================================================

wget https://sslbl.abuse.ch/blacklist/sslipblacklist.csv -O /tmp/sslipblacklist.csv --no-check-certificate

echo "# Generated: `date`" > /home/jmatthews/threat/sslipblacklist.txt

cat /tmp/sslipblacklist.csv | sed -n '/^[0-9]/p' | cut -d',' -f1,3 | sed "s/,/ /" | sed 's/$/ SSLBL IP/' >> /home/jmatthews/threat/sslipblacklist.txt

rm /tmp/sslipblacklist.csv

#==============================================================================
#ZeuS Tracker - IP Block List
#==============================================================================

wget https://zeustracker.abuse.ch/blocklist.php?download=ipblocklist -O /tmp/zeustracker.txt --no-check-certificate

echo "# Generated: `date`" > /home/jmatthews/threat/zeus_ip_block_list.txt

cat /tmp/zeustracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Zeus IP/' >> /home/jmatthews/threat/zeus_ip_block_list.txt

rm /tmp/zeustracker.txt

#==============================================================================
#SpyEye Tracker - IP Block List
#==============================================================================

wget https://spyeyetracker.abuse.ch/blocklist.php?download=ipblocklist -O /tmp/spyeyetracker.txt --no-check-certificate

echo "# Generated: `date`" > /home/jmatthews/threat/spyeye_ip_block_list.txt

cat /tmp/spyeyetracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Spyeye IP/' >> /home/jmatthews/threat/spyeye_ip_block_list.txt

rm /tmp/spyeyetracker.txt

#==============================================================================
#Palevo Tracker - IP Block List
#==============================================================================

wget https://palevotracker.abuse.ch/blocklists.php?download=ipblocklist -O /tmp/palevotracker.txt --no-check-certificate

echo "# Generated: `date`" > /home/jmatthews/threat/palevo_ip_block_list.txt

cat /tmp/palevotracker.txt | sed -n '/^[0-9]/p' | sed 's/$/ Palevo IP/' >> /home/jmatthews/threat/palevo_ip_block_list.txt

rm /tmp/palevotracker.txt

#==============================================================================
#Malc0de - Malc0de Blacklist
#==============================================================================

wget http://malc0de.com/bl/IP_Blacklist.txt -O /tmp/IP_Blacklist.txt --no-check-certificate

echo "# Generated: `date`" > /home/jmatthews/threat/malc0de_black_list.txt

cat /tmp/IP_Blacklist.txt | sed -n '/^[0-9]/p' | sed 's/$/ Malc0de IP/' >> /home/jmatthews/threat/malc0de_black_list.txt

rm /tmp/IP_Blacklist.txt
