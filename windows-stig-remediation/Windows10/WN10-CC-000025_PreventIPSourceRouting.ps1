<#
.SYNOPSIS
    Prevents IP source routing to comply with STIG ID WN10-CC-000025.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-02-18
    Last Modified   : 2025-02-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000025

.TESTED ON
    Date(s) Tested  : 2025-02-18
    Tested By       : Eric Russo
    Systems Tested  : Windows 10 
    PowerShell Ver. : 5.1 (Compatible with native Windows PowerShell)

.USAGE
    Run as administrator:
    ```powershell
    .\WN10-CC-000025_remediation.ps1
    ```
#>

# Ensure script is running with administrative privileges
if (-not ([System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

# Define registry path and key
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
$RegName = "DisableIPSourceRouting"
$RegValue = 2

# Check if registry key exists, if not, create it
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set registry key value
Set-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -Type DWord

# Confirm change
$Result = Get-ItemProperty -Path $RegPath -Name $RegName | Select-Object -ExpandProperty $RegName
if ($Result -eq $RegValue) {
    Write-Host "IP source routing has been disabled successfully." -ForegroundColor Green
} else {
    Write-Host "Failed to disable IP source routing." -ForegroundColor Red
}
