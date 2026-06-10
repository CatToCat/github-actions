#!/bin/bash

set -e


echo "Starting macOS Web Terminal"



if ! command -v brew
then

echo "Installing Homebrew"

 /bin/bash -c \
 "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

fi



if ! command -v ttyd
then
    brew install ttyd
fi



if ! command -v cloudflared
then
    brew install cloudflared
fi



pkill ttyd || true
pkill cloudflared || true



ttyd \
-p 7681 \
-W \
bash &



cloudflared tunnel \
--url http://localhost:7681 \
> cloudflared.log 2>&1 &



sleep 10



URL=$(grep -o \
"https://[a-zA-Z0-9.-]*trycloudflare.com" \
cloudflared.log | head -1)



echo ""
echo "================================"
echo "macOS Terminal Ready"
echo "================================"

echo "$URL"
