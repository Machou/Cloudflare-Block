#!/bin/bash

# Load average | $1 = 1min, $2 = 5min, $3 = 15min
loadavg=$(cat /proc/loadavg|awk '{printf "%f", $1}')

# Max load is 10, you can modify if you want more than 10
maxload=10

# Configuration API Cloudflare
api_key=YOUR_API_KEY
email=YOUR_EMAIL
zone_id=ZONE_ID_DOMAIN

# Mode Default ( high, medium, low )
mode=high

attacking=./attacking

# create file attacking if doesn't exist
if [ ! -e $attacking ];
  then
  echo 0 > $attacking
fi

hasattack=$(cat $attacking)

if [ $(echo "$loadavg > $maxload"|bc) -eq 1 ];
then
  if [[ $hasattack = 0 && $1 = 0 ]];
  then
    # Enable Protection
    echo 1 > $attacking
    curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/settings/security_level" \
                  -H "X-Auth-Email: $email" \
                  -H "X-Auth-Key: $api_key" \
                  -H "Content-Type: application/json" \
                  --data '{"value":"under_attack"}'
  fi

else
  if [[ $hasattack = 1 && $1 = 1 ]];
  then
    # Disable Protection
    echo 0 > $attacking
    curl -s -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/settings/security_level" \
                  -H "X-Auth-Email: $email" \
                  -H "X-Auth-Key: $api_key" \
                  -H "Content-Type: application/json" \
                  --data '{"value":"$mode"}'
  fi
fi

exit 0
