#!/usr/bin/env bash

file_config=/usr/local/etc/v2ray/config.json
file_newconfig=/usr/local/etc/v2ray/config.json_new
file_deleted=/usr/local/etc/v2ray/deleted_pending
v2ray=v2ray
uuid_new="$($v2ray uuid)"
email="$(grep -F "$1" "$file_config" | tr -d ' ,"' | sed 's/^email://')"
[[ "$(echo "$email" | wc -l)" != 1 ]] && { echo "no user or multiple users" ; exit 1 ;}

user_jq='.inbounds[] | select(.protocol=="vmess").settings.clients[] | select(.email=="'$email'")'
uuid_old="$(cat "$file_config" | jq -r "${user_jq}.id")"
cat "$file_config" | jq '('"$user_jq"').id = "'"$uuid_new"'"' > "$file_newconfig" || exit 1
echo -n '' > $file_deleted
echo "$email $uuid_old" >> $file_deleted
echo "user $email was deleted"
