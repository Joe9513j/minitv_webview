### ** `README_zh-CN.md` (Simplified Chinese)**

```markdown
# 📺 WebTV 安装指南

本指南提供了在类 Debian 系统、Windows 系统以及 Docker 环境中安装 WebTV 的方法。

### **目录**

*   [**先决条件**](#-先决条件)
*   [**方案一：适用于全新 Debian 10 系统**](#-方案一适用于全新-debian-10-系统)
*   [**方案二：适用于现有 Linux 桌面环境的一键安装**](#-方案二适用于现有-linux-桌面环境的一键安装)
*   [**方案三：适用于 Windows (amd64) 系统**](#-方案三适用于-windows-amd64-系统)
*   [**方案四：Docker 安装 (软路由“电视机上盒”)**](#-方案四docker-安装-软路由电视机上盒)

---

### **📋 先决条件**

在开始之前，请确保您已满足以下条件：
*   **所有方法：** 稳定的网络连接。
*   **Linux/Debian 方法：** `sudo` 或 `root` 管理员权限。
*   **Windows 方法：** PowerShell 的系统管理员权限。
*   **Docker 方法：** Docker 已被正确安装并正在运行。

---
---

## **🐧 方案一：适用于全新 Debian 10 系统**

此方法适用于需要在一個純淨的 Debian 10 環境中安裝 WebTV 的用戶。

#### **步驟一：一鍵重新安裝 Debian 10**

使用以下指令將您的系統重灌為一個乾淨的 Debian 10 映像。

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 10 --password 123456 --ci && reboot
```

> **⚠️ 警告：**
> *   此操作將會 **完全清除** 您當前的系統！
> *   在執行此腳本前，請務必 **備份所有重要資料**。
> *   預設密碼設置為 `123456`，請在首次登錄後立即更改。

#### **步驟二：安裝 WebTV 播放器**

系統重啟並成功登錄後，執行以下指令來安裝 WebTV。

```bash
# 更新軟件包列表並安裝必要工具
apt update && apt install -y sudo nano curl wget

# 下載 WebTV 核心文件
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/webtv-min.zip -o webtv-min.zip

# 執行 WebTV 安裝腳本
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/setup-debian-webtv-only.sh | bash
```
---
---

## **🚀 方案二：适用于现有 Linux 桌面环境的一键安装**

此方法适用于已经运行 Fnos、Debian 或 Ubuntu 桌面系统，并希望直接安装 WebTV 的用户。

#### **一键安装指令**

在您的终端机中执行以下单行指令即可完成安装。

```bash
curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/install-webtv-fnos | bash
```

> **💡 提示：**
> 此脚本会自动侦测您的系统环境并完成所有必要的安装步骤。

---
---

## **🪟 方案三：适用于 Windows (amd64) 系统**

此方法用于在 64 位的 Windows 系统上安装 WebTV。请使用**系统管理员权限**打开 **PowerShell** 来执行以下指令。

#### **⚙️ 安装与执行步骤**

1.  **下载并安装 Node.js**
    ```powershell
    # 下载
    curl -sSL https://npmmirror.com/mirrors/node/v22.17.1/node-v22.17.1-x64.msi -o node-v22.17.1-x64.msi
    # 安装
    msiexec /i "node-v22.17.1-x64.msi" /norestart
    ```

2.  **下载并运行 WebTV 解压缩程序**
    ```powershell
    # 下载
    curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/WebTV-player.exe -o WebTV-player.exe
    # 运行安装/解压缩程序
    .\WebTV-player.exe
    ```

3.  **进入目录并运行播放器**
    *(注意: 如果您的系统盘不是 C 盘，请替换成您实际的磁盘机代号。)*
    ```powershell
    cd /d C:\node\webtv && .\player.exe
    ```
    *第一次运行，会自动下载模块，要耐心等待。*

> **💡 如何退出播放器:**
> 按下 `Ctrl` + `Alt` + `Q` 键即可退出播放程序。

