---

# 📦 Debian 12 Auto Reinstall & WebTV Player Installation Guide

## 🌀 One-Click Debian 12 Reinstallation

Reinstall your system with a clean **Debian 12** image using a one-liner:

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 12 --password 123456 && reboot
```

> ⚠️ **Warning:** This will completely erase your current system!
> Make sure to **back up any important data** before running the script.

---

## ▶️ Install WebTV Player

To install the WebTV Player from the `.deb` package:

```bash
sudo dpkg -i webtv-player_1.0.0_amd64.deb
sudo apt-get install -f
```

> The second command resolves and installs any missing dependencies.

---

## 🧹 Uninstall WebTV Player

To remove WebTV Player from your system:

```bash
sudo dpkg -r webtv-player
```

---

## 📂 File Descriptions

| Filename                       | Description                                 |
| ------------------------------ | ------------------------------------------- |
| `webtv-player_1.0.0_amd64.deb` | WebTV Player installer for Debian (x86\_64) |
| `reinstall.sh`                 | Auto reinstall script (from bin456789 repo) |

---

## 💡 Notes

* Run all commands as **root** or use `sudo`.
* Recommended for **KVM-based VPS** or **dedicated servers**.
* For other OS versions, visit the [reinstall script repository](https://github.com/bin456789/reinstall).

---

Let me know if you'd like:

* Badges (e.g. for license, version)
* A screenshot preview of WebTV Player
* Multilingual sections (e.g. 中文版)
* GitHub Actions or packaging instructions

