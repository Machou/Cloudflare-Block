# Cloudflare-Block

Enable Cloudflare protection " I'm Under Attack! " if the server load is greater than 10.

**Cloudflare.sh** will create a **attacking** file to check if the protection is enabled or disabled.

### Configuration

#### Configure you API

[Cloudflare API Documentation](https://api.cloudflare.com/#zone-settings-get-security-level-setting)

> high    Threat scores greater than 0 will be challenged
> medium  Threat scores greater than 14 will be challenged
> low     Threat scores greater than 24 will be challenged
> under_attack  Under Attack Mode

```
API_KEY			You're Global API Key, here : https://www.cloudflare.com/a/profile
MAIL_ACCOUNT		Email of your account Cloudflare
DOMAIN			Zone ID, get here : https://www.cloudflare.com/a/overview/domain.com
```

#### Cron

```
crontab -e

*/1 * * * * /root/DDoS/Cloudflare.sh 0 # check every 1 minutes if protection is not enabled
*/20 * * * * /root/DDoS/Cloudflare.sh 1 # check every 20 minutes if protection is enabled
```

### License

**Cloudflare-Block** are distributed under the [The MIT License](https://opensource.org/licenses/MIT).
