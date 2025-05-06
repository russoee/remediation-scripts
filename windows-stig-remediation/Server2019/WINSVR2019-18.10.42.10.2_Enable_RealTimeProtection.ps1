<#
.SYNOPSIS
    Ensures Microsoft Defender real-time protection is enabled for STIG compliance (18.10.42.10.2).

.NOTES
    Author       : Eric Russo
    STIG-ID      : 18.10.42.10.2
    Date Created : 2025-05-03
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

# Registry path for Defender Real-Time Protection policy
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"

# Ensure the path exists
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set DisableRealtimeMonitoring to 0 (which means real-time protection is ON)
Set-ItemProperty -Path $regPath -Name "DisableRealtimeMonitoring" -Type DWord -Value 0

Write-Host "Real-time protection enabled. STIG 18.10.42.10.2 remediation complete."
