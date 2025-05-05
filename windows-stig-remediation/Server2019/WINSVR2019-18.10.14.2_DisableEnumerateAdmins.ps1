<#
.SYNOPSIS
    This PowerShell script disables administrator account enumeration on elevation prompts,
    in compliance with DISA STIG ID 18.10.14.2.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-01
    Last Modified   : 2025-05-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 18.10.14.2

.TESTED ON
    Date(s) Tested  : 2025-05-01
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to disable admin account enumeration during UAC elevation.

    Example:
    PS C:\> .\18.10.14.2_UAC_AdminEnumeration_Disable.ps1

    To verify:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI" -Name EnumerateAdministrators
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Define registry path and values
$RegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\CredUI"
$ValueName = "EnumerateAdministrators"
$RequiredValue = 0  # 0 = Do not enumerate admin accounts

# Ensure the key exists
if (!(Test-Path $RegPath)) {
    Write-Host "Creating registry path: $RegPath"
    New-Item -Path $RegPath -Force | Out-Null
}

# Set the required value
Set-ItemProperty -Path $RegPath -Name $ValueName -Value $RequiredValue -Type DWord

# Confirm
$SetValue = (Get-ItemProperty -Path $RegPath -Name $ValueName).$ValueName
Write-Host "EnumerateAdministrators is now set to: $SetValue"
Write-Host "STIG 18.10.14.2 remediation complete."
