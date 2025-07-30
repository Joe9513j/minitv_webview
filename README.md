---

# Method 1: Debian 10 System and WebTV Installation Guide

---

## 🌀 One-Click Debian 10 Reinstallation

### Reinstall your system with a clean Debian 10 image using the command below:

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 10 --password 123456 --ci  && reboot
```

> ⚠️ **Warning:** This will completely erase your current system!
> Make sure to back up any important data before running this script.

---

## ▶️ Install WebTV Player

### Install the WebTV Player from the .zip package:

```bash
apt update && apt install -y sudo nano curl wget
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/webtv-min.zip -o webtv-min.zip
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/setup-debian-webtv-only.sh | bash
```

---

## Method 2: One-Click WebTV Installation for fnos/debian/ubuntu Desktop Systems

```bash
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/install-webtv-fnos | bash
```

---

