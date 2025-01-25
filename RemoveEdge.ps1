if (([Security.Principal.WindowsIdentity]::GetCurrent()).Owner.Value -ne "S-1-5-32-544") {
    $terminal = "powershell"
    if (Get-Command wt -ErrorAction SilentlyContinue) { $terminal = "wt" }
        Start-Process wt -Verb RunAs "PowerShell -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

if (!(Test-Path "C:\Program Files (x86)\Microsoft\Edge")){
    $option = Read-Host "Edge was not Found, Would you Like to Re-install it? (Y/n)"
    if ("$option" -ne "n"){
        winget install -s winget "Microsoft Edge"
    }
    Write-Host "Exiting"
    pause; exit
}

Enable-ComputerRestore -Drive "$env:HOMEDRIVE" 
Checkpoint-Computer -Description "Before RemoveEdge" -RestorePointType "MODIFY_SETTINGS"

Write-Host "Disabling Edge Updates"
New-Item -Path "HKLM:\SOFTWARE\Microsoft\" -Name "EdgeUpdate" -Force
New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate\" -Name "DoNotUpdateToEdgeWithChromium" -Type DWORD -Value 1 -Force

Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process

Write-Host "Removing Edge Shortcuts From: Desktop & Start Menu"
Get-Item "$HOME\Desktop\*","C:\ProgramData\Microsoft\Windows\Start Menu\Programs\*" -Include "*Microsoft Edge*" | % { Remove-Item "$_" -Force -Verbose }

Get-Item "C:\Program Files (x86)\Microsoft\Edge\","$env:LOCALAPPDATA\Packages\Microsoft.MicrosoftEdge*" | % {Remove-Item "$_" -Recurse -Force -Verbose}
    
    Remove-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -ErrorAction SilentlyContinue

Get-Process explorer | Stop-Process
