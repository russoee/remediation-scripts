<#
.SYNOPSIS
    This PowerShell script ensures that the maximum size of the Windows Application event log is at least 32768 KB (32 MB),
    in compliance with DISA STIG ID WN10-AU-000500.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-02-17
    Last Modified   : 2025-02-17
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-AU-000500

.TESTED ON
    Date(s) Tested  : 2025-02-17
    Tested By       : Eric Russo
    Systems Tested  : Windows 10 
    PowerShell Ver. : 5.1 (Compatible with native Windows PowerShell)

.USAGE
    Run this script as an Administrator to remediate WN10-AU-000500.
    
    Example usage:
    PS C:\> .\WN10-AU-000500_remediation.ps1
    
    To verify compliance, run:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application" -Name MaxSize
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Define registry path and required value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Application"
$ValueName = "MaxSize"
$RequiredSize = 0x00008000  # 32768 KB

# Check if the registry key exists
if (!(Test-Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating registry key..."
    New-Item -Path $RegPath -Force | Out-Null
}

# Get current value
$CurrentValue = (Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName

# Compare and set value if needed
if ($CurrentValue -lt $RequiredSize -or $null -eq $CurrentValue) {
    Write-Host "Updating Application Event Log MaxSize to 32768 KB..."
    Set-ItemProperty -Path $RegPath -Name $ValueName -Type DWord -Value $RequiredSize
} else {
    Write-Host "Application Event Log MaxSize is already set to a compliant value."
}

# Confirm change
$UpdatedValue = (Get-ItemProperty -Path $RegPath -Name $ValueName).$ValueName
Write-Host "Current MaxSize: $UpdatedValue KB"

Write-Host "WN10-AU-000500 remediation complete."
