# WebTV Installation Guide

```markdown
# 🌐 WebTV Installation Guide

This guide provides methods for installing WebTV on Debian-based, Windows, and Docker systems.

> **網頁電視 (WebTV) 安裝指南**  
> 本指南提供了在類 Debian 系統、Windows 系統以及 Docker 環境中安裝 WebTV 的方法。

---

## 📥 Installation Methods 安裝方式

### 1️⃣ **Fresh Debian 10 System**  
   **全新 Debian 10 系統**

### 2️⃣ **Existing Linux Desktop**  
   **現有 Linux 桌面系統**

### 3️⃣ **Windows (amd64) Systems**  
   **Windows (amd64) 系統**

### 4️⃣ **Docker Installation**  
   **Docker 安裝**

---

## 1️⃣ **Method 1: Fresh Debian 10 System**

> **方案一：全新 Debian 10 系統安裝**

### 🔄 Step 1: Reinstall Debian 10
```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && \
bash reinstall.sh debian 10 --password 123456 --ci && \
reboot
```

⚠️ **Warning 警告**:
- Will **completely erase** your system  
  將會**完全清除**當前系統
- **Back up important data** first  
  請先**備份重要資料**
- Default password: `123456` (change after login)  
  默認密碼：`123456`（登錄後請更改）

### 📺 Step 2: Install WebTV Player
```bash
# Update and install tools
apt update && apt install -y sudo nano curl wget

# Download WebTV core
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/main/webtv-min.zip -o webtv-min.zip

# Run installation
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/main/setup-debian-webtv-only.sh | bash
```

---

## 2️⃣ **Method 2: Linux Desktop One-Click Install**

> **方案二：Linux 桌面一鍵安裝**

🚀 **Single Command 單一指令**:
```bash
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/main/install-webtv-fnos | bash
```

💡 Automatically detects your system environment  
自動檢測系統環境

---

## 3️⃣ **Method 3: Windows (amd64) Installation**

> **方案三：Windows (amd64) 系統安裝**

### ⚙️ Installation Steps 安裝步驟

1. **Install Node.js** 安裝 Node.js
```powershell
curl -sSL https://npmmirror.com/mirrors/node/v22.17.1/node-v22.17.1-x64.msi -o node.msi
msiexec /i "node.msi" /qn /norestart
```

2. **Download WebTV** 下載 WebTV
```powershell
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/main/WebTV-player.exe -o WebTV-player.exe
WebTV-player.exe
```

3. **Run Player** 運行播放器
```powershell
cd /d C:\node\webtv
player.exe
```

🔑 **Exit shortcut 退出快捷鍵**: `Ctrl` + `Alt` + `Q`

---

## 4️⃣ **Method 4: Docker Installation**

> **方案四：Docker 安裝**

### 🐳 **Basic Setup 基礎安裝**
```bash
docker run -d --name=webtv --restart=always -p 8111:8111 hb973/webtv
```
Access at 訪問地址: `http://<your_server_ip>:8111`

### 📡 **Advanced: Soft Router Setup**  
**進階：軟路由機上盒方案**

1. **Start RTMP Server** 啟動RTMP服務
```bash
docker run -d --name rtmp-server --restart=always \
  -p 1935:1935 -p 1980:80 tiangolo/nginx-rtmp
```

2. **Find LAN IP** 查找區域網路IP
```bash
ip -4 a show br-lan
```

3. **Start WebTV Player** 啟動播放器
```bash
docker run -d \
  -e VIDEO_RESOLUTION=1024x576 \
  -e RTMP_IP=YOUR_LAN_IP \
  --name webtv-player \
  --restart=always \
  --shm-size=1gb \
  -p 3000:3000 \
  --privileged \
  hb973/webtv:latest
```

4. **(Optional) Create M3U8 Playlist** 創建播放列表
```bash
IP=$(ip -4 addr show br-lan | grep inet | awk '{print $2}' | cut -d/ -f1)
cat > /www/tv.m3u << EOF
#EXTM3U
#EXTINF:-1 tvg-name="CCTV" tvg-logo="https://live.fanmingming.cn/tv/CCTV6.png" group-title="webTV",CCTV
rtmp://$IP/live/stream
EOF
```

🌐 **Playlist URL 播放列表地址**: `http://$IP:1980/tv.m3u`
```
