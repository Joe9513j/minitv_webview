### 💡 How to Exit Player: Press Ctrl + Alt + Q to quit the player application.

# 📺 WebTV Installation Guide

This guide provides methods for installing WebTV on Debian-based, Windows, and Docker systems.

### **Table of Contents**

*   [**Prerequisites**](#-prerequisites)
*   [**Method 1: For a Fresh Debian 10 System**](#-method-1-for-a-fresh-debian-10-system)
*   [**Method 2: One-Click Install for Existing Linux Desktops**](#-method-2-one-click-install-for-existing-linux-desktops)
*   [**Method 3: For Windows (amd64) Systems**](#-method-3-for-windows-amd64-systems)
*   [**Method 4: Docker Installation (Soft Router)**](#-method-4-docker-installation-soft-router-set-top-box)

> **網頁電視 (WebTV) 安裝指南**
>
> 本指南提供了在類 Debian 系統、Windows 系統以及 Docker 環境中安裝 WebTV 的方法。

---

### **📋 Prerequisites**

Before you begin, ensure you have the following:
*   **For all methods:** A stable internet connection.
*   **For Linux/Debian methods:** `sudo` or `root` privileges.
*   **For Windows method:** Administrator privileges in PowerShell.
*   **For Docker method:** A working installation of Docker.

> **先決條件**
>
> 在開始之前，請確保您已滿足以下條件：
> *   **所有方法：** 穩定的網路連線。
> *   **Linux/Debian 方法：** `sudo` 或 `root` 管理員權限。
> *   **Windows 方法：** PowerShell 的系統管理員權限。
> *   **Docker 方法：** Docker 已被正確安裝並正在運行。

---
---

## **🐧 Method 1: For a Fresh Debian 10 System**

This method is for users who need to install WebTV in a clean Debian 10 environment.

> **方案一：適用於全新 Debian 10 系統**
>
> 此方法適用於需要在一個純淨的 Debian 10 環境中安裝 WebTV 的用戶。

#### **Step 1: Reinstall Debian 10 with One Click**

Use the command below to reinstall your system with a clean Debian 10 image.

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 10 --password 123456 --ci && reboot
```

> **⚠️ Warning:**
> *   This action will **completely erase** your current system!
> *   Be sure to **back up all important data** before running this script.
> *   The default password is set to `123456`. Please change it immediately after your first login.

#### **Step 2: Install WebTV Player**

After the system reboots, run the following commands to install WebTV.

```bash
# Update package lists and install necessary tools
apt update && apt install -y sudo nano curl wget

# Download the WebTV core file
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/webtv-min.zip -o webtv-min.zip

# Execute the WebTV installation script
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/setup-debian-webtv-only.sh | bash
```
---
---

## **🚀 Method 2: One-Click Install for Existing Linux Desktops**

This method is for users already running Fnos, Debian, or Ubuntu who wish to install WebTV directly.

> **方案二：適用於現有 Linux 桌面環境的一鍵安裝**
>
> 此方法適用於已經運行 Fnos、Debian 或 Ubuntu 桌面系統，並希望直接安裝 WebTV 的用戶。

#### **One-Click Install Command**

Execute the following single-line command in your terminal.

```bash
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/install-webtv-fnos | bash
```

> **💡 Tip:**
> This script will automatically detect your system environment and perform all necessary installation steps.

---
---

## **🪟 Method 3: For Windows (amd64) Systems**

This method is for installing WebTV on a 64-bit Windows system. Run these commands in **PowerShell** with **administrator privileges**.

> **方案三：適用於 Windows (amd64) 系統**
>
> 此方法用於在 64 位元的 Windows 系統上安裝 WebTV。請使用**系統管理員權限**打開 **PowerShell** 來執行以下指令。

#### **⚙️ Installation and Execution Steps**

1.  **Download and Install Node.js**
    ```powershell
    # Download
    curl -sSL https://npmmirror.com/mirrors/node/v22.17.1/node-v22.17.1-x64.msi -o node-v22.17.1-x64.msi
    # Install silently
    msiexec /i "node-v22.17.1-x64.msi" /norestart
    ```

2.  **Download and Run WebTV Extractor**
    ```powershell
    # Download
    curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/WebTV-player.exe -o WebTV-player.exe
    # Run the installer/extractor
    .\WebTV-player.exe
    ```

3.  **Navigate and Run Player**
    *(Note: Replace `C:` with your actual system drive letter if it's different.)*
    ```powershell
    cd /d C:\node\webtv && .\player.exe
    ```

> **💡 How to Exit Player:**
> Press `Ctrl` + `Alt` + `Q` to quit the player application.

---
---

## **🐳 Method 4: Docker Installation (Soft Router "Set-top Box")**

This setup integrates the WebTV player with an RTMP server, turning your soft router into a streaming media center. The `hb973/webtv` image supports `linux/amd64` and `linux/arm64`.

> **方案四：Docker 安裝 (軟路由“電視機上盒”)**
>
> 此設定將 WebTV 播放器與一個 RTMP 伺服器整合，將您的軟路由打造成一個串流媒體中心。`hb973/webtv` 映像支持 `linux/amd64` 和 `linux/arm64` 平台。

#### **Step 1: Start the RTMP Server**

```bash
docker run -d \
  --name rtmp-server \
  --restart=always \
  -p 1935:1935 \
  -p 1980:80 \
  tiangolo/nginx-rtmp
```
*This starts an Nginx server with the RTMP module.*
> *此指令會啟動一個帶有 RTMP 模組的 Nginx 伺服器。*

#### **Step 2: Get the Host IP Address**

Find the LAN interface IP on your soft router (usually `br-lan`).

```bash
ip -4 a show br-lan
```

#### **Step 3: Start the WebTV Player**

Replace `127.0.0.1` in the `-e RTMP_IP` parameter with the **actual IP address** from Step 2.

```bash
docker run -d \
  --name webtv-player \
  --restart=always \
  -e VIDEO_RESOLUTION=1024x576 \
  -e RTMP_IP=127.0.0.1 \
  --shm-size=1gb \
  -p 3000:3000 \
  --privileged \
  hb973/webtv:latest
```
*The stream URL will be `rtmp://<YOUR_RTMP_IP>/live/stream`.*
> *串流播放 URL 將會是 `rtmp://<您的RTMP_IP>/live/stream`。*

#### **Step 4 (Optional): Create an M3U8 Playlist**

If your media player needs an M3U8 link, run this on your host machine to create one.

```bash
# Get IP and create the file in the Nginx web root (/www)
IP=$(ip -4 addr show br-lan | grep inet | awk '{print $2}' | cut -d/ -f1)
cat > /www/tv.m3u << EOF
#EXTM3U
#EXTINF:-1 tvg-name="CCTV" tvg-logo="https://live.fanmingming.cn/tv/CCTV6.png" group-title="webTV",CCTV
rtmp://$IP/live/stream
EOF

# Access the playlist at http://<your_ip>:1980/tv.m3u
echo "Playlist URL: http://$IP:1980/tv.m3u"
```
