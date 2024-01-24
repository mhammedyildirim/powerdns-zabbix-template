# Zabbix Template For PowerDNS Monitoring

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
``
