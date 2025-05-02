<#
.SYNOPSIS
    This PowerShell script enables auditing for Credential Validation events, including both Success and Failure,
    in compliance with DISA STIG ID 17.1.1 for Windows Server systems.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-01
    Last Modified   : 2025-05-01
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 17.1.1

.TESTED ON
    Date(s) Tested  : 2025-05-01
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to configure auditing for credential validation events.

    Example:
    PS C:\> .\17.1.1_CredentialValidation_Audit.ps1

    To verify:
    PS C:\> auditpol /get /subcategory:"Credential Validation"
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal]()
