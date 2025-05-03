<#
.SYNOPSIS
    This PowerShell script enables auditing for Sensitive Privilege Use events,
    including both Success and Failure, in compliance with DISA STIG ID 17.8.1.1.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-01
    Last Modified   : 2025-05-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 17.8.1

.TESTED ON
    Date(s) Tested  : 2025-05-01
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to enable auditing for sensitive privilege usage events.

    Example:
    PS C:\> .\17.8.1.1_AuditSensitivePrivilegeUse.ps1

    To verify:
    PS C:\> auditpol /get /subcategory:"Sensitive Privilege Use"
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Retrieve current audit setting
$CurrentSetting = (auditpol /get /subcategory:"Sensitive Privilege Use") -join " "

# Check and apply if either Success or Failure is missing
if ($CurrentSetting -notmatch "Success" -or $CurrentSetting -notmatch "Failure") {
    Write-Host "Enabling 'Success' and 'Failure' auditing for Sensitive Privilege Use..."
    auditpol /set /subcategory:"Sensitive Privilege Use" /success:enable /failure:enable | Out-Null
} else {
    Write-Host "'Success' and 'Failure' auditing for Sensitive Privilege Use is already enabled."
}

# Confirm setting
Write-Host "`nCurrent Sensitive Privilege Use audit policy:"
auditpol /get /subcategory:"Sensitive Privilege Use"

Write-Host "`nSTIG 17.8.1 remediation complete."
