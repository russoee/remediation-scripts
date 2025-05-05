<#
.SYNOPSIS
    This PowerShell script enables auditing for logoff events (success and failure),
    in compliance with DISA STIG ID 17.5.2.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-01
    Last Modified   : 2025-05-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 17.5.2

.TESTED ON
    Date(s) Tested  : 2025-05-01
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to enable auditing for user logoff events.

    Example:
    PS C:\> .\17.5.2_AuditLogoff_SuccessFailure.ps1

    To verify:
    PS C:\> auditpol /get /subcategory:"Logoff"
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Check current audit setting
$CurrentSetting = (auditpol /get /subcategory:"Logoff") -join " "

# Apply policy if not already set
if ($CurrentSetting -notmatch "Success" -or $CurrentSetting -notmatch "Failure") {
    Write-Host "Enabling 'Success' and 'Failure' auditing for Logoff events..."
    auditpol /set /subcategory:"Logoff" /success:enable /failure:enable | Out-Null
} else {
    Write-Host "'Success' and 'Failure' auditing for Logoff events is already enabled."
}

# Confirm new setting
Write-Host "`nCurrent audit policy for Logoff:"
auditpol /get /subcategory:"Logoff"

Write-Host "`nSTIG 17.5.2 remediation complete."
