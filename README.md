# 📺 WebTV Installation Guide

This guide provides methods for installing WebTV on Debian-based, Windows, and Docker systems.

## 📋 Prerequisites

Before you begin, ensure you have the following:

- **For all methods:** A stable internet connection  
- **For Linux/Debian methods:** `sudo` or `root` privileges  
- **For Windows method:** Administrator privileges in PowerShell  
- **For Docker method:** A working installation of Docker

## 🐧 Method 1: For a Fresh Debian 10 System

This method is for users who need to install WebTV in a clean Debian 10 environment.

### Step 1: Reinstall Debian 10 with One Click

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && \
bash reinstall.sh debian 10 --password 123456 --ci && \
reboot
````

## ⚙️ Method 2: One-Click Install for Existing Linux Desktops

This method provides a convenient script for installing WebTV on an already running Debian-based desktop.

### Step 1: Execute the One-Click Script

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/bin456789/webtv/main/install.sh)"
```

## 🪟 Method 3: For Windows (amd64) Systems

This method installs WebTV using a PowerShell script on 64-bit Windows systems.

### Step 1: Run the PowerShell Command as Administrator

```powershell
irm https://raw.githubusercontent.com/bin456789/webtv/main/install.ps1 | iex
```

## 🐳 Method 4: Docker Installation (Soft Router "Set-top Box")

This method is designed for running WebTV inside a Docker container, suitable for soft routers or embedded environments.

### 部署 RTMP Server 和 WebTV 播放器

#### 1. 启动 RTMP Server

```bash
docker run -d \
  --name rtmp-server \
  -p 1935:1935 \
  -p 1980:80 \
  tiangolo/nginx-rtmp
```

---

#### 2. 获取宿主机 IP 地址（`br-lan` 接口）

```bash
ip -4 a show br-lan
```

找到实际的 IPv4 地址，并将其用于下一步的 `RTMP_IP` 替换 `127.0.0.1`。

---

#### 3. 启动 WebTV 播放器

将上一步获取的 IP 地址替换下面的 `127.0.0.1`：

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

> 📌 注意：确保 RTMP Server 已经运行，并且防火墙没有阻止对应的端口。


#### WebTV 播放器参数说明

- `-e VIDEO_RESOLUTION=1024x576`：设置播放器的视频分辨率。
- `-e RTMP_IP=127.0.0.1`：指定 RTMP 流媒体服务器的 IP 地址（需要替换为实际 IP）。
- `--name webtv-player`：设置容器名称为 `webtv-player`。
- `--shm-size=1gb`：增加共享内存大小，提升浏览器播放性能。
- `-p 3000:3000`：将宿主机的 3000 端口映射到容器的 3000 端口，播放频道切换api。
- `--privileged`：以特权模式运行容器，允许访问更多系统资源。
- `hb973/webtv:latest`：使用指定的 WebTV 镜像。
- `rtmp://$RTMP_IP/live/stream`：流播放url。
---

#### 针对一些播放器不支持rmtp直接播放，可以创建一个m3u8文件,比如 /www/tv.m3u，输入播放地址 http://$RTMP_IP/tv.m3u 就可以播放了
```bash
IP=$(ip -4 addr show br-lan | grep inet | awk '{print $2}' | cut -d/ -f1)

cat > /www/tv.m3u << EOF
#EXTM3U
#EXTINF:-1 tvg-name="CCTV" tvg-logo="https://live.fanmingming.cn/tv/CCTV6.png" group-title="webTV",CCTV
rtmp://$IP/live/stream
EOF

echo "Stream URL: http://$IP/tv.m3u"

```
