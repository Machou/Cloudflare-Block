# Cloudflare-Block

Enable Cloudflare protection " I'm Under Attack! " if the server load is greater than 10. (can be modified)

**Cloudflare.sh** will create a **attacking** file to check if the protection is enabled or disabled.


### Configuration

#### The Script

```bash
mkdir /root/DDoS && cd /root/DDoS
git clone https://github.com/Machou/Cloudflare-Block.git
```


#### Configure you API

[Cloudflare API Documentation](https://api.cloudflare.com/#zone-settings-get-security-level-setting)

| Mode         | Description   |
|:------------:|:-------------:|
| high         | Threat scores greater than 0 will be challenged   |
| medium       | Threat scores greater than 14 will be challenged  |
| low          | Threat scores greater than 24 will be challenged  |
|under_attack  | Under Attack Mode                                 |

```bash
API_KEY			You're Global API Key (https://dash.cloudflare.com/profile)
MAIL_ACCOUNT		Email of your Cloudflare account
DOMAIN			Zone ID (https://dash.cloudflare.com/_zone-id_/domain.com)
```


#### Cron

```bash
crontab -e

*/1 * * * * /root/DDoS/Cloudflare.sh 0 # check every 1 minute if protection is not enabled
*/20 * * * * /root/DDoS/Cloudflare.sh 1 # check every 20 minutes if protection is enabled
```


### License

**Cloudflare-Block** are distributed under the [The MIT License](https://opensource.org/licenses/MIT).
