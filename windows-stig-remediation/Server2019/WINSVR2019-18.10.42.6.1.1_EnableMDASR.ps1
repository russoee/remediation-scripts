<#
.SYNOPSIS
    Enables Microsoft Defender Attack Surface Reduction (ASR) rules and master toggle for STIG compliance.

.NOTES
    Author       : Eric Russo
    STIG-ID      : 18.10.42.6.1.1
    Date Created : 2025-05-02
    Last Modified: 2025-05-03
    Version      : 1.1

.TESTED ON
    OS           : Windows Server 2019 Datacenter
    PowerShell   : 5.1
#>

# Check for Admin rights
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Write-Host "This script must be run as Administrator." -ForegroundColor Red
    exit 1
}

# Master ASR setting path
$asrMainPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Windows Defender Exploit Guard\ASR"
if (!(Test-Path $asrMainPath)) {
    New-Item -Path $asrMainPath -Force | Out-Null
}
Set-ItemProperty -Path $asrMainPath -Name "ExploitGuard_ASR_Rules" -Type DWord -Value 1
Write-Host "ASR Master Rule configuration enabled."

# ASR Rules registry path
$basePath = "$asrMainPath\Rules"
if (!(Test-Path $basePath)) {
    New-Item -Path $basePath -Force | Out-Null
}

# Recommended ASR Rules
$asrRules = @{
    "D4F940AB-401B-4EFC-AADC-AD5F3C50688A" = 1 # Block credential stealing from LSASS
    "3B576869-A4EC-4529-8536-B80A7769E899" = 1 # Block Office apps from creating child processes
    "75668C1F-73B5-4CF0-BB93-3ECF5CB7CC84" = 1 # Block credential stealing from obfuscated scripts
    "26190899-1602-49E8-8B27-EB1D0A1CE869" = 1 # Block Office files from web that contain macros
}

# Apply each rule
foreach ($guid in $asrRules.Keys) {
    Set-ItemProperty -Path $basePath -Name $guid -Type String -Value $asrRules[$guid]
    Write-Host "ASR Rule $guid set to mode: $($asrRules[$guid])"
}

Write-Host "STIG 18.10.42.6.1.1 remediation complete — ASR rules and configuration enabled."
