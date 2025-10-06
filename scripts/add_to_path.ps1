<#
.SYNOPSIS
Safely adds a directory to the Windows PATH environment variable.

.DESCRIPTION
This script accepts a path parameter, validates its existence, checks if it's already in PATH,
and permanently adds it if all conditions are met.

.PARAMETER PathToAdd
The directory path to add to PATH

.PARAMETER Scope
The scope of the environment variable: User (default) or Machine

.EXAMPLE
.\Add-ToPath.ps1 -PathToAdd "C:\Program Files\Vim\vim91"
.\Add-ToPath.ps1 -PathToAdd "C:\MyTools" -Scope Machine
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$PathToAdd,
    
    [ValidateSet("User", "Machine")]
    [string]$Scope = "User"
)

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Type = "INFO"
    )
    
    switch ($Type) {
        "SUCCESS" { Write-Host "[SUCCESS] $Message" -ForegroundColor Green }
        "ERROR" { Write-Host "[ERROR] $Message" -ForegroundColor Red }
        "WARNING" { Write-Host "[WARNING] $Message" -ForegroundColor Yellow }
        default { Write-Host "[INFO] $Message" -ForegroundColor Cyan }
    }
}

# Display script startup information
Write-ColorOutput "Starting PATH environment variable configuration..."
Write-ColorOutput "Target path: $PathToAdd"
Write-ColorOutput "Scope: $Scope"
Write-Host ("-" * 50)

# 1. Check administrator privileges (if modifying system PATH)
if ($Scope -eq "Machine") {
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsPrincipal]::Administrator)) {
        Write-ColorOutput "Administrator privileges required for system PATH modification. Please run this script as Administrator." -Type "ERROR"
        exit 1
    }
}

# 2. Path normalization
$PathToAdd = $PathToAdd.Trim().Trim('"', "'").TrimEnd('\')

# 3. Validate path legality
if ([string]::IsNullOrWhiteSpace($PathToAdd)) {
    Write-ColorOutput "Error: The provided path is empty or contains only whitespace characters." -Type "ERROR"
    exit 1
}

if (-not (Test-Path -Path $PathToAdd -PathType Container)) {
    Write-ColorOutput "Error: Path '$PathToAdd' does not exist or is not a valid directory." -Type "ERROR"
    exit 1
}

Write-ColorOutput "Path validation passed: Directory exists and is valid"

# 4. Check if path already exists in PATH
$currentPath = [Environment]::GetEnvironmentVariable("PATH", $Scope)
$pathEntries = $currentPath -split ';' | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

$pathExists = $false
foreach ($entry in $pathEntries) {
    if ($entry.Trim().TrimEnd('\') -eq $PathToAdd) {
        $pathExists = $true
        break
    }
}

if ($pathExists) {
    Write-ColorOutput "Path '$PathToAdd' already exists in $Scope PATH. No action needed." -Type "WARNING"
    exit 0
}

Write-ColorOutput "Path not found in PATH. Preparing to add..."

# 5. Construct new PATH value
if ([string]::IsNullOrEmpty($currentPath)) {
    $newPath = $PathToAdd
} else {
    $newPath = $currentPath.TrimEnd(';') + ';' + $PathToAdd
}

# 6. Permanently update PATH environment variable
try {
    [Environment]::SetEnvironmentVariable("PATH", $newPath, $Scope)
    Write-ColorOutput "Successfully added path '$PathToAdd' to $Scope PATH environment variable." -Type "SUCCESS"
    
    # Temporarily update current session PATH for immediate use
    $env:Path = [Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" + 
                [Environment]::GetEnvironmentVariable("PATH", "User")
    
    Write-Host ("-" * 50)
    Write-ColorOutput "Note: Permanent changes require new command line windows to take full effect."
    Write-ColorOutput "Current session has been temporarily updated for immediate testing."
    
} catch {
    Write-ColorOutput "Error updating PATH environment variable: $($_.Exception.Message)" -Type "ERROR"
    exit 1
}

# 7. Final verification
Write-Host ("-" * 50)
Write-ColorOutput "Final verification:"

$updatedPath = [Environment]::GetEnvironmentVariable("PATH", $Scope)
if ($updatedPath -like "*$PathToAdd*") {
    Write-ColorOutput "✓ Confirmed path successfully added to $Scope PATH" -Type "SUCCESS"
} else {
    Write-ColorOutput "⚠ Path addition verification failed, manual check may be needed" -Type "WARNING"
}

# Test path accessibility
try {
    $testFile = Join-Path $PathToAdd "test_access.tmp"
    $null = New-Item -Path $testFile -ItemType File -Force -ErrorAction Stop
    Remove-Item $testFile -Force
    Write-ColorOutput "✓ Path accessibility test passed" -Type "SUCCESS"
} catch {
    Write-ColorOutput "⚠ Path accessibility test failed: $($_.Exception.Message)" -Type "WARNING"
}
