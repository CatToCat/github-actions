#!/bin/bash
set -e

echo "Starting Linux Web Terminal"

# ttyd
if ! command -v ttyd >/dev/null 2>&1; then
  sudo apt update -y
  sudo apt install -y snapd
  sudo snap install ttyd --classic
fi

# cloudflared
if ! command -v cloudflared >/dev/null 2>&1; then
  wget -q https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -O cloudflared
  chmod +x cloudflared
  sudo mv cloudflared /usr/local/bin/
fi

pkill ttyd || true
pkill cloudflared || true

ttyd -p 7681 -W bash &

cloudflared tunnel --url http://localhost:7681 > cf.log 2>&1 &

sleep 10

URL=$(grep -o "https://[a-zA-Z0-9.-]*trycloudflare.com" cf.log | head -1)

echo ""
echo "Linux Web Terminal Ready:"
echo "$URL"