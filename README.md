
## 🌀 One-Click Debian 10 Reinstallation

### Reinstall your system with a clean **Debian 10** image using a one-liner:

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 10 --password 123456 --ci  && reboot
```

> ⚠️ **Warning:** This will completely erase your current system!
> Make sure to **back up any important data** before running the script.


## ▶️ Install WebTV Player

To install the WebTV Player from the .deb package:

```bash
apt update && apt install -y sudo nano curl wget
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/webtv-min.zip -o webtv-min.zip
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/setup-webtv.sh | bash 
```
