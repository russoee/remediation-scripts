<#
.SYNOPSIS
    Disables the SMBv1 server protocol to comply with DISA STIG ID 18.4.4.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-05-02
    Last Modified   : 2025-05-02
    Version         : 1.0
    STIG-ID         : 18.4.4

.TESTED ON
    Date(s) Tested  : 2025-05-02
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter
    PowerShell Ver. : 5.1

.USAGE
    Run this script as Administrator to disable the SMBv1 server protocol.

    Example:
    PS C:\> .\WINSVR2019-18.4.4_Disable_SMBv1_Server.ps1

    To verify:
    PS C:\> Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" -Name SMB1
#>

# Admin check
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Run this script as Administrator." -ForegroundColor Red
    exit 1
}

# Registry path and expected value
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters"
$regName = "SMB1"
$desiredValue = 0  # Disable SMBv1

# Create the path if it doesn't exist
if (!(Test-Path $regPath)) {
    Write-Host "Creating registry path: $regPath"
    New-Item -Path $regPath -Force | Out-Null
}

# Set the value
Set-ItemProperty -Path $regPath -Name $regName -Type DWord -Value $desiredValue

# Confirm setting
$current = (Get-ItemProperty -Path $regPath -Name $regName).$regName
Write-Host "`nSMB1 is now set to: $current (0 = Disabled)"
Write-Host "STIG 18.4.4 remediation complete. SMBv1 server is disabled."
