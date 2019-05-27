#!/bin/bash


# $1 = 1min, $2 = 5min, $3 = 15min
loadavg=$(cat /proc/loadavg|awk '{printf "%f", $1}')


# load is 10, you can modify this if you want load more than 10
maxload=10


# Configuration API Cloudflare
# You're Global API Key (https://dash.cloudflare.com/profile)
api_key=
# Email of your account Cloudflare
email=
# Zone ID (https://dash.cloudflare.com/_zone-id_/domain.com)
zone_id=

attacked_file=./attacked


# You can put aforementioned config values either in-place
# or in the file named 'config' in the script's directory.
config_file=$(dirname $(basename "$0"))/config
[ -e "$config_file" ] && source "$config_file"


# create file "attacked" if doesn't exist
if [ ! -e $attacked_file ]; then
	echo 0 > $attacked_file
fi


was_under_attack=$(cat $attacked_file)
under_attack=$(echo "$loadavg > $maxload" | bc)

if [ $1 -eq 0 ] && [ $was_under_attack -eq 0 ] && [ $under_attack -eq 1 ]; then
	# attack just started and we want to enable under-attack mode

	# Activate protection
	echo 1 > $attacked_file
	curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/settings/security_level" \
					-H "X-Auth-Email: $email" \
					-H "X-Auth-Key: $api_key" \
					-H "Content-Type: application/json" \
					--data '{"value":"under_attack"}'

elif [ $1 -eq 1 ] && [ $was_under_attack -eq 1 ] && [ $under_attack -eq 0 ]; then
	# attack just finished (and up to 20 minutes passed since) 
	# and we want to disable under-attack mode

	# Disable Protection
	echo 0 > $attacked_file
	curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/settings/security_level" \
					-H "X-Auth-Email: $email" \
					-H "X-Auth-Key: $api_key" \
					-H "Content-Type: application/json" \
					--data '{"value":"high"}'

fi

exit 0
