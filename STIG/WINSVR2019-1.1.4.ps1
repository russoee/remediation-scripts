<#
.SYNOPSIS
    This PowerShell script ensures the minimum password length is set to 14 characters,
    in compliance with DISA STIG ID 1.1.4 for Windows systems.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-01
    Last Modified   : 2025-05-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 1.1.4

.TESTED ON
    Date(s) Tested  : 2025-05-01
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2022
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to set the minimum password length to 14.
    
    Example:
    PS C:\> .\1.1.4_MinPasswordLength_Remediation.ps1

    To verify:
    PS C:\> net accounts
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Set minimum password length to 14 using 'net accounts'
Write-Host "Setting minimum password length to 14 characters..."
net accounts /minpwlen:14

# Confirm the change
Write-Host "`nCurrent password policy:"
net accounts

Write-Host "`nSTIG 1.1.4 remediation complete."
