#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

l=""
while read line; do
	jail="$(echo "$line" | awk '{print $1}')"
	if [ "[$jail]" == "$1" ]; then
		l="$line"
		break
	fi
done <$config

if [ -z "$l" ]; then
	exit 0
fi

mask4="$(echo "$l" | awk '{print $2}')"
mask6="$(echo "$l" | awk '{print $3}')"

[ -z "$mask4" ] && exit 1
[ -z "$mask6" ] && exit 1

masked=""

set +o errexit
set +o pipefail
sipcalc "$2" | grep ipv6 >> /dev/null 2>&1
if [ $? == '0' ]; then
	set -o errexit
	set -o pipefail
	masked="$(sipcalc "$2/$mask6" | grep "Subnet prefix (masked)" | awk '{print $5}' | sed 's/\/.*//')"
else
	set -o errexit
	set -o pipefail
	masked="$(sipcalc "$2/$mask4" | grep "Network address" | awk '{print $4 }')"
fi
echo "$1 $masked"
