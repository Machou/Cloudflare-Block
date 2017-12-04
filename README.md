# Cloudflare Blocking

Enable Cloudflare protection " I'm Under Attack! " if the server load is greater than 10. (Possibility to customize the script.)

## How to work ?

Configure you API

https://www.cloudflare.com/api_json.html?a=sec_lvl&tkn=API_KEY&email=MAIL_CCOUNT&z=DOMAIN&v=help

API_KEY : API Key<br />
MAIL_ACCOUNT : email account<br />
DOMAIN : domain you want protect

Add a cron tab

```crontab -e```

```bash
*/1 * * * * /root/a.sh 0 # check every 1 minutes, if load > 10, block
*/20 * * * * /root/a.sh 1 # check every 20 minutes, if load < 10, disable protection
```