<#
.SYNOPSIS
    This PowerShell script sets the Account Lockout Threshold to 5 invalid logon attempts,
    in compliance with DISA STIG ID 1.2.2 for Windows Server systems.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-01
    Last Modified   : 2025-05-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 1.2.2

.TESTED ON
    Date(s) Tested  : 2025-05-01
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to configure account lockout threshold to 5 attempts.
    
    Example:
    PS C:\> .\1.2.2_AccountLockoutThreshold_Remediation.ps1

    To verify:
    PS C:\> net accounts
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Set account lockout threshold to 5
Write-Host "Setting account lockout threshold to 5 invalid logon attempts..."
net accounts /lockoutthreshold:5

# Confirm the change
Write-Host "`nCurrent account policy:"
net accounts

Write-Host "`nSTIG 1.2.2 remediation complete."
