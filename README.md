---

# 📦 Debian 12 Auto Reinstall & WebTV Player Installation Guide

## 🌀 One-Click Debian 12 Reinstallation

Use the following command to automatically **DD reinstall Debian 12** with the login password set to `123456`:

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 12 --password 123456 && reboot
```

> ⚠️ **Warning:** This will erase all data on the server! Make sure to back up important files before proceeding.

---

## ▶️ Install WebTV Player

### Install the `.deb` package:

```bash
sudo dpkg -i webtv-player_1.0.0_amd64.deb
sudo apt-get install -f
```

> The second command will fix any missing dependencies automatically.

---

## 🧹 Uninstall WebTV Player

To remove the software:

```bash
sudo dpkg -r webtv-player
```

---

## 📂 File Descriptions

| Filename                       | Description                               |
| ------------------------------ | ----------------------------------------- |
| `webtv-player_1.0.0_amd64.deb` | WebTV Player installer (Debian x86\_64)   |
| `reinstall.sh`                 | Auto reinstall script from bin456789 repo |

---

## 💡 Notes

* You **must run as root** (or use `sudo`) to execute the commands.
* Recommended for KVM-based VPS or dedicated servers.
* For other OS versions, check the [reinstall script repo](https://github.com/bin456789/reinstall).

---

