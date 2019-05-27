#!/bin/bash


# $1 = 1min, $2 = 5min, $3 = 15min
loadavg=$(awk '{printf "%f", $1}' < /proc/loadavg)


# load is 10, you can modify this if you want load more than 10
maxload=10


# Configuration API Cloudflare
# Your Global API Key (https://dash.cloudflare.com/profile)
api_key=
# Email of your Cloudflare account
email=
# Zone ID (https://dash.cloudflare.com/_zone-id_/domain.com)
zone_id=
# Default security level when there is no attack, see in readme
default_security_level=high
# Whether to write debug messages to the debug.log file under script dir
debug=0


basedir=$(dirname "$0")

attacked_file=$basedir/attacked

[ "$debug" -eq 1 ] && exec > "${logfile:-$basedir/debug.log}"


# You can put aforementioned config values either in-place
# or in the file named 'config' in the script's directory.
config_file=$basedir/config
[ -e "$config_file" ] && source "$config_file"


api_set_mode() {
	local mode
	mode=$1
	curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/settings/security_level" \
		-H "X-Auth-Email: $email" \
		-H "X-Auth-Key: $api_key" \
		-H "Content-Type: application/json" \
		--data "{\"value\":\"$mode\"}" \
	|| echo "Error: failed to set security level to $mode"
}


# create file "attacked" if doesn't exist
if [ ! -e "$attacked_file" ]; then
	echo 0 > "$attacked_file"
fi


was_under_attack=$(cat "$attacked_file")
under_attack=$(echo "$loadavg > $maxload" | bc)

if [[ "$1" != [01] ]]; then
	echo "Incorrect usage! Please pass either 0 or 1 as an argument"
	exit 1
fi

if [ $debug -eq 1 ]; then
	echo "Mode: $1; was under attack: $was_under_attack; now under attack: $under_attack"
	echo "Load average: $loadavg"
fi

if [ "$1" -eq 0 ] && [ "$was_under_attack" -eq 0 ] && [ "$under_attack" -eq 1 ]; then
	# attack just started and we want to enable under-attack mode

	# Activate protection
	[ "$debug" -eq 1 ] && echo "Activating under-attack mode!"
	echo 1 > "$attacked_file"
	api_set_mode under_attack

elif [ "$1" -eq 1 ] && [ "$was_under_attack" -eq 1 ] && [ "$under_attack" -eq 0 ]; then
	# attack just finished (and up to 20 minutes passed since) 
	# and we want to disable under-attack mode

	# Disable Protection
	[ "$debug" -eq 1 ] && echo "Leaving under-attack mode!"
	echo 0 > "$attacked_file"
	api_set_mode "$default_security_level"

fi

exit 0
