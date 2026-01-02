@echo off
echo ================================================
echo    Windows Temporary Files Cleanup Script
echo ================================================
echo.

:: Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This script requires administrator privileges.
    echo Please right-click and select "Run as administrator"
    echo.
    pause
    exit /b 1
)

echo Starting cleanup process...
echo.

:: Clean Windows Temp folder
echo [1/3] Cleaning C:\Windows\Temp...
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*") do rmdir /s /q "%%p" >nul 2>&1
echo Complete.
echo.

:: Clean Prefetch folder
echo [2/3] Cleaning C:\Windows\Prefetch...
del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1
echo Complete.
echo.

:: Clean User Temp folder
echo [3/3] Cleaning %TEMP%...
del /f /s /q "%TEMP%\*" >nul 2>&1
for /d %%p in ("%TEMP%\*") do rmdir /s /q "%%p" >nul 2>&1
echo Complete.
echo.

echo ================================================
echo Cleanup finished!
echo.
echo Note: Some files may not be deleted if they are
echo currently in use by Windows or other programs.
echo This is normal and safe.
echo ================================================
echo.
pause