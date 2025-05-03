<#
.SYNOPSIS
    This PowerShell script enables auditing for Windows Firewall rule-level policy changes,
    including both Success and Failure, in compliance with DISA STIG ID 17.4.4.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-01
    Last Modified   : 2025-05-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 17.4.4

.TESTED ON
    Date(s) Tested  : 2025-05-01
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to enable auditing for Windows Firewall rule-level changes.

    Example:
    PS C:\> .\17.4.4_AuditMPSSVC_PolicyChange.ps1

    To verify:
    PS C:\> auditpol /get /subcategory:"MPSSVC Rule-Level Policy Change"
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Get current audit setting
$CurrentSetting = (auditpol /get /subcategory:"MPSSVC Rule-Level Policy Change") -join " "

# Apply setting if either Success or Failure is missing
if ($CurrentSetting -notmatch "Success" -or $CurrentSetting -notmatch "Failure") {
    Write-Host "Enabling 'Success' and 'Failure' auditing for MPSSVC Rule-Level Policy Change..."
    auditpol /set /subcategory:"MPSSVC Rule-Level Policy Change" /success:enable /failure:enable | Out-Null
} else {
    Write-Host "'Success' and 'Failure' auditing for MPSSVC Rule-Level Policy Change is already enabled."
}

# Confirm the setting
Write-Host "`nCurrent audit policy for MPSSVC Rule-Level Policy Change:"
auditpol /get /subcategory:"MPSSVC Rule-Level Policy Change"

Write-Host "`nSTIG 17.4.4 remediation complete."
