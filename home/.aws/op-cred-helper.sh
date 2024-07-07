#!/bin/bash
v=$1 s=$2
f(){ op read "op://$v/$s/$1" &>/dev/null && echo ",\"$2\":\"{{op://$v/$s/$1}}\""; }
j='{"Version":1,"AccessKeyId":"{{op://'$v'/'$s'/access_key_id}}","SecretAccessKey":"{{op://'$v'/'$s'/secret_access_key}}"'
j+=$(f default_region Region)
echo "$j}" | op inject
