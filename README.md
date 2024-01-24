# Zabbix Template For PowerDNS Monitoring

## How It Works
This template collects PowerDNS metrics with Zabbix agent 2. Metrics come from 2 different parts. The first one is collected with the ```pdns_control show *``` command. The second one is collected with the ```pdns_query_check.sh``` script.

In order for the pdns_query_check.sh script to work, the DNS A record of the server's hostname must be registered on the PowerDNS server.

## Disclaimer
This template allows you to monitor [specified metrics](https://github.com/mhammedyildirim/powerdns-zabbix-template#metrics). There are only 3 pre-configured triggers. These are pre-configured trigger: ```PowerDNS: pdns.make-dns-query```, ```PowerDNS: security-status (Mandatory Upgrade)```, ```PowerDNS: security-status (Recommended Upgrade)``` .

The instructions and template were tested on Rocky Linux 9, PowerDNS version 4.8.3, Zabbix 6.0 LTS and Zabbix Agent 2 6.0 LTS

## Metrics
```
backend-queries
corrupt-packets
deferred-cache-inserts
deferred-cache-lookup
deferred-packetcache-inserts
deferred-packetcache-lookup
dnsupdate-answers
dnsupdate-changes
dnsupdate-queries
dnsupdate-refused
incoming-notifications
noerror-packets
nxdomain-packets
overload-drops
packetcache-hit
packetcache-miss
packetcache-size
query-cache-hit
query-cache-miss
query-cache-size
rd-queries
recursing-answers
recursing-questions
recursion-unanswered
security-status
servfail-packets
signatures
tcp-answers
tcp-answers-bytes
tcp-cookie-queries
tcp-queries
tcp4-answers
tcp4-answers-bytes
tcp4-queries
tcp6-answers
tcp6-answers-bytes
tcp6-queries
timedout-packets
udp-answers
udp-answers-bytes
udp-cookie-queries
udp-do-queries
udp-queries
udp4-answers
udp4-answers-bytes
udp4-queries
udp6-answers
udp6-answers-bytes
udp6-queries
unauth-packets
zone-cache-hit
zone-cache-miss
zone-cache-size
backend-latency
cache-latency
cpu-iowait
cpu-steal
fd-usage
key-cache-size
latency
meta-cache-size
open-tcp-connections
qsize-q
real-memory-usage
receive-latency
ring-logmessages-capacity
ring-logmessages-size
ring-noerror-queries-capacity
ring-noerror-queries-size
ring-nxdomain-queries-capacity
ring-nxdomain-queries-size
ring-queries-capacity
ring-queries-size
ring-remotes-capacity
ring-remotes-corrupt-capacity
ring-remotes-corrupt-size
ring-remotes-size
ring-remotes-unauth-capacity
ring-remotes-unauth-size
ring-servfail-queries-capacity
ring-servfail-queries-size
ring-unauth-queries-capacity
ring-unauth-queries-size
send-latency
signature-cache-size
sys-msec
udp-in-csum-errors
udp-in-errors
udp-noport-errors
udp-recvbuf-errors
udp-sndbuf-errors
udp6-in-csum-errors
udp6-in-errors
udp6-noport-errors
udp6-recvbuf-errors
udp6-sndbuf-errors
uptime
user-msec
xfr-queue
```

## Installation
```
cat << 'EOF' > /etc/sudoers.d/pdns
# Zabbix Agent PDNS
Defaults:zabbix !requiretty
zabbix ALL=NOPASSWD: /usr/bin/pdns_control, /var/run/pdns/pdns.controlsocket
EOF
```
```
cat << 'EOF' > /etc/zabbix/zabbix_agent2.d/plugins.d/pdns.conf
UserParameter=pdns.stats[*],/usr/bin/sudo /usr/bin/pdns_control show $1
UserParameter=pdns.make-dns-query, /usr/local/bin/pdns_query_check.sh
EOF
```
```
cat << 'EOF' > /root/pdns_query_check.sh
#!/bin/bash

hostname=$(hostname -f)

dig_output=$(dig A $hostname @localhost +short)

if [ $? -gt 0 ] || [[ -z $dig_output ]]; then
    echo "FAIL"
    exit 1
fi

echo "OK"
exit 0
EOF
```
```
systemctl restart zabbix-agent2.service
```
