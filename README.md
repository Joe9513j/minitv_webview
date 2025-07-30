# WebTV Installation Guide

This guide provides methods for installing WebTV on Debian-based, Windows, and Docker systems.

> **網頁電視 (WebTV) 安裝指南**
>
> 本指南提供了在類 Debian 系統、Windows 系統以及 Docker 環境中安裝 WebTV 的方法。

---

## **Method 1: For a Fresh Debian 10 System**

This method is for users who need to install WebTV in a clean Debian 10 environment.

> **方案一：適用於全新 Debian 10 系統**
>
> 此方法適用於需要在一個純淨的 Debian 10 環境中安裝 WebTV 的用戶。

### **Step 1: Reinstall Debian 10 with One Click**

Use the command below to reinstall your system with a clean Debian 10 image.

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 10 --password 123456 --ci && reboot```

> **⚠️ Warning:**
> *   This action will **completely erase** your current system!
> *   Be sure to **back up all important data** before running this script.
> *   The default password is set to `123456`. Please change it immediately after your first login.

---

> #### **步驟一：一鍵重新安裝 Debian 10**
>
> 使用以下指令將您的系統重灌為一個乾淨的 Debian 10 映像。
>
> > **⚠️ 警告：**
> > *   此操作將會 **完全清除** 您當前的系統！
> > *   在執行此腳本前，請務必 **備份所有重要資料**。
> > *   預設密碼設置為 `123456`，請在首次登錄後立即更改。

### **Step 2: Install WebTV Player**

After the system reboots and you have logged in, run the following commands to install WebTV.

```bash
# Update package lists and install necessary tools
apt update && apt install -y sudo nano curl wget

# Download the WebTV core file
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/webtv-min.zip -o webtv-min.zip

# Execute the WebTV installation script
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/setup-debian-webtv-only.sh | bash
```

---

> #### **步驟二：安裝 WebTV 播放器**
>
> 系統重啟並成功登錄後，執行以下指令來安裝 WebTV。
>
> > ```bash
> > # 更新軟件包列表並安裝必要工具
> > apt update && apt install -y sudo nano curl wget
> >
> > # 下載 WebTV 核心文件
> > curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/webtv-min.zip -o webtv-min.zip
> >
> > # 執行 WebTV 安裝腳本
> > curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/setup-debian-webtv-only.sh | bash
> > ```

---

## **Method 2: One-Click Install for Existing Linux Desktop Systems**

This method is for users who are already running an Fnos, Debian, or Ubuntu desktop system and wish to install WebTV directly.

> **方案二：適用於現有 Linux 桌面環境的一鍵安裝**
>
> 此方法適用於已經運行 Fnos、Debian 或 Ubuntu 桌面系統，並希望直接安裝 WebTV 的用戶。

### **🚀 One-Click Install Command**

Execute the following single-line command in your terminal to complete the installation.

```bash
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/install-webtv-fnos | bash
```

> **💡 Tip:**
> This script will automatically detect your system environment and perform all necessary installation steps.

---

> #### **🚀 一鍵安裝指令**
>
> 在您的終端機中執行以下單行指令即可完成安裝。
>
> > **💡 提示：**
> > 此腳本會自動偵測您的系統環境並完成所有必要的安裝步驟。

---

## **Method 3: For Windows (amd64) Systems**

This method is for installing WebTV on a 64-bit Windows system. The following commands should be run in Command Prompt (CMD) or PowerShell with administrator privileges.

> **方案三：適用於 Windows (amd64) 系統**
>
> 此方法用於在 64 位元的 Windows 系統上安裝 WebTV。請使用系統管理員權限打開命令提示字元 (CMD) 或 PowerShell 來執行以下指令。

### **⚙️ Installation and Execution Steps**

1.  **Download and Install Node.js:**
    ```powershell
    # Download
    curl -sSL https://npmmirror.com/mirrors/node/v22.17.1/node-v22.17.1-x64.msi -o node-v22.17.1-x64.msi
    # Install silently
    msiexec /i "node-v22.17.1-x64.msi" /qn /norestart
    ```

2.  **Download and Run WebTV Player:**
    ```powershell
    # Download
    curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/WebTV-player.exe -o WebTV-player.exe
    # Run the installer/extractor
    WebTV-player.exe
    ```

3.  **Navigate to the installation directory and run the player:**
    *(Note: Replace `C:` with your actual system drive letter if it's different.)*
    ```powershell
    cd /d C:\node\webtv
    player.exe
    ```

> **💡 How to Exit Player:**
> Press `Ctrl` + `Alt` + `Q` to quit the player application.

---

> #### **⚙️ 安裝與執行步驟**
>
> 1.  **下載並安裝 Node.js:**
>     ```powershell
>     # 下載
>     curl -sSL https://npmmirror.com/mirrors/node/v22.17.1/node-v22.17.1-x64.msi -o node-v22.17.1-x64.msi
>     # 靜默安裝
>     msiexec /i "node-v22.17.1-x64.msi" /qn /norestart
>     ```
>
> 2.  **下載並運行 WebTV 播放器:**
>     ```powershell
>     # 下載
>     curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/WebTV-player.exe -o WebTV-player.exe
>     # 運行安裝/解壓縮程序
>     WebTV-player.exe
>     ```
>
> 3.  **進入安裝目錄並運行播放器:**
>     *(注意: 如果您的系統槽不是 C 槽，請替換成您實際的磁碟機代號。)*
>     ```powershell
>     cd /d C:\node\webtv
>     player.exe
>     ```
>
> > **💡 如何退出播放器:**
> > 按下 `Ctrl` + `Alt` + `Q` 鍵即可退出播放程式。

---

## **Method 4: Docker Installation**

This method is ideal for quick and isolated deployments. Ensure you have Docker installed and running on your system. The `hb973/webtv` image supports `linux/amd64` and `linux/arm64` platforms.

> **方案四：Docker 安裝**
>
> 此方法非常適合進行快速和隔離的部署。請先確保您的系統上已經安裝並正在運行 Docker。`hb973/webtv` 映像支持 `linux/amd64` 和 `linux/arm64` 平台。

### **Part A: Basic Installation**

This will run a standalone WebTV player, suitable for general use.

> **A 部分：基礎安裝**
>
> 此指令將運行一個獨立的 WebTV 播放器，適用於一般用途。

**🐳 Docker Run Command:**

```bash
docker run -d --name=webtv --restart=always -p 8111:8111 hb973/webtv
```

After running the command, WebTV will be accessible in your web browser at `http://<your_server_ip>:8111`.

---

### **Part B: Advanced Use Case (Soft Router "Set-top Box")**

This setup integrates the WebTV player with an RTMP server, turning your soft router into a streaming media center.

> **B 部分：進階應用 (軟路由“電視機上盒”)**
>
> 此設定將 WebTV 播放器與一個 RTMP 伺服器整合，將您的軟路由打造成一個串流媒體中心。

**Step 1: Start the RTMP Server**
> **步驟一：啟動 RTMP 伺服器**

```bash
docker run -d \
  --name rtmp-server \
  --restart=always \
  -p 1935:1935 \
  -p 1980:80 \
  tiangolo/nginx-rtmp```
*This command starts an Nginx server with the RTMP module, mapping ports for streaming (1935) and stats/HTTP (1980).*
> *此指令會啟動一個帶有 RTMP 模組的 Nginx 伺服器，並映射串流 (1935) 和狀態頁/HTTP (1980) 的連接埠。*

**Step 2: Get the Host IP Address**
> **步驟二：取得主機 IP 位址**

On your soft router, find the LAN interface IP (usually `br-lan`). You will need this for the next step.
> 在您的軟路由上，找到區域網路介面（通常是 `br-lan`）的 IP 位址。下一步會用到它。

```bash
ip -4 a show br-lan
```

**Step 3: Start the WebTV Player**
> **步驟三：啟動 WebTV 播放器**

Replace `127.0.0.1` in the `-e RTMP_IP` parameter with the actual IP address you found in Step 2.
> 將 `-e RTMP_IP` 參數中的 `127.0.0.1` 替換為您在步驟二中找到的實際 IP 位址。

```bash
docker run -d \
  -e VIDEO_RESOLUTION=1024x576 \
  -e RTMP_IP=127.0.0.1 \
  --name webtv-player \
  --restart=always \
  --shm-size=1gb \
  -p 3000:3000 \
  --privileged \
  hb973/webtv:latest
```
*The stream URL will be `rtmp://<RTMP_IP>/live/stream`.*
> *串流播放 URL 將會是 `rtmp://<RTMP_IP>/live/stream`。*

**Step 4 (Optional): Create an M3U8 Playlist**
> **步驟四 (可選)：建立 M3U8 播放清單**

If your media player does not directly support RTMP links, you can create an M3U8 file that points to the stream. Run this on your host machine.
> 如果您的播放器不直接支援 RTMP 連結，可以建立一個指向該串流的 M3U8 檔案。請在您的主機上執行此指令。

```bash
# Get the IP and create the file in the Nginx web root (/www)
IP=$(ip -4 addr show br-lan | grep inet | awk '{print $2}' | cut -d/ -f1)
cat > /www/tv.m3u << EOF
#EXTM3U
#EXTINF:-1 tvg-name="CCTV" tvg-logo="https://live.fanmingming.cn/tv/CCTV6.png" group-title="webTV",CCTV
rtmp://$IP/live/stream
EOF

# The playlist will be available at http://<your_ip>:1980/tv.m3u
echo "Playlist URL: http://$IP:1980/tv.m3u"
```



> > **💡 如何退出播放器:**
> > 按下 `Ctrl` + `Alt` + `Q` 鍵即可退出播放程式。
