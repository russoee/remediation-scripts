<#
.SYNOPSIS
    Configures Early Launch Antimalware (ELAM) Boot-Start Driver Initialization policy to enforce "Good only" for maximum security, complying with STIG ID WN10-CC-000085.

.DESCRIPTION
    This script modifies the registry to set the `DriverLoadPolicy` value, ensuring that only trusted ("Good") drivers load during the Windows boot process. This prevents malicious or unauthorized drivers from loading early and compromising the system.

    Possible values for `DriverLoadPolicy`:
      - `8` (Recommended) → **Good only** (Most secure, prevents all untrusted drivers)
      - `1` → **Good and Unknown** (Allows unverified drivers but blocks explicitly bad ones)
      - `3` → **Good, Unknown, and Bad but Critical** (Allows necessary bad drivers, default Windows behavior)
      - `7` (Non-compliant) → **All drivers, including bad ones** (This is a security risk and a finding)

    Modify `$RegValue` in this script if a different security level is required.

.NOTES
    Author          : Eric Russo
    LinkedIn        : linkedin.com/in/russo-eric/
    GitHub          : github.com/russoee
    Date Created    : 2025-02-18
    Last Modified   : 2025-02-18
    Version         : 1.0
    CVEs            : N/A
    Plugin IDs      : N/A
    STIG-ID         : WN10-CC-000085

.TESTED ON
    Date(s) Tested  : 2025-02-18
    Tested By       : Eric Russo
    Systems Tested  : Windows 10
    PowerShell Ver. : 5.1 (Compatible with native Windows PowerShell)

.USAGE
    Run as administrator:
    ```powershell
    .\WN10-CC-000085_remediation.ps1
    ```
    
    To modify security level, change the `$RegValue` variable.
#>

# Ensure script is running with administrative privileges
if (-not ([System.Security.Principal.WindowsPrincipal] [System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "This script must be run as an Administrator." -ForegroundColor Red
    exit 1
}

# Define registry path and key
$RegPath = "HKLM:\SYSTEM\CurrentControlSet\Policies\EarlyLaunch"
$RegName = "DriverLoadPolicy"
$RegValue = 8  # Set to 8 for maximum security (Good only)

# Check if registry key exists, if not, create it
if (-not (Test-Path $RegPath)) {
    New-Item -Path $RegPath -Force | Out-Null
}

# Set registry key value
Set-ItemProperty -Path $RegPath -Name $RegName -Value $RegValue -Type DWord

# Confirm change
$Result = Get-ItemProperty -Path $RegPath -Name $RegName | Select-Object -ExpandProperty $RegName
if ($Result -eq $RegValue) {
    Write-Host "Early Launch Antimalware Boot-Start Driver Policy configured successfully (Good only)." -ForegroundColor Green
} else {
    Write-Host "Failed to configure Early Launch Antimalware Boot-Start Driver Policy." -ForegroundColor Red
}
