#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail
journalctl -u fail2ban.service  -f -n 0 | grep -io "\[\S*] Found \S*" --line-buffered  | xargs -n3 -P 16 /usr/local/sbin/fail2ban-detect-subnets-masker.sh  | logger -t "fail2ban-detect-subnets"
