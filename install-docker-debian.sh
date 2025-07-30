#!/bin/bash
set -e

echo "🔍 Checking system version..."
if ! grep -qi "buster" /etc/os-release; then
  echo "⚠️  Warning: This script is recommended only for Debian 10 (Buster)."
  read -p "Do you want to continue? [y/N] " confirm
  [[ "$confirm" != "y" && "$confirm" != "Y" ]] && exit 1
fi

echo "📦 Installing APT dependencies..."
apt-get update -y
apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  apt-transport-https \
  software-properties-common \
  dirmngr

echo "🔐 Adding Docker's official GPG key..."
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 7EA0A9C3F273FCD8

echo "📦 Adding Docker repository..."
echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" \
  > /etc/apt/sources.list.d/docker.list

echo "🔄 Updating APT sources..."
apt-get update -y

echo "🐳 Installing Docker Engine and plugins..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo "✅ Enabling and starting Docker service..."
systemctl enable docker
systemctl start docker

echo "🚀 Testing Docker..."
docker run --rm hello-world || echo "⚠️  Warning: hello-world test failed, possibly due to network issues."

echo
echo "🎉 Docker installation completed! You can run:"
echo "   docker ps"
echo
echo "👉 If you want to run Docker without sudo, run:"
echo "   sudo usermod -aG docker \$USER && newgrp docker"
