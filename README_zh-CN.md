# 📺 WebTV 安装指南

本指南提供了在基于 Debian 的系统、Windows 以及 Docker 环境中安装 WebTV 的方法。

---

## 📋 安装前准备

开始之前，请确保具备以下条件：

* **所有方法均需：** 稳定的网络连接
* **Linux/Debian 方法：** 具备 `sudo` 或 root 权限
* **Windows 方法：** 在 PowerShell 中拥有管理员权限
* **Docker 方法：** 已安装并正常运行 Docker

---

## 🐧 方法 1：适用于全新 Debian 10 系统

适用于需要在全新 Debian 10 环境中安装 WebTV 的用户。

### 一键重装 Debian 10 + WebTV Player

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

## ⚙️ 方法 2：现有 Linux 桌面的一键安装

适用于已经运行的基于 Debian 的 Linux 桌面系统，使用此脚本快速安装 WebTV。

### 第一步：执行一键安装脚本

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/bin456789/webtv/main/install.sh)"
```

---

## 🪟 方法 3：适用于 Windows (amd64) 系统

通过 PowerShell 脚本在 64 位 Windows 系统上安装 WebTV。

### 以管理员身份运行 PowerShell/cmd 命令

```bash
curl -sSL https://npmmirror.com/mirrors/node/v22.17.1/node-v22.17.1-x64.msi -o node-v22.17.1-x64.msi
msiexec /i "node-v22.17.1-x64.msi" /norestart
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/WebTV-player.exe -o WebTV-player.exe
cd /d c:\node\webtv\ && WebTV-player.exe
```

---

## 🐳 方法 4：Docker 安装（软路由“机顶盒”）

该方法适用于在 Docker 容器内运行 WebTV，适合软路由或嵌入式环境。

---

### 部署 RTMP 服务器和 WebTV 播放器

#### 1. 启动 RTMP 服务器

```bash
docker run -d \
  --name rtmp-server \
  -p 1935:1935 \
  -p 1980:80 \
  tiangolo/nginx-rtmp
```

---

#### 2. 获取宿主机 IP 地址（`br-lan` 网口）

```bash
ip -4 a show br-lan
```

找到实际的 IPv4 地址，并在下一步中将 `127.0.0.1` 替换为该地址。

---

#### 3. 启动 WebTV 播放器

将上一步获取的 IP 地址替换下面命令中的 `127.0.0.1`：

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

> 📌 注意：请确保 RTMP 服务器已启动，且防火墙未阻止相关端口。

---

#### WebTV 播放器参数说明

* `-e VIDEO_RESOLUTION=1024x576`：设置播放器的视频分辨率。
* `-e RTMP_IP=127.0.0.1`：指定 RTMP 流媒体服务器 IP（需替换为实际 IP）。
* `--name webtv-player`：容器名称设为 `webtv-player`。
* `--shm-size=1gb`：增大共享内存，提高浏览器播放性能。
* `-p 3000:3000`：映射宿主机 3000 端口到容器 3000 端口，支持频道切换 API。
* `--privileged`：以特权模式运行容器，允许访问更多系统资源。
* `hb973/webtv:latest`：使用指定的 WebTV 镜像。
* `rtmp://$RTMP_IP/live/stream`：流播放地址。

---

#### 针对部分播放器不支持 RTMP 直播放，可以创建一个 M3U8 播放列表文件，例如 `/www/tv.m3u`，输入播放地址 `http://$RTMP_IP/tv.m3u` 即可播放：

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

