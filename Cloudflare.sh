# crontab -e
# */1 * * * * /root/a.sh 0 # check every 1 minutes, if load > 10, block
# */20 * * * * /root/a.sh 1 # check every 20 minutes, if load < 10, disable protection


#!/bin/bash


# $1 = 1min, $2 = 5min, $3 = 15min
loadavg=$(cat /proc/loadavg|awk '{printf "%f", $1}')


# load is 10, you can modify this if you want load more than 10
maxload=10


# API DOCUMENTATION : https://api.cloudflare.com/#zone-settings-get-security-level-setting
# high             Threat scores greater than 0 will be challenged
# medium           Threat scores greater than 14 will be challenged
# low              Threat scores greater than 24 will be challenged
# under_attack      Under Attack Mode

# Configuration API Cloudflare
api_key=YOUR_API_KEY       # You're Global API Key, here : https://www.cloudflare.com/a/profile
email=YOUR_EMAIL           # Email of your account Cloudflare
zone_id=ZONE_ID_DOMAIN     # Zone ID, get here : https://www.cloudflare.com/a/overview/domain.com


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
    # active protection
    echo 1 > $attacking
    curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/settings/security_level" \
                  -H "X-Auth-Email: $email" \
                  -H "X-Auth-Key: $api_key" \
                  -H "Content-Type: application/json"
fi

else
  if [[ $hasattack = 1 && $1 = 1 ]];
  then
    # disable protection if load balancing is under 10
    echo 0 > $attacking
    curl -X PATCH "https://api.cloudflare.com/client/v4/zones/$zone_id/settings/security_level" \
                  -H "X-Auth-Email: $email" \
                  -H "X-Auth-Key: $api_key" \
                  -H "Content-Type: application/json"
  fi
fi

exit 0
