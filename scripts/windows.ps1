Write-Host "Starting Windows Web Terminal (Wetty)"

# Node.js
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    choco install nodejs -y
}

# cloudflared
if (!(Get-Command cloudflared -ErrorAction SilentlyContinue)) {
    choco install cloudflared -y
}

# Install wetty
npm install -g wetty

# Cleanup
Stop-Process -Name node -Force -ErrorAction SilentlyContinue
Stop-Process -Name cloudflared -Force -ErrorAction SilentlyContinue

# Start Wetty (PowerShell terminal)
Start-Process wetty -ArgumentList "--port 7681 --command powershell"

Start-Sleep 5

# Start tunnel
Start-Process cloudflared -ArgumentList "tunnel --url http://localhost:7681"

Start-Sleep 10

Write-Host ""
Write-Host "================================"
Write-Host "Windows Web Terminal Ready"
Write-Host "================================"