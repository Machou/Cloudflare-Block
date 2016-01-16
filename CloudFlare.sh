# add crontab | ajoutez un crontab
# crontab -e
# */1 * * * * /root/a.sh 0 # check every 1 minutes, if load > 10, block
# */20 * * * * /root/a.sh 1 # check every 20 minutes, if load < 10, disable protection

#!/bin/bash

# $1 = 1min, $2 = 5min, $3 = 15min
loadavg=$(cat /proc/loadavg|awk '{printf "%f", $1}')

# load is 10, you can modify this if you want load more than 10
maxload=10

# API DOCUMENTATION : https://www.cloudflare.com/docs/client-api.html
# help - Protection I'm under attack!
# high - Protection High
# med - Protection Medium
# low - Protection Low
# eoff - Protection Off

#url1 = active protection
url1="https://www.cloudflare.com/api_json.html?a=sec_lvl&tkn=API_KEY&email=MAIL_CCOUNT&z=DOMAIN&v=help"

#url2 = disable protection if load balancing is under 10
url2="https://www.cloudflare.com/api_json.html?a=sec_lvl&tkn=API_KEY&email=MAIL_CCOUNT&z=DOMAIN&v=high"

attacking=./attacking
 
# create file attacking if doesn't exist | créé le fichier attacking si existe pas
if [ ! -e $attacking ];
  then
  echo 0 > $attacking
fi
 
hasattack=$(cat $attacking)
 
if [ $(echo "$loadavg > $maxload"|bc) -eq 1 ];
then
  if [[ $hasattack = 0 && $1 = 0 ]];
  then
    echo 1 > $attacking
    curl -s $url1
fi

else
  if [[ $hasattack = 1 && $1 = 1 ]];
  then
    echo 0 > $attacking
    curl -s $url2
  fi
fi

exit 0
