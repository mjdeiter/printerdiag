@echo off
:: Set the working directory to the folder where this batch file is located
pushd "%~dp0"

:: Launch the PowerShell script
:: -NoProfile: Prevents loading the user's PowerShell profile (faster startup)
:: -ExecutionPolicy Bypass: Allows this specific script to run without changing system-wide security
:: -File: Points to your diagnostic script in the same folder
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "printerdiag.ps1"

:: Return to the original directory and close the window
popd
exit
