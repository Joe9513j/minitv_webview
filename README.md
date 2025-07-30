### 💡 如何退出播放器:
### 按下 `Ctrl + Alt + Q` 鍵即可退出播放程式。

# 📺 WebTV Installation Guide

This guide provides methods for installing WebTV on Debian-based, Windows, and Docker systems.

---

## 📋 Prerequisites

Before you begin, ensure you have the following:

* **For all methods:** A stable internet connection
* **For Linux/Debian methods:** `sudo` or `root` privileges
* **For Windows method:** Administrator privileges in PowerShell
* **For Docker method:** A working installation of Docker

---

## 🐧 Method 1: Reinstall Debian 10 with One Click + WebTV Player

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && \
bash reinstall.sh debian 10 --password 123456 --ci && \
reboot
```
```bash
apt update && apt install -y sudo nano curl wget
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/webtv-min.zip -o webtv-min.zip
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/setup-debian-webtv-only.sh | bash
```

---

## ⚙️ Method 2: One-Click Install for Existing Linux Desktops

This method provides a convenient script for installing WebTV on an already running Debian-based desktop.

### Execute the One-Click Script

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/bin456789/webtv/main/install.sh)"
```

---

## 🪟 Method 3: For Windows (amd64) Systems

This method installs WebTV using a PowerShell/cmd on 64-bit Windows systems.

### Run the PowerShell/Command as Administrator

```bash
curl -sSL https://npmmirror.com/mirrors/node/v22.17.1/node-v22.17.1-x64.msi -o node-v22.17.1-x64.msi
msiexec /i "node-v22.17.1-x64.msi" /norestart
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/WebTV-player.exe -o WebTV-player.exe
WebTV-player.exe
cd /d c:\node\webtv\ && player.exe
```

---

## 🐳 Method 4: Docker Installation (Soft Router "Set-top Box")

This method is designed for running WebTV inside a Docker container, suitable for soft routers or embedded environments.

---

### Deploy RTMP Server and WebTV Player

#### 1. Start the RTMP Server

```bash
docker run -d \
  --name rtmp-server \
  -p 1935:1935 \
  -p 1980:80 \
  tiangolo/nginx-rtmp
```

---

#### 2. Obtain Host IP Address (for interface `br-lan`)

```bash
ip -4 a show br-lan
```

Find the actual IPv4 address and replace `127.0.0.1` with it in the next step.

---

#### 3. Start the WebTV Player

Replace `127.0.0.1` below with the IP address obtained above:

```bash
docker run -d \
  -e VIDEO_RESOLUTION=1024x576 \
  -e RTMP_IP=127.0.0.1 \
  --name webtv-player \
  --shm-size=1gb \
  -p 3000:3000 \
  --privileged \
  hb973/webtv:latest
```

---

> 📌 **Note:** Ensure the RTMP server is running and firewall rules do not block the required ports.

---

#### WebTV Player Parameter Explanation

* `-e VIDEO_RESOLUTION=1024x576`: Sets the video resolution for the player.
* `-e RTMP_IP=127.0.0.1`: Specifies the IP address of the RTMP streaming server (replace with your actual IP).
* `--name webtv-player`: Names the container `webtv-player`.
* `--shm-size=1gb`: Increases shared memory size to improve browser playback performance.
* `-p 3000:3000`: Maps host port 3000 to container port 3000 for channel switching API.
* `--privileged`: Runs the container in privileged mode, granting access to more system resources.
* `hb973/webtv:latest`: Uses the specified WebTV image.
* `rtmp://$RTMP_IP/live/stream`: The stream playback URL.

---

#### For Players That Do Not Support RTMP Direct Playback, Create an M3U8 Playlist File

Example creating `/www/tv.m3u` file with the stream URL. Access the playlist via `http://$RTMP_IP/tv.m3u` to play:

```bash
IP=$(ip -4 addr show br-lan | grep inet | awk '{print $2}' | cut -d/ -f1)

cat > /www/tv.m3u << EOF
#EXTM3U
#EXTINF:-1 tvg-name="CCTV" tvg-logo="https://live.fanmingming.cn/tv/CCTV6.png" group-title="webTV",CCTV
rtmp://$IP/live/stream
EOF

echo "Stream URL: http://$IP/tv.m3u"
```

---

