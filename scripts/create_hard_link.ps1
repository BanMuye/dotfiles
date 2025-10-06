<#
.SYNOPSIS
Creates a hard link from a source file to a target path.

.DESCRIPTION
This script accepts two parameters: source file path and target file path.
It validates the paths, checks for existing target, and creates a hard link.

.PARAMETER SourcePath
The path to the existing source file.

.PARAMETER TargetPath
The path where the new hard link will be created.

.EXAMPLE
.\Create-HardLink.ps1 -SourcePath "C:\Data\original.txt" -TargetPath "D:\Backups\link.txt"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$SourcePath,

    [Parameter(Mandatory=$true)]
    [string]$TargetPath
)

function Write-ScriptStatus {
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

# Display startup information
Write-ScriptStatus "Starting hard link creation process..."
Write-ScriptStatus "Source path: $SourcePath"
Write-ScriptStatus "Target path: $TargetPath"
Write-Host ("-" * 50)

# Validation 1: Check if source file exists
if (-not (Test-Path -Path $SourcePath)) {
    Write-ScriptStatus "Source file does not exist: $SourcePath" -Type "ERROR"
    exit 1
}

# Validation 2: Check if source path is a file (not a directory)
if (-not (Test-Path -Path $SourcePath -PathType Leaf)) {
    Write-ScriptStatus "Source path must be a file, not a directory: $SourcePath" -Type "ERROR"
    exit 1
}

Write-ScriptStatus "Source file validation passed"

# Validation 3: Check if target file already exists
if (Test-Path -Path $TargetPath) {
    Write-ScriptStatus "Target file already exists: $TargetPath" -Type "WARNING"
    
    # Prompt user for action
    $confirmation = Read-Host "Do you want to delete the existing target file? [Y/N]"
    
    if ($confirmation -eq 'Y' -or $confirmation -eq 'y') {
        try {
            Remove-Item -Path $TargetPath -Force -ErrorAction Stop
            Write-ScriptStatus "Existing target file deleted successfully" -Type "SUCCESS"
        } catch {
            Write-ScriptStatus "Failed to delete existing target file: $($_.Exception.Message)" -Type "ERROR"
            exit 1
        }
    } else {
        Write-ScriptStatus "User chose not to delete existing file. Script terminated." -Type "INFO"
        exit 0
    }
}

# Validation 4: Check if source and target are on the same volume (required for hard links)
$sourceRoot = [System.IO.Path]::GetPathRoot($SourcePath)
$targetRoot = [System.IO.Path]::GetPathRoot($TargetPath)

if ($sourceRoot -ne $targetRoot) {
    Write-ScriptStatus "Hard links can only be created within the same volume." -Type "ERROR"
    Write-ScriptStatus "Source volume: $sourceRoot" -Type "ERROR"
    Write-ScriptStatus "Target volume: $targetRoot" -Type "ERROR"
    exit 1
}

Write-ScriptStatus "Volume validation passed: Source and target are on the same volume"

# Validation 5: Check if target directory exists, create if it doesn't
$targetDirectory = [System.IO.Path]::GetDirectoryName($TargetPath)
if (-not (Test-Path -Path $targetDirectory)) {
    Write-ScriptStatus "Target directory does not exist. Creating directory: $targetDirectory"
    try {
        New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
        Write-ScriptStatus "Target directory created successfully"
    } catch {
        Write-ScriptStatus "Failed to create target directory: $($_.Exception.Message)" -Type "ERROR"
        exit 1
    }
}

# Create the hard link
try {
    Write-ScriptStatus "Creating hard link..."
    $result = New-Item -ItemType HardLink -Path $TargetPath -Value $SourcePath -ErrorAction Stop
    Write-ScriptStatus "Hard link created successfully from '$SourcePath' to '$TargetPath'" -Type "SUCCESS"
} catch {
    Write-ScriptStatus "Failed to create hard link: $($_.Exception.Message)" -Type "ERROR"
    exit 1
}

# Final verification
Write-Host ("-" * 50)
Write-ScriptStatus "Performing final verification..."

if (Test-Path -Path $TargetPath) {
    # Verify it's actually a hard link
    $linkItem = Get-Item $TargetPath -ErrorAction SilentlyContinue
    if ($linkItem -and $linkItem.LinkType -eq "HardLink") {
        Write-ScriptStatus "Hard link verification passed: Link type confirmed" -Type "SUCCESS"
    } else {
        Write-ScriptStatus "Hard link created but link type verification inconclusive" -Type "WARNING"
    }
    
    # Test that both files point to the same data
    $sourceContent = Get-Content $SourcePath -Raw -ErrorAction SilentlyContinue
    $targetContent = Get-Content $TargetPath -Raw -ErrorAction SilentlyContinue
    
    if ($sourceContent -eq $targetContent) {
        Write-ScriptStatus "Content verification passed: Source and target contain identical data" -Type "SUCCESS"
    }
} else {
    Write-ScriptStatus "Hard link verification failed: Target path does not exist" -Type "ERROR"
    exit 1
}

Write-Host ("-" * 50)
Write-ScriptStatus "Script execution completed successfully"
