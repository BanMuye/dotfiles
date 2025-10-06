# set env

$workRootPath = "C:\Users\cyzho\dotfiles"

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

# try set path

$pathArr = @("C:\Program Files\Vim\vim91")
$addPathScript = ".\scripts\add_to_path.ps1"

foreach ($pathItem in $pathArr) {

    try {
        & $addPathScript -PathToAdd $pathItem -Scope User
            Write-Host "[SUCCESS] Wrapper script execution completed." -ForegroundColor Green
    } catch {
        Write-Host "[ERROR] Failed to execute the main script: $($_.Exception.Message)" -ForegroundColor Red
            exit 1
    }

}

# try create hard link

$linkPairs = @{
    "$HOME\.vimrc"="$workRootPath\.vimrc";
    "$HOME\.ideavimrc"="$workRootPath\.vimrc"
}

$createHardLinkScript = "$workRootPath\scripts\create_hard_link.ps1"

# Iterate through each key-value pair in the dictionary
foreach ($pair in $linkPairs.GetEnumerator()) {
        $targetPath = $pair.Key
        $sourcepath = $pair.Value

        Write-ColorOutput "Processing pair:"
        Write-Host "  Source: $sourcePath"
        Write-Host "  Target: $targetPath"

        try {
# Call the hard link creation script with current pair
            & $createHardLinkScript -SourcePath $sourcePath -TargetPath $targetPath

                if ($?) {
                    Write-ColorOutput "Hard link created successfully" -Type "SUCCESS"
                        $successCount++
                } else {
                    Write-ColorOutput "Hard link creation failed" -Type "ERROR"
                        $failureCount++
                }
        }
    catch {
        Write-ColorOutput "Error executing hard link script: $($_.Exception.Message)" -Type "ERROR"
            $failureCount++
    }

    Write-Host ("-" * 40)
}
