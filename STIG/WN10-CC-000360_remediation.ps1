<#
.SYNOPSIS
    This PowerShell script disables Basic authentication and enables 'Disallow Digest Authentication'
    for the Windows Remote Management (WinRM) Client, ensuring compliance with DISA STIG ID WN10-CC-000360.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-02-17
    Last Modified   : 2025-02-17
    Version         : 1.1
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000360

.TESTED ON
    Date(s) Tested  : 
    Tested By       : 
    Systems Tested  : Windows 10 
    PowerShell Ver. : 5.1 (Compatible with native Windows PowerShell)

.USAGE
    Run this script as an Administrator to disable Basic authentication and enable 'Disallow Digest Authentication' for the WinRM Client.

    Example usage:
    PS C:\> .\WN10-CC-000360_remediation.ps1
    
    To verify compliance, run:
    PS C:\> Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
#>

# Ensure script is running as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator. Exiting..." -ForegroundColor Red
    exit 1
}

# Define registry path and required values
$RegPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
$BasicAuthValue = "AllowBasic"
$DigestAuthValue = "AllowDigest"
$RequiredBasicValue = 0  # 0 = Disable Basic Authentication
$RequiredDigestValue = 1  # 1 = Enable "Disallow Digest Authentication"

# Check if the registry path exists
if (!(Test-Path $RegPath)) {
    Write-Host "Registry path does not exist. Creating registry key..."
    New-Item -Path $RegPath -Force | Out-Null
}

# Disable Basic Authentication
$CurrentBasicValue = (Get-ItemProperty -Path $RegPath -Name $BasicAuthValue -ErrorAction SilentlyContinue).$BasicAuthValue
if ($CurrentBasicValue -ne $RequiredBasicValue -or $null -eq $CurrentBasicValue) {
    Write-Host "Disabling Basic authentication for the WinRM Client..."
    Set-ItemProperty -Path $RegPath -Name $BasicAuthValue -Type DWord -Value $RequiredBasicValue
} else {
    Write-Host "Basic authentication for WinRM Client is already disabled."
}

# Enable "Disallow Digest Authentication"
$CurrentDigestValue = (Get-ItemProperty -Path $RegPath -Name $DigestAuthValue -ErrorAction SilentlyContinue).$DigestAuthValue
if ($CurrentDigestValue -ne $RequiredDigestValue -or $null -eq $CurrentDigestValue) {
    Write-Host "Enabling 'Disallow Digest Authentication' for the WinRM Client..."
    Set-ItemProperty -Path $RegPath -Name $DigestAuthValue -Type DWord -Value $RequiredDigestValue
} else {
    Write-Host "'Disallow Digest Authentication' for WinRM Client is already enabled."
}

# Refresh Group Policy in case it is overriding registry settings
Write-Host "Forcing Group Policy update..."
gpupdate /force | Out-Null

# Restart WinRM Service to apply changes
Write-Host "Restarting WinRM service..."
Restart-Service -Name WinRM -Force -ErrorAction SilentlyContinue

# Confirm changes
$UpdatedBasicValue = (Get-ItemProperty -Path $RegPath -Name $BasicAuthValue).$BasicAuthValue
$UpdatedDigestValue = (Get-ItemProperty -Path $RegPath -Name $DigestAuthValue).$DigestAuthValue
Write-Host "Current AllowBasic value: $UpdatedBasicValue (0 = Disabled)"
Write-Host "Current AllowDigest value: $UpdatedDigestValue (1 = Enabled)"

Write-Host "WN10-CC-000360 remediation complete."
