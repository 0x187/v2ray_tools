#!/usr/bin/bash

file_config=/usr/local/etc/v2ray/config.json
file_newconfig=/usr/local/etc/v2ray/config.json_new
file_oldconfig=/usr/local/etc/v2ray/config.json_old
file_deleted=/usr/local/etc/v2ray/deleted

cp "$file_config" "$file_oldconfig"
cp "$file_newconfig" "$file_config"
cat "${file_deleted}_pending" >> "$file_deleted"
