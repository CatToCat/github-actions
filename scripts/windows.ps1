Write-Host "================================"
Write-Host "Windows Code-Server Web IDE"
Write-Host "================================"

# -----------------------------
# Install Chocolatey dependencies
# -----------------------------
if (!(Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Node.js..."
    choco install nodejs -y
}

$env:Path += ";C:\Program Files\nodejs\"

if (!(Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Python..."
    choco install python -y
}

if (!(Get-Command cloudflared -ErrorAction SilentlyContinue)) {
    Write-Host "Installing cloudflared..."
    choco install cloudflared -y
}

# -----------------------------
# Install code-server
# -----------------------------
Write-Host "Installing code-server..."

npm install -g code-server --verbose 2>&1 | ForEach-Object {
    Write-Host $_
}

# -----------------------------
# Verify
# -----------------------------
if (!(Get-Command code-server -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: code-server installation failed"
    exit 1
}

# -----------------------------
# Start code-server
# -----------------------------
Write-Host "Starting code-server on port 8080..."

Start-Process -NoNewWindow -FilePath "cmd.exe" `
    -ArgumentList "/c code-server --bind-addr 0.0.0.0:8080 --auth none"

Start-Sleep 8

# -----------------------------
# Verify port
# -----------------------------
netstat -ano | findstr ":8080"

Write-Host "code-server running on port 8080"

# -----------------------------
# Start Cloudflare tunnel (SAFE METHOD)
# -----------------------------
Write-Host "Starting Cloudflare tunnel..."

$cfLog = "$PWD\cf.log"

# IMPORTANT: capture output safely
cmd /c "cloudflared tunnel --url http://localhost:8080" 2>&1 |
    Tee-Object -FilePath $cfLog | ForEach-Object {
        Write-Host $_
    }

# -----------------------------
# Extract URL
# -----------------------------
Write-Host ""
Write-Host "================================"
Write-Host "Cloudflare Public URL"
Write-Host "================================"

$url = Select-String -Path $cfLog -Pattern "https://[a-zA-Z0-9.-]*trycloudflare.com" |
       Select-Object -First 1

if ($url) {
    Write-Host $url.Line
} else {
    Write-Host "URL not ready yet (check cf.log)"
}

# -----------------------------
# Keep alive
# -----------------------------
Write-Host ""
Write-Host "Keep alive started..."

$minutes = 60
$end = (Get-Date).AddMinutes($minutes)

while ((Get-Date) -lt $end) {
    Write-Host ("Running... {0}" -f (Get-Date))
    Start-Sleep 300
}

Write-Host "Done"