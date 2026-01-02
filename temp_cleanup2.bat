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