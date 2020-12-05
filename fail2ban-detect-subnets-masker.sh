#!/bin/bash
set -o nounset
mask4=28
mask6=64

case $1 in
  "[ssh]") mask4=24 ;;
  "[postfix]") ;;
  "[dovecot]") ;;
  "[nginx]") ;;
  *) exit 0
esac

masked=""

sipcalc "$3" | grep ipv6 > /dev/null 2>&1
if [ $? == '0' ]; then
	set -o errexit
	set -o pipefail
	masked="$(sipcalc "$3/$mask6" | grep "Subnet prefix (masked)" | awk '{print $5}' | sed 's/\/.*//')"
else
	set -o errexit
	set -o pipefail
	masked="$(sipcalc "$3/$mask4" | grep "Network address" | awk '{print $4 }')"
fi
echo "$1 $masked"
