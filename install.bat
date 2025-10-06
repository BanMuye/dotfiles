@echo off
setlocal enabledelayedexpansion

echo ========================================
echo          start creating hard link 
echo ========================================
echo.

set "SOURCE_FILE=D:\Files\S_Documents\Projects\dotfiles\.vimrc"
set "LINK_FILE=C:\Users\cyzho\.ideavimrc"

echo source file: %SOURCE_FILE%
echo hard link file: %LINK_FILE%
echo.

:: check whether source file exist 
if not exist "%SOURCE_FILE%" (
    echo [error] source file don't exist: %SOURCE_FILE%
    pause
    exit /b 1
)

:: check whether link file exist
if exist "%LINK_FILE%" (
    echo [error] target link file already exists: %LINK_FILE%
    choice /c YN /m "do you want to delete target link file？(Y/N)"
    if !errorlevel! equ 1 (
        echo deleting file...
        del /f /q "%LINK_FILE%" 2>nul
        if exist "%LINK_FILE%" (
            echo [error] fail to delete file
            pause
            exit /b 1
        )
        echo target file already deleted
    ) else (
        echo operation cancelled
        pause
        exit /b 0
    )
)

:: creating hard link
echo creating hard link...
mklink /h "%LINK_FILE%" "%SOURCE_FILE%"

if %errorlevel% equ 0 (
    echo [success] creating hard link successfully
    echo now %LINK_FILE% has been linked to %SOURCE_FILE%
) else (
    echo [error] fail to create hard link (error code: %errorlevel%)
)

echo.
pause
