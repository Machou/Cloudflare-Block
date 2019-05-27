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


attacked=./attacked

# create file "attacked" if doesn't exist
if [ ! -e $attacked ]; then
	echo 0 > $attacked
fi


hasattack=$(cat $attacked)


if [ $(echo "$loadavg > $maxload"|bc) -eq 1 ]; then

	if [[ $hasattack = 0 && $1 = 0 ]]; then

		# Active protection
		echo 1 > $attacked
		curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/settings/security_level" \
						-H "X-Auth-Email: $email" \
						-H "X-Auth-Key: $api_key" \
						-H "Content-Type: application/json" \
						--data '{"value":"under_attack"}'
	fi

	else
		if [[ $hasattack = 1 && $1 = 1 ]]; then

		# Disable Protection
		echo 0 > $attacked
		curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/settings/security_level" \
						-H "X-Auth-Email: $email" \
						-H "X-Auth-Key: $api_key" \
						-H "Content-Type: application/json" \
						--data '{"value":"high"}'
	fi
fi

exit 0
