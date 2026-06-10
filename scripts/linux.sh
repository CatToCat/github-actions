#!/bin/bash

set -e


echo "Starting Linux Web Terminal"


# Install ttyd

if ! command -v ttyd >/dev/null
then

    sudo apt update -y

    sudo apt install -y \
        snapd \
        wget


    sudo snap install ttyd --classic

fi



# Install cloudflared

if ! command -v cloudflared >/dev/null
then

    wget -q \
    https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 \
    -O cloudflared


    chmod +x cloudflared

    sudo mv cloudflared /usr/local/bin/

fi



pkill ttyd || true
pkill cloudflared || true



echo "Starting ttyd"


ttyd \
-p 7681 \
-W \
bash &



echo "Starting cloudflared"


cloudflared tunnel \
--url http://localhost:7681 \
> cloudflared.log 2>&1 &



sleep 10



URL=$(grep -o \
"https://[a-zA-Z0-9.-]*trycloudflare.com" \
cloudflared.log | head -1)



echo ""
echo "================================"
echo "Linux Terminal Ready"
echo "================================"

echo "$URL"
