# Cloudflare-Block

This script enable *I'm Under Attack Mode* of [Cloudflare](https://www.cloudflare.com/) if your server's load average exceeds a predefined limit.

**Cloudflare.sh** will create a file named **attacked** to check if the protection is *enabled* or *disabled*.

Load average is checked via a cron job (default: every 20 minutes)

## Configuration

### Script

```bash
git clone https://github.com/Machou/Cloudflare-Block.git DDoS
```

### Configure you API

Copy config file `config.template` to `config` and edit it:
add API keys (mandatory) and optionally change some of the other values.

**API_KEY**: Your Global API Key (https://dash.cloudflare.com/profile)

**MAIL_ACCOUNT**: Email of your Cloudflare account

**DOMAIN**: Zone ID (https://dash.cloudflare.com/_zone-id_/domain.com)

[Cloudflare API Documentation](https://api.cloudflare.com/#zone-settings-get-security-level-setting)

| Mode         | Description   |
|:------------:|:-------------:|
| high         | Threat scores greater than 0 will be challenged   |
| medium       | Threat scores greater than 14 will be challenged  |
| low          | Threat scores greater than 24 will be challenged  |
|under_attack  | Under Attack Mode                                 |

### Cron

```bash
crontab -e

*/1 * * * * /root/DDoS/Cloudflare.sh 0 # check every 1 minute if protection is not enabled
*/20 * * * * /root/DDoS/Cloudflare.sh 1 # check every 20 minutes if protection is enabled
```

### License

**Cloudflare-Block** are distributed under the [The MIT License](https://opensource.org/licenses/MIT).