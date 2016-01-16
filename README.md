<h1>CloudFlare Blocking'z</h1>

Active CloudFlare protection server load exceeds 10

Active la protection CloudFlare si la charge serveur est supérieur à 10


<h2>How to work ?</h2>

Configure you API

https://www.cloudflare.com/api_json.html?a=sec_lvl&tkn=API_KEY&email=MAIL_CCOUNT&z=DOMAIN&v=help

API_KEY : you're API Key from CloudFlare
MAIL_ACCOUNT : the email you use for you're account
DOMAIN : the domain you want protect

Add a cron tab / Ajoutez une tâche cron

```crontab -e```

```bash
*/1 * * * * /root/a.sh 0 # check every 1 minutes, if load > 10, block
*/20 * * * * /root/a.sh 1 # check every 20 minutes, if load < 10, disable protection
```

Wait & See :p
