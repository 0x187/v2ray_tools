#!/usr/bin/env bash

file_config=/usr/local/etc/v2ray/config.json
file_newconfig=/usr/local/etc/v2ray/config.json_new
v2ray=v2ray
uuid="$($v2ray uuid)"

email="$(grep -F "${1#*@}" "$file_config" | tr -d ' ,"' | sed 's/^email://')"
[[ "$(echo -n "$email" | wc -c)" != 0 ]] && { echo "user exists" ; exit 1 ;}
cp "$file_config" "$file_newconfig"
cat "$file_config" | jq '(.inbounds[] | select(.protocol=="vmess").settings.clients) += [{"id":"'$uuid'","email":"'$1'","level":1,"alterId":0}]' > "$file_newconfig"
