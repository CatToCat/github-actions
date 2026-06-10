#!/bin/bash
set -e

echo "Starting macOS Web Terminal"

# Homebrew
if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

brew install ttyd cloudflared || true

pkill ttyd || true
pkill cloudflared || true

ttyd -p 7681 -W bash &

cloudflared tunnel --url http://localhost:7681 > cf.log 2>&1 &

sleep 10

URL=$(grep -o "https://[a-zA-Z0-9.-]*trycloudflare.com" cf.log | head -1)

echo ""
echo "macOS Web Terminal Ready:"
echo "$URL"