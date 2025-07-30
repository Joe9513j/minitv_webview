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

### Step 1: Pull and Run the Docker Image

```bash
docker run -d \
  --name webtv \
  --restart unless-stopped \
  -p 8000:8000 \
  bin456789/webtv
```
