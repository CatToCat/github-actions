Write-Host "Starting Windows Web Terminal"



# Install chocolatey

if (!(Get-Command choco -ErrorAction SilentlyContinue))
{

Set-ExecutionPolicy Bypass -Scope Process -Force


[System.Net.ServicePointManager]::SecurityProtocol =
[System.Net.ServicePointManager]::SecurityProtocol -bor 3072


iex ((New-Object System.Net.WebClient).DownloadString(
'https://community.chocolatey.org/install.ps1'
))

}



if (!(Get-Command ttyd -ErrorAction SilentlyContinue))
{
    choco install ttyd -y
}



if (!(Get-Command cloudflared -ErrorAction SilentlyContinue))
{
    choco install cloudflared -y
}



Stop-Process -Name ttyd `
-Force `
-ErrorAction SilentlyContinue


Stop-Process -Name cloudflared `
-Force `
-ErrorAction SilentlyContinue



Start-Process `
ttyd `
"-p 7681 -W powershell"



Start-Process `
cloudflared `
"tunnel --url http://localhost:7681"



Write-Host ""
Write-Host "================================"
Write-Host "Windows Terminal Ready"
Write-Host "================================"