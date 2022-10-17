#!/usr/bin/env bash

file_config=/usr/local/etc/v2ray/config.json
file_log="$1"
file_strikes=/usr/local/etc/strikes

cur_all=0
max_all=0
emails="$(cat "$file_config" | sed 's/^ *\/\/.*//' | jq -r '.inbounds | map(select(.protocol=="vmess"))[].settings.clients[] | .email')"
echo "----> $(date +%y%m%d_%H%M%S):" | tee -a "$file_usage"
for email in $(echo $emails) ; do
	cur_conn="$(grep -wF "email: $email" "$file_log" | cut -d' ' -f3 | cut -d':' -f1 | sort | uniq | wc -l)"
	max_conn="${email%@*}"
	if ! [[ "$max_conn" =~ ^[0-9]+$ ]] ; then
		echo "${email} ${cur_conn}" | tee -a "$file_usage"
		continue
	fi
	cur_all=$(($cur_conn + $cur_all))
	max_all=$(($max_conn + $max_all))
	[[ $cur_conn > $max_conn ]] && echo "${email#*@} ${cur_conn}/${max_conn}" | tee -a "$file_usage" | tee -a "$file_strikes"
done
echo "Total: $cur_all/$max_all"
echo "<----" | tee -a "$file_usage"
