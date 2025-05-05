<#
.SYNOPSIS
    Enables detection and blocking of potentially unwanted applications (PUAs) in Microsoft Defender,
    in compliance with DISA STIG ID 18.10.42.16.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-02
    Last Modified   : 2025-05-02
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : 18.10.42.16

.TESTED ON
    Date(s) Tested  : 2025-05-02
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to enable blocking of potentially unwanted applications in Defender.

    Example:
    PS C:\> .\WINSVR2019-18.10.42.16_Block_PUAs.ps1

    To verify:
    PS C:\> Get-MpPreference | Select-Object PUAProtection
#>

# Admin check
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Registry Path for PUA Protection
$RegPath = "HKLM:\Software\Policies\Microsoft\Windows Defender"
$ValueName = "PUAProtection"
$RequiredValue = 1  # 1 = Enabled (Block), 0 = Off, 2 = Audit

# Ensure subkey exists
if (!(Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Apply setting
Set-ItemProperty -Path $RegPath -Name $ValueName -Type DWord -Value $RequiredValue

# Confirm
$Set = Get-ItemProperty -Path $RegPath -Name $ValueName
Write-Host "`nPUAProtection is now set to: $($Set.PUAProtection)"
Write-Host "STIG 18.10.42.16 remediation complete. PUAs will now be blocked by Microsoft Defender."
