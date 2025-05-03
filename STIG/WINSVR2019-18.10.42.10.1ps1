<#
.SYNOPSIS
    This PowerShell script enables SmartScreen scanning for downloaded files and attachments,
    in compliance with DISA STIG ID 18.10.42.10.1.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-02
    Last Modified   : 2025-05-02
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 18.10.42.10.1

.TESTED ON
    Date(s) Tested  : 2025-05-02
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to enable SmartScreen scanning of downloaded files and attachments.

    Example:
    PS C:\> .\18.10.42.10.1_EnableAttachmentScan.ps1

    To verify:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name EnableSmartScreen
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Define registry path and values
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
$ValueName = "EnableSmartScreen"
$RequiredValue = 1  # 1 = Enabled

# Ensure the key exists
if (!(Test-Path $RegPath)) {
    Write-Host "Creating registry path: $RegPath"
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the required value
Set-ItemProperty -Path $RegPath -Name $ValueName -Value $RequiredValue -Type DWord

# Confirm
$SetValue = (Get-ItemProperty -Path $RegPath -Name $ValueName).$ValueName
Write-Host "EnableSmartScreen is now set to: $SetValue"
Write-Host "STIG 18.10.42.10.1 remediation complete."
