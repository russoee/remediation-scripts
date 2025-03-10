<#
.SYNOPSIS
    This PowerShell script disables Basic authentication for the Windows Remote Management (WinRM) Service,
    ensuring compliance with DISA STIG ID WN10-CC-000345.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-02-17
    Last Modified   : 2025-02-17
    Version         : 1.1
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000345

.TESTED ON
    Date(s) Tested  : 2025-02-17
    Tested By       : Eric Russo
    Systems Tested  : Windows 10 
    PowerShell Ver. : 5.1 (Compatible with native Windows PowerShell)

.USAGE
    Run this script as an Administrator to disable Basic authentication for the WinRM Service.

    Example usage:
    PS C:\> .\WN10-CC-000345_remediation.ps1
    
    To verify compliance, run:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service" -Name "AllowBasic"
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Define registry path and required value
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
$ValueName = "AllowBasic"
$RequiredValue = 0  # 0 = Disabled

# Check if the registry path exists
if (!(Test-Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating registry key..."
    New-Item -Path $RegPath -Force | Out-Null
}

# Get current value
$CurrentValue = (Get-ItemProperty -Path $RegPath -Name $ValueName -ErrorAction SilentlyContinue).$ValueName

# Compare and set value if needed
if ($CurrentValue -ne $RequiredValue -or $null -eq $CurrentValue) {
    Write-Host "Disabling Basic authentication for the WinRM Service..."
    Set-ItemProperty -Path $RegPath -Name $ValueName -Type DWord -Value $RequiredValue
} else {
    Write-Host "Basic authentication for WinRM Service is already disabled."
}

# Confirm change
$UpdatedValue = (Get-ItemProperty -Path $RegPath -Name $ValueName).$ValueName
Write-Host "Current AllowBasic value: $UpdatedValue (0 = Disabled)"

Write-Host "WN10-CC-000345 remediation complete."

