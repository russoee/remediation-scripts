<#
.SYNOPSIS
    This PowerShell script enables PowerShell Script Block Logging,
    ensuring compliance with DISA STIG ID WN10-CC-000326.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-02-17
    Last Modified   : 2025-02-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000326

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : Windows 10 
    PowerShell Ver. : 5.1 (Compatible with native Windows PowerShell)

.USAGE
    Run this script as an Administrator to enable PowerShell Script Block Logging.

    Example usage:
    PS C:\> .\WN10-CC-000326_remediation.ps1
    
    To verify compliance, run:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging" -Name "EnableScriptBlockLogging"
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Define registry path and required value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
$ValueName = "EnableScriptBlockLogging"
$RequiredValue = 1  # 1 = Enabled

# Check if the registry path exists
if (!(Test-Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating registry key..."
    New-Item -Path $RegPath -Force | Out-Null
}

# Get current value
$CurrentValue = (Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName

# Compare and set value if needed
if ($CurrentValue -ne $RequiredValue -or $null -eq $CurrentValue) {
    Write-Host "Enabling PowerShell Script Block Logging..."
    Set-ItemProperty -Path $RegPath -Name $ValueName -Type DWord -Value $RequiredValue
} else {
    Write-Host "PowerShell Script Block
