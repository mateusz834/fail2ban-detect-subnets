# fail2ban-detect-subnets

# Usage

Copy:
```
cp ./fail2ban-detect-subnets.sh /usr/local/sbin/ 
cp ./fail2ban-detect-subnets-masker.sh /usr/local/sbin/
cp ./fail2ban-detect-subnets.service /etc/systemd/system/
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

Create config directory:<br>
```
sudo mkdir /usr/local/etc/fail2ban-detect-subnets
```

Edit /usr/local/etc/fail2ban-detect-subnets/conf according to your needs.<br>
config line syntax: <br>
```
{jail-name} {mask-ipv4} {mask-ipv6}
```
Example:
```
ssh 24 64
nginx 22 96
```
Run fail2ban-detect-subnets:
```
systemctl start fail2ban-detect-subnets
systemctl enable fail2ban-detect-subnets
```
