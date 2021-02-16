#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail

dconfig="/usr/local/etc/fail2ban-detect-subnets/conf"
dmasker="/usr/local/sbin/fail2ban-detect-subnets-masker.sh"

function help() 
{
	echo "Syntax:"
	echo -e "\t$0 [-c config] [-m masker-file]"
	echo -e "\t\tconfig default: $dconfig"
	echo -e "\t\tmasker-file default: $dmasker"
	exit 1
}

config=$dconfig
masker=$dmasker

for i in "$@"; do
	if [[ "$i" == "--help" || "$1" == "-h" ]]; then
		help 
	fi
done

while getopts c:m: flag
do
	case "${flag}" in
	c) config="${OPTARG}";;
	m) masker="${OPTARG}";;
	?) help >> /dev/stderr;;
esac
done

[ ! -x "$masker" ] && ( echo "File: $masker is not a executable or does not exist, check permissions" >> /dev/stderr; exit 1 )
[ ! -f "$config" ] && ( echo "File: $config does not exist" >> /dev/stderr; exit 1 )


export config
journalctl -u fail2ban.service  -f -n 0 | grep -io "\[\S*] Found \S*" --line-buffered | awk '{print $1, $3; system("")}' | xargs -n2 -P 16 "$masker" | logger -t "fail2ban-detect-subnets"

