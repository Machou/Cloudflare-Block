# Cloudflare-Block

Enable Cloudflare protection " I'm Under Attack! " if the server load is greater than 10. (Possibility to customize the script.)

### Configuration

Configure you API

https://www.cloudflare.com/api_json.html?a=sec_lvl&tkn=API_KEY&email=MAIL_CCOUNT&z=DOMAIN&v=help

```
API_KEY : API Key of account Cloudflare
MAIL_ACCOUNT : Email of account Cloudflare
DOMAIN : Domain you want protect
```

### Cron

```
crontab -e

*/1 * * * * /root/a.sh 0 # check every 1 minutes, if load > 10, block
*/20 * * * * /root/a.sh 1 # check every 20 minutes, if load < 10, disable protection
```
