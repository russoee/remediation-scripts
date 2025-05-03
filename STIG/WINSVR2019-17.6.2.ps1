<#
.SYNOPSIS
    This PowerShell script enables auditing for File Share access failures,
    in compliance with DISA STIG ID 17.6.2 for Windows Server systems.

.NOTES
    Author          : Eric Russo  
    LinkedIn        : linkedin.com/in/russo-eric/  
    GitHub          : github.com/russoee  
    Date Created    : 2025-05-01  
    Last Modified   : 2025-05-01  
    Version         : 1.0  
    CVEs            : N/A  
    Plugin IDs      : N/A  
    STIG-ID         : 17.6.2

.TESTED ON
    Date(s) Tested  : 2025-05-01  
    Tested By       : Eric Russo  
    Systems Tested  : Windows Server 2019 Datacenter  
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to enable auditing for failed access to file shares.

    Example:
    PS C:\> .\17.6.2_AuditFileShare_Failure.ps1

    To verify:
    PS C:\> auditpol /get /subcategory:"File Share"
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Retrieve current audit setting
$CurrentSetting = (auditpol /get /subcategory:"File Share") -join " "

# Apply the setting if 'Failure' is not enabled
if ($CurrentSetting -notmatch "Failure") {
    Write-Host "Enabling 'Failure' auditing for File Share access..."
    auditpol /set /subcategory:"File Share" /failure:enable | Out-Null
} else {
    Write-Host "'Failure' auditing for File Share access is already enabled."
}

# Confirm the setting
Write-Host "`nCurrent File Share audit policy:"
auditpol /get /subcategory:"File Share"

Write-Host "`nSTIG 17.6.2 remediation complete."
