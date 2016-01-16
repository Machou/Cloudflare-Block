<h1>CloudFlare Blocking'z</h1>

Active CloudFlare protection server load exceeds 10

Active la protection CloudFlare si la charge serveur est supérieur à 10


<h2>How to work ?</h2>

1. Add a cron tab / Ajoutez une tâche cron

```crontab -e```

```bash
*/1 * * * * /root/a.sh 0 # check every 1 minutes, if load > 10, block
*/20 * * * * /root/a.sh 1 # check every 20 minutes, if load < 10, disable protection
```

2. Wait & See :p
