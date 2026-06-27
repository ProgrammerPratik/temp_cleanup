@echo off
:: Self-elevation script - automatically requests admin rights
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else (
    goto gotAdmin
)
:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
:gotAdmin
    if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
    pushd "%CD%"
    CD /D "%~dp0"

:: Main script starts here
echo ================================================
echo    Windows Temporary Files Cleanup Script
echo ================================================
echo.
echo Running with administrator privileges...
echo.
echo Starting cleanup process...
echo.

:: Clean Windows Temp folder
echo [1/6] Cleaning C:\Windows\Temp...
del /f /s /q "C:\Windows\Temp\*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*") do rmdir /s /q "%%p" >nul 2>&1
echo Complete.
echo.

:: Clean Prefetch folder
echo [2/6] Cleaning C:\Windows\Prefetch...
del /f /s /q "C:\Windows\Prefetch\*" >nul 2>&1
echo Complete.
echo.

:: Clean User Temp folder
echo [3/6] Cleaning %TEMP%...
del /f /s /q "%TEMP%\*" >nul 2>&1
for /d %%p in ("%TEMP%\*") do rmdir /s /q "%%p" >nul 2>&1
echo Complete.
echo.

:: -----------------------------------------------
:: Clean SoftwareDistribution (Windows Update Cache)
:: Must stop Windows Update service first to unlock files
:: -----------------------------------------------
echo [4/6] Cleaning SoftwareDistribution (Windows Update Cache)...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
net stop cryptsvc >nul 2>&1
del /f /s /q "C:\Windows\SoftwareDistribution\*" >nul 2>&1
for /d %%p in ("C:\Windows\SoftwareDistribution\*") do rmdir /s /q "%%p" >nul 2>&1
net start wuauserv >nul 2>&1
net start bits >nul 2>&1
net start cryptsvc >nul 2>&1
echo Complete. (Windows Update services restarted)
echo.

:: -----------------------------------------------
:: Clean NVIDIA Shader Caches for all user profiles
:: Auto-discovers all user folders under C:\Users
:: -----------------------------------------------
echo [5/6] Cleaning NVIDIA DXCache for all users...
for /d %%U in ("C:\Users\*") do (
    if exist "%%U\AppData\Local\NVIDIA\DXCache" (
        del /f /s /q "%%U\AppData\Local\NVIDIA\DXCache\*" >nul 2>&1
        for /d %%p in ("%%U\AppData\Local\NVIDIA\DXCache\*") do rmdir /s /q "%%p" >nul 2>&1
        echo    Cleaned: %%U\AppData\Local\NVIDIA\DXCache
    )
)
echo Complete.
echo.

echo [6/6] Cleaning NVIDIA GLCache for all users...
for /d %%U in ("C:\Users\*") do (
    if exist "%%U\AppData\Local\NVIDIA\GLCache" (
        del /f /s /q "%%U\AppData\Local\NVIDIA\GLCache\*" >nul 2>&1
        for /d %%p in ("%%U\AppData\Local\NVIDIA\GLCache\*") do rmdir /s /q "%%p" >nul 2>&1
        echo    Cleaned: %%U\AppData\Local\NVIDIA\GLCache
    )
)
echo Complete.
echo.

echo ================================================
echo Cleanup finished!
echo.
echo Note: Some files may not be deleted if they are
echo currently in use by Windows or other programs.
echo This is normal and safe.
echo.
echo NVIDIA shader caches will rebuild automatically
echo the next time you launch a game or 3D application.
echo ================================================
echo.
pause