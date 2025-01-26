if (([Security.Principal.WindowsIdentity]::GetCurrent()).Owner.Value -ne "S-1-5-32-544") { Start-Process wt -Verb RunAs "PowerShell -ExecutionPolicy Bypass -File `"$PSCommandPath`""; exit }
if (!(Test-Path "C:\Program Files (x86)\Microsoft\Edge")) { exit }
Enable-ComputerRestore -Drive "$env:HOMEDRIVE"; Checkpoint-Computer -Description "Before RemoveEdge" -RestorePointType "MODIFY_SETTINGS"
New-Item -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Force | Out-Null; New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Name "DoNotUpdateToEdgeWithChromium" -Type DWORD -Value 1 -Force
Get-Process msedge -ErrorAction SilentlyContinue | Stop-Process
Get-Item "$HOME\Desktop\*", "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\*", "C:\Program Files (x86)\Microsoft\Edge\", "$env:LOCALAPPDATA\Packages\Microsoft.MicrosoftEdge*" | Remove-Item -Recurse -Force
Remove-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -ErrorAction SilentlyContinue
Stop-Process -Name explorer -Force
#this removes edge without any questions
