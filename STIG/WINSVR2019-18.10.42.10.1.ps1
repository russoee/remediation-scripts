<#
.SYNOPSIS
    Enables scanning of downloaded files and attachments in Microsoft Defender Antivirus,
    in compliance with STIG ID 18.10.42.10.1.

.NOTES
    Author          : Eric Russo
    STIG-ID         : 18.10.42.10.1
    Date Created    : 2025-05-02
    OS              : Windows Server 2019 Datacenter
#>

# Admin check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator." -ForegroundColor Red
    exit 1
}

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
$regName = "DisableIOAVProtection"
$desiredValue = 0

if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

Set-ItemProperty -Path $regPath -Name $regName -Type DWord -Value $desiredValue

# Confirm
$current = Get-ItemProperty -Path $regPath -Name $regName
Write-Host "`nDisableIOAVProtection is now set to: $($current.DisableIOAVProtection)"
Write-Host "Scan for downloaded files and attachments is ENABLED."
