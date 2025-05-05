<#
 .SYNOPSIS
    Adds and enables registry value EnableCertPaddingCheck outlined in CVE-2013-3900.
    Please test thoroughly in a non-production environment before deploying widely.
    Make sure to run as Administrator or with appropriate privileges.

 .NOTES
    Author        : Eric Russo
    Date Created  : 2025-01-22
    Last Modified : 2025-01-22
    Version       : 1.0

.TESTED ON
    Date(s) Tested  : 2025-01-22
    Tested By       : Eric Russo
    Systems Tested  : Windows Server 2019 Datacenter, Build 1809
    PowerShell Ver. : 5.1.17763.6189

.USAGE
    Example syntax:
    PS C:\> .\cert-padding-check-remediation.ps1 
#>


# Define the registry paths and value name
$paths = @(
    "HKLM:\Software\Microsoft\Cryptography\Wintrust\Config",
    "HKLM:\Software\Wow6432Node\Microsoft\Cryptography\Wintrust\Config"
)

$valueName = "EnableCertPaddingCheck"
$valueData = 1

# Function to check and create registry path and set value
function Set-RegistryValue {
    param (
        [string]$Path,
        [string]$ValueName,
        [int]$ValueData
    )

    # Check if the registry path exists
    if (-not (Test-Path -Path $Path)) {
        Write-Output "Registry path '$Path' does not exist. Creating..."
        New-Item -Path $Path -Force | Out-Null
    } else {
        Write-Output "Registry path '$Path' already exists."
    }

    # Set the registry value
    Write-Output "Setting value '$ValueName' to '$ValueData' in '$Path'..."
    New-ItemProperty -Path $Path -Name $ValueName -Value $ValueData -PropertyType DWord -Force | Out-Null
}

# Iterate through each path and apply the changes
foreach ($path in $paths) {
    Set-RegistryValue -Path $path -ValueName $valueName -ValueData $valueData
}

Write-Output "Registry updates completed."
