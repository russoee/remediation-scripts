<#
.SYNOPSIS
    Enables Microsoft Defender Attack Surface Reduction (ASR) rules for STIG compliance.

.NOTES
    Author       : Eric Russo
    STIG-ID      : 18.10.42.6.1.1
    Date Created : 2025-05-02
    Version      : 1.0

.TESTED ON
    OS           : Windows Server 2019 Datacenter
    PowerShell   : 5.1
#>

# Check for Admin rights
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "This script must be run as Administrator." -ForegroundColor Red
    exit 1
}

# ASR Rules Path
$basePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR\Rules"

# Ensure base path exists
if (!(Test-Path $basePath)) {
    New-Item -Path $basePath -Force | Out-Null
}

# Recommended Rules (STIG-friendly)
$asrRules = @{
    "D4F940AB-401B-4EFC-AADC-AD5F3C50688A" = 1 # Block credential stealing from LSASS
    "3B576869-A4EC-4529-8536-B80A7769E899" = 1 # Block Office apps from creating child processes
    "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84" = 1 # Block credential stealing from obfuscated scripts
    "26190899-1602-49E8-8B27-EB1D0A1CE869" = 1 # Block Office files from web that contain macros
}

# Set each rule
foreach ($guid in $asrRules.Keys) {
    Set-ItemProperty -Path $basePath -Name $guid -Type String -Value $asrRules[$guid]
    Write-Host "ASR Rule $guid set to mode: $($asrRules[$guid])"
}

Write-Host "STIG 18.10.42.6.1.1 remediation complete — ASR rules enabled."
