function Write-Start{
    param ($msg)
    Write-Host(">> " + $msg) -ForegroundColor Green
}
function Write-Done{
    Write-Host("DONE") -ForegroundColor Green
    Write-Host
}
#Start
Write-Start -msg "Disable UAC"
Start-Process -Wait powershell -Verb runas -ArgumentList "Set-ItemProperty -Path REGISTRY::HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System -Name ConsentPromptBehaviorAdmin -Value 0"
Write-Done
#chocolatey
Write-Start -msg "Install Chocolatey. . ."
if(Get-Command choco -ErrorAction SilentlyContinue)
{
    Write-Warning "Chocolatey Already Installed"
}
else
{
    Start-Process -Wait powershell -Verb runas -ArgumentList "Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"

}
Write-Done
#Scoop
Write-Start -msg "Install Scoop. . ."
if(Get-Command scoop -ErrorAction SilentlyContinue)
{
    Write-Warning "Scoop Already Installed"
    Write-Host
}
else
{
    irm get.scoop.sh | iex
    Write-Done
}
Write-Start -msg "Initializing Scoop. . ."
    scoop install git
    scoop bucket add extras
    scoop bucket add java
    scoop add nerd-fonts
    scoop update
Write-Done
Write-Start -msg "Installing Scoop's packages"
    scoop install <# Web Brower #> googlechrome
    scoop install <# Tool #> alacritty neofetch obs-studio
    scoop install <# Coding #> neovim vscode main/mingw nodejs openjdk python postman
    scoop install <# Lib #> vagrant
Start-Process -Wait powershell -Verb runas -ArgumentList "scoop install Intel-One-Mono vcredist vlc wpsoffice main/7zip"
Write-Done
Write-Start -msg "Installing Unikey"
$A = "$env:UserProfile\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Unikey\UnikeyNT.lnk" -replace ' ', '` '
$B = "$env:UserProfile\Desktop"
Start-Process -Wait powershell -Verb runas -ArgumentList "choco install -y unikey --force; Copy-Item $A -Destination $B"
Write-Done
Write-Start -msg "Disable Fire Wall"
    Start-Process -Wait powershell -Verb runas -ArgumentList "Set-NetFirewallProfile -Enabled False ; Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False"
Write-Done
Write-Start -msg "Clean temp file"
    Start-Process -Wait powershell -Verb runas -ArgumentList "Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue ; Remove-Item -Path C:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue ; Remove-Item -Path C:\Windows\Prefetch\* -Recurse -Force -ErrorAction SilentlyContinue"
    start -Wait clear -Verb runas
Write-Done