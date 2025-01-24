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
