# fail2ban-detect-subnets

# Usage

Copy:
```
cp ./fail2ban-detect-subnets.sh /usr/local/sbin/ 
cp ./fail2ban-detect-subnets-masker.sh /usr/local/sbin/
```

Send fail2ban logs to syslog: <br>
/etc/fail2ban/fail2ban.local:
```
[Definition]
logtarget = syslog
```

Copy fail2ban filter:
```
cp ./fail2ban-detect-subnets.conf /etc/fail2ban/filter.d/
```
Copy fail2ban action:
```
cp ./iptables-multiport-subnet.conf /etc/fail2ban/action.d/
```

Edit jail.local according to your needs.<br>
Example jail.local
```
[DEFAULT]
backend = systemd

[ssh]
enabled = true
filter  = sshd
action = iptables-multiport[port="22", blocktype="DROP", chain="fail2ban"]


[ssh-subnet]
enabled = true
filter = fail2ban-detect-subnets[jail="ssh"]
action = iptables-multiport-subnet[port="22",blocktype="DROP",chain="fail2ban",mask4="24",mask6="64"]
```
Edit fail2ban-detect-subnets-masker.sh according to your needs.<br>
Only jails defined in this script are used.<br>
You can override mask for specific jails.<br>
Example:
```
#!/bin/bash
mask4=28
mask6=64

case $1 in
  "[ssh]") mask4=24 ;;
  "[postfix]") ;;
  "[dovecot]") ;;
  "[nginx]") ;;
  *) exit 0
esac
```
