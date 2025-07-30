#!/bin/bash
# curl -O https://raw.githubusercontent.com/bin456789/reinstall/main/reinstall.sh && bash reinstall.sh debian 10 --password 123456 --ci  && reboot
set -euo pipefail
IFS=$'\n\t'

# === Configuration ===
USER="webplay"
APP_DIR="/home/$USER/webtv"
LOG_FILE="/var/log/install-webtv.log"
TEMP_DIR=$(mktemp -d)
TIMESTAMP=$(date +%Y%m%d%H%M%S)

# === Colors ===
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# === Logging ===
log() {
  local level=$1
  shift
  local message=$*
  local color=$NC

  case $level in
    "INFO") color=$GREEN ;;
    "WARN") color=$YELLOW ;;
    "ERROR") color=$RED ;;
  esac

  echo -e "[$(date '+%F %T')] ${color}${level}${NC}: $message" | tee -a "$LOG_FILE"
}

cleanup() {
  log "INFO" "🚧 Cleaning up temporary files..."
  rm -rf "$TEMP_DIR"
  log "INFO" "✅ Temporary files removed"
}

trap cleanup EXIT

log "INFO" "🚀 Starting WebTV deployment..."

# Step 1: Clean environment
log "INFO" "==> Step 1: Cleaning old services and user config..."
{
  systemctl stop webtv.service 2>/dev/null || true
  pkill -u "$USER" || true
  apt-get purge -y pulseaudio* libpulse* || log "WARN" "PulseAudio not found, skipping"
  rm -f /etc/systemd/system/webtv.service
  rm -f /etc/X11/xorg.conf.d/20-graphics.conf /etc/asound.conf
  rm -rf /etc/pulse

  if id "$USER" &>/dev/null; then
    rm -f /home/$USER/.xsession /home/$USER/start-webtv.sh /home/$USER/.asoundrc*
  fi
} || {
  log "ERROR" "Error during cleanup"
  exit 1
}

# Step 2: Install dependencies (APT source unchanged)
log "INFO" "==> Step 2: Installing required packages..."
{
  apt-get update || {
    log "ERROR" "APT update failed"
    exit 1
  }

  apt-get install -y \
    sudo nano curl wget openssl unzip rsync p7zip-full xserver-xorg xinit xauth \
    libnss3 libatk-bridge2.0-0 libgtk-3-0 libxss1 libasound2 x11-utils gnupg \
    ca-certificates openbox util-linux dbus-x11 netcat-openbsd x11-xserver-utils \
    lightdm policykit-1 mesa-utils vainfo alsa-utils libgbm1 libgl1-mesa-dri \
    libgl1-mesa-glx libegl1-mesa fonts-wqy-microhei fonts-wqy-zenhei xfonts-wqy \
    ttf-wqy-zenhei ttf-wqy-microhei fonts-arphic-ukai fonts-arphic-uming \
    fonts-noto-cjk locales apt-utils dialog firmware-realtek || {
      log "ERROR" "Package installation failed"
      exit 1
    }
} || {
  log "ERROR" "Error during dependency installation"
  exit 1
}

HOSTNAME_CURRENT="WebTV-Player"
sudo hostnamectl set-hostname "$HOSTNAME_CURRENT"
sudo cp /etc/hosts /etc/hosts.bak
if grep -q "^127.0.1.1" /etc/hosts; then
    sudo sed -i "s/^127.0.1.1.*/127.0.1.1       $HOSTNAME_CURRENT/" /etc/hosts
else
    echo "127.0.1.1       $HOSTNAME_CURRENT" | sudo tee -a /etc/hosts > /dev/null
fi

# Step 3: Locale, GPU and user config
log "INFO" "==> Step 3: Configuring locale, graphics, and user..."
{
  if ! grep -q '^zh_CN.UTF-8' /etc/locale.gen; then
    echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
  fi

  locale-gen zh_CN.UTF-8 || log "WARN" "Locale generation failed"
  update-locale LANG=zh_CN.UTF-8 LC_ALL=zh_CN.UTF-8 || log "WARN" "Locale setting failed"

  GPU_INFO=$(lspci -nn | grep -i "vga\|3d\|display" || true)

  case $GPU_INFO in
    *Intel*) log "INFO" "Detected Intel GPU"
             apt-get install -y xserver-xorg-video-intel intel-media-va-driver-non-free i965-va-driver ;;
    *AMD*|*ATI*) log "INFO" "Detected AMD/ATI GPU"
                 apt-get install -y xserver-xorg-video-amdgpu ;;
    *NVIDIA*) log "INFO" "Detected NVIDIA GPU"
              apt-get install -y nvidia-driver nvidia-settings nvidia-vdpau-driver ;;
    *VMware*) log "INFO" "Detected VMware GPU"
              apt-get install -y xserver-xorg-video-vmware open-vm-tools-desktop ;;
    *VirtualBox*) log "INFO" "Detected VirtualBox GPU"
                  apt-get install -y xserver-xorg-video-vboxvideo virtualbox-guest-utils ;;
    *) log "WARN" "Unknown GPU type" ;;
  esac

  mkdir -p /etc/X11/xorg.conf.d
  cat > /etc/X11/xorg.conf.d/20-graphics.conf <<'EOF'
Section "Device"
    Identifier  "Configured Video Device"
    Driver      "modesetting"
EndSection
EOF

  if ! id "$USER" &>/dev/null; then
    adduser --disabled-password --gecos "" "$USER" || {
      log "ERROR" "User creation failed"
      exit 1
    }
  fi

  usermod -aG audio,video,tty,input,render,dialout,plugdev "$USER" || {
    log "ERROR" "User group modification failed"
    exit 1
  }

  cat > /etc/lightdm/lightdm.conf <<EOF
[Seat:*]
autologin-user=$USER
autologin-user-timeout=0
user-session=openbox
EOF
} || {
  log "ERROR" "Error in system config"
  exit 1
}

# Step 4: Audio config
log "INFO" "==> Step 4: Detecting and configuring audio..."
{
  ANALOG_CARD_ID=$(aplay -l | grep -i -E "analog|speaker|pch" | head -n1 | sed -r 's/card ([0-9]+):.*/\1/')
  if [ -z "$ANALOG_CARD_ID" ]; then
    log "WARN" "Fallback to first card"
    ANALOG_CARD_ID=$(awk '/^\s*[0-9]+/ {print $1}' /proc/asound/cards | head -n1)
  fi

  if [ -z "$ANALOG_CARD_ID" ]; then
    log "ERROR" "No audio card detected"
    exit 1
  fi

  log "INFO" "Detected audio card: $ANALOG_CARD_ID"

  cat > /home/$USER/.asoundrc <<EOF
pcm.dmixer {
  type dmix
  ipc_key 1024
  slave {
    pcm "hw:$ANALOG_CARD_ID,0"
    period_time 0
    period_size 1024
    buffer_size 4096
    rate 44100
    channels 2
  }
}
pcm.dsnooper {
  type dsnoop
  ipc_key 1024
  slave {
    pcm "hw:$ANALOG_CARD_ID,0"
    channels 2
    period_time 0
    period_size 1024
    buffer_size 4096
    rate 44100
  }
}
pcm.duplex {
  type asym
  playback.pcm "dmixer"
  capture.pcm "dsnooper"
}
pcm.!default {
  type plug
  slave.pcm "duplex"
}
ctl.!default {
  type hw
  card $ANALOG_CARD_ID
}
EOF

  chown $USER:$USER /home/$USER/.asoundrc
} || {
  log "ERROR" "Audio configuration failed"
  exit 1
}

# Step 5: App directory & session file
log "INFO" "==> Step 5: Preparing application and session..."
{
  mkdir -p "$APP_DIR"
  chown -R $USER:$USER "$APP_DIR"

  cat > /home/$USER/.xsession <<'EOF'
#!/bin/bash
exec openbox-session
EOF

  cat > /home/$USER/start-webtv.sh <<EOF
#!/bin/bash
export DISPLAY=:0
export XAUTHORITY=/home/$USER/.Xauthority
cd "$APP_DIR"
node aktv.js || true
exec /usr/bin/npm start -- --no-sandbox
EOF

  chmod +x /home/$USER/.xsession /home/$USER/start-webtv.sh
  chown $USER:$USER /home/$USER/.xsession /home/$USER/start-webtv.sh
} || {
  log "ERROR" "App/session file config failed"
  exit 1
}

# Step 6: Create systemd service
log "INFO" "==> Step 6: Creating systemd service..."
{
  cat > /etc/systemd/system/webtv.service <<EOF
[Unit]
Description=WebTV AutoPlay Service
After=lightdm.service sound.target

[Service]
User=$USER
Group=$USER
ExecStartPre=/bin/sleep 3
ExecStart=/usr/bin/dbus-launch --exit-with-session /home/$USER/start-webtv.sh
Restart=on-failure
RestartSec=10
Environment="DISPLAY=:0"
Environment="XAUTHORITY=/home/$USER/.Xauthority"

[Install]
WantedBy=graphical.target
EOF
} || {
  log "ERROR" "Systemd service creation failed"
  exit 1
}

# Step 7: Install Node.js
log "INFO" "==> Step 7: Installing Node.js..."
{
  curl -fsSL https://deb.nodesource.com/setup_current.x | bash - || {
    log "ERROR" "NodeSource setup failed"
    exit 1
  }

  apt install -y nodejs || {
    log "ERROR" "Node.js install failed"
    exit 1
  }
} || {
  log "ERROR" "Node.js setup error"
  exit 1
}

# Step 8: Deploy application
log "INFO" "==> Step 8: Deploying application..."
{
  ZIP_FILE="$(dirname "$0")/webtv-min.zip"
  if [ ! -f "$ZIP_FILE" ]; then
    log "ERROR" "Missing webtv-min.zip"
    exit 1
  fi

  7z x "$ZIP_FILE" -o"$APP_DIR" || {
    log "ERROR" "Unzip failed"
    exit 1
  }

  chown -R $USER:$USER "$APP_DIR"
  sudo -u $USER bash -c "cd $APP_DIR && npm install" || {
    log "ERROR" "npm install failed"
    exit 1
  }
} || {
  log "ERROR" "App deploy failed"
  exit 1
}

# Step 9: Audio unmute
log "INFO" "==> Step 9: Audio setup..."
{
  for control in Master PCM Speaker Front Playback; do
    if amixer -c "$ANALOG_CARD_ID" scontrols | grep -q "$control"; then
      amixer -c "$ANALOG_CARD_ID" sset "$control" 100% unmute >/dev/null || {
        log "WARN" "Failed to unmute $control"
      }
    fi
  done
  alsactl store || log "WARN" "ALSA store failed"
} || {
  log "ERROR" "Audio setup failed"
  exit 1
}

# Step 10: Finalize
log "INFO" "==> Step 10: Finalizing system setup..."
{
  update-alternatives --set x-session-manager /usr/bin/openbox-session || {
    log "WARN" "Failed to set openbox session"
  }

  systemctl daemon-reload
  systemctl enable webtv.service || {
    log "ERROR" "Failed to enable webtv service"
    exit 1
  }

  log "INFO" "Updating GRUB..."
  apt remove -y desktop-base || true

  cat > /etc/default/grub <<'EOF'
GRUB_DEFAULT=0
GRUB_TIMEOUT=1
GRUB_TIMEOUT_STYLE=hidden
GRUB_HIDDEN_TIMEOUT=1
GRUB_HIDDEN_TIMEOUT_QUIET=true
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX="console=ttyS0,115200n8 console=tty0 quiet"
EOF

  update-grub || log "WARN" "GRUB update failed"
} || {
  log "ERROR" "Final setup failed"
  exit 1
}

log "INFO" "✅ Installation complete. Rebooting in 10 seconds..."
sleep 10
reboot
