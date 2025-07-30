
# WebTV Installation Guide

This guide provides two methods for installing WebTV on Debian-based systems.

> **網頁電視 (WebTV) 安裝指南**
>
> 本指南提供了兩種在類 Debian 系統上安裝 WebTV 的方法。

---

## **Method 1: For a Fresh Debian 10 System**

This method is for users who need to install WebTV in a clean Debian 10 environment.

> **方案一：適用於全新 Debian 10 系統**
>
> 此方法適用於需要在一個純淨的 Debian 10 環境中安裝 WebTV 的用戶。

---

### **Step 1: Reinstall Debian 10 with One Click**

Use the command below to reinstall your system with a clean Debian 10 image.

```bash
curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 10 --password 123456 --ci && reboot
```

> **⚠️ Warning:**
> * This action will **completely erase** your current system!
> * Be sure to **back up all important data** before running this script.
> * The default password is set to `123456`. Please change it immediately after your first login.

---

> #### **步驟一：一鍵重新安裝 Debian 10**
>
> 使用以下指令將您的系統重灌為一個乾淨的 Debian 10 映像。
>
> ```bash
> curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 10 --password 123456 --ci && reboot
> ```
>
> > **⚠️ 警告：**
> > * 此操作將會 **完全清除** 您當前的系統！
> > * 在執行此腳本前，請務必 **備份所有重要資料**。
> > * 預設密碼設置為 `123456`，請在首次登錄後立即更改。

---

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
> ```bash
> # 更新軟件包列表並安裝必要工具
> apt update && apt install -y sudo nano curl wget
> 
> # 下載 WebTV 核心文件
> curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/webtv-min.zip -o webtv-min.zip
> 
> # 執行 WebTV 安裝腳本
> curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/setup-debian-webtv-only.sh | bash
> ```

---

## **Method 2: One-Click Install for Existing Desktop Systems**

This method is for users who are already running an Fnos, Debian, or Ubuntu desktop system and wish to install WebTV directly.

> **方案二：適用於現有桌面環境的一鍵安裝**
>
> 此方法適用於已經運行 Fnos、Debian 或 Ubuntu 桌面系統，並希望直接安裝 WebTV 的用戶。

---

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
> ```bash
> curl -sSL https://raw.githubusercontent.com/Joe9513j/webtv/refs/heads/main/install-webtv-fnos | bash
> ```
>
> > **💡 提示：**
> > 此腳本會自動偵測您的系統環境並完成所有必要的安裝步驟。

