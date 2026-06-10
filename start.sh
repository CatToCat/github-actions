#!/bin/bash

set -e


echo "Installing ttyd and cloudflared"


# ----------------------------
# Install ttyd
# ----------------------------

if ! command -v ttyd >/dev/null 2>&1
then
    sudo apt update -y
    sudo apt install -y snapd

    sudo snap install ttyd --classic
fi



# ----------------------------
# Install cloudflared
# ----------------------------

if ! command -v cloudflared >/dev/null 2>&1
then

    ARCH=$(uname -m)

    if [ "$ARCH" = "aarch64" ]
    then
        BIN="cloudflared-linux-arm64"
    else
        BIN="cloudflared-linux-amd64"
    fi


    wget -q \
    https://github.com/cloudflare/cloudflared/releases/download/2025.10.1/$BIN \
    -O cloudflared


    chmod +x cloudflared

    sudo mv cloudflared /usr/local/bin/

fi



# ----------------------------
# Start ttyd
# ----------------------------

pkill ttyd || true
pkill cloudflared || true


echo "Starting ttyd..."

ttyd \
  -p 7681 \
  -W \
  bash &


sleep 3



# ----------------------------
# Start Cloudflare tunnel
# ----------------------------


echo "Starting cloudflare tunnel"


cloudflared tunnel \
 --url http://localhost:7681 \
 > cloudflared.log 2>&1 &



sleep 10



URL=$(grep -o \
"https://[a-zA-Z0-9.-]*trycloudflare.com" \
cloudflared.log | head -1)



echo ""
echo "========================================"
echo " Web Terminal Ready"
echo "========================================"


echo "Local:"
echo "http://localhost:7681"


if [ -n "$URL" ]
then
    echo ""
    echo "Public:"
    echo "$URL"
else
    echo "Tunnel URL not ready"
    cat cloudflared.log
fi


echo "========================================"