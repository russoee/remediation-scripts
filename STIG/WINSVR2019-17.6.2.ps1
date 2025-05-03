<#
.SYNOPSIS
    Enables auditing for File Share access (Success and Failure) under Object Access category,
    in compliance with DISA STIG ID 17.6.2.

.NOTES
    Author       : Eric Russo
    STIG-ID      : 17.6.2
    Date Created : 2025-05-02
    OS Tested    : Windows Server 2019 Datacenter
#>

# Ensure Admin
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Run this script as Administrator." -ForegroundColor Red
    exit 1
}

# Define path and value
$regPath = "HKLM:\Software\Policies\Microsoft\Windows\Audit"
$regName = "AuditObjectAccess"
$requiredValue = 3  # 3 = Success and Failure

# Create key if missing
if (!(Test-Path $regPath)) {
    New-Item -Path $regPath -Force | Out-Null
}

# Set policy value
Set-ItemProperty -Path $regPath -Name $regName -Type DWord -Value $requiredValue

# Confirm
$set = Get-ItemProperty -Path $regPath -Name $regName
Write-Host "AuditObjectAccess set to: $($set.AuditObjectAccess)"
Write-Host "Audit File Share (17.6.2) remediation complete."
