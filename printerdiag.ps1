<#
.SYNOPSIS
    Network Printer Diagnostic Tool
    Developed by: Matthew Deiter (matthewdeiter.com)
    https://github.com/mjdeiter/printerdiag/
    
.VERSION_HISTORY
    1.0 - Initial release
    1.1 - Added IP extraction and dual-logging
    1.2 - Added SNMP capability check and Version tracking
    1.2.1 - Fixed param block position error
#>

param( [string]$PrinterName )

# Variables must come AFTER param()
$ScriptVersion = "1.2.1"
$ErrorActionPreference = "Continue"
$reportPath = "$env:USERPROFILE\Desktop\Printer_Diag_Results.txt"
$reportData = [System.Collections.Generic.List[string]]::new()

function Write-Log {
    param([string]$Message, [string]$Color = "White", [string]$Prefix = "[i]")
    $line = "$Prefix $Message"
    Write-Host $line -ForegroundColor $Color
    $reportData.Add($line)
}

function Write-Section {
    param($Title)
    $line = "=== $Title ==="
    Write-Host "`n$line" -ForegroundColor Magenta
    $reportData.Add("`n$line")
}

try {
    # --- HEADER & CREDIT ---
    Write-Host "---------------------------------------------------------------" -ForegroundColor Cyan
    Write-Host "       PRINTER DIAGNOSTIC TOOL                                 " -ForegroundColor Cyan
    Write-Host "       Created by: Matthew Deiter                              " -ForegroundColor Cyan
    Write-Host "       Link: https://matthewdeiter.com                         " -ForegroundColor Cyan
    Write-Host "       Link: https://github.com/mjdeiter/printerdiag/          " -ForegroundColor Cyan
    Write-Host "       Version: $ScriptVersion                                 " -ForegroundColor Cyan
    Write-Host "---------------------------------------------------------------" -ForegroundColor Cyan

    $reportData.Add("PRINTER DIAGNOSTIC REPORT v$ScriptVersion")
    $reportData.Add("Generated: $(Get-Date)")
    $reportData.Add("User: $env:USERNAME | Computer: $env:COMPUTERNAME")
    $reportData.Add("Credits: matthewdeiter.com")
    $reportData.Add("------------------------------------------------")

    # 1. Print Spooler Check
    Write-Section "SYSTEM: Print Spooler"
    $spooler = Get-Service -Name "Spooler"
    if ($spooler.Status -eq "Running") {
        Write-Log "Spooler service is active." "Green" "[OK]"
    } else {
        Write-Log "Spooler is $($spooler.Status)." "Red" "[X]"
    }

    # 2. Printer Discovery
    $printers = if ($PrinterName) { Get-Printer -Name $PrinterName -ErrorAction SilentlyContinue } else { Get-Printer }
    
    foreach ($p in $printers) {
        Write-Section "ANALYZING: $($p.Name)"
        
        $ip = "N/A (Virtual/Local)"
        $snmpStatus = "Disabled/Unsupported"
        
        try {
            $port = Get-PrinterPort -Name $p.PortName -ErrorAction SilentlyContinue
            if ($port.PrinterHostAddress) { 
                $ip = $port.PrinterHostAddress 
            }
            if ($port.SNMPEnabled) { 
                $snmpStatus = "Enabled" 
            }
        } catch { $ip = "Lookup Failed" }

        Write-Log "PRINTER : $($p.Name)"
        Write-Log "ADDRESS : $ip"
        Write-Log "SNMP    : $snmpStatus"

        # Connectivity Check
        if ($ip -match "\d{1,3}\.\d{1,3}") {
            Write-Log "Testing connectivity to $ip..."
            if (Test-Connection -ComputerName $ip -Count 1 -Quiet) {
                Write-Log "Network: Hardware is ONLINE." "Green" "[OK]"
            } else {
                Write-Log "Network: Hardware is UNREACHABLE." "Red" "[X]"
            }
        }
        
        # Queue Check
        $jobs = Get-PrintJob -PrinterName $p.Name -ErrorAction SilentlyContinue
        if ($jobs) {
            Write-Log "Queue: $(@($jobs).Count) job(s) waiting." "Yellow" "[!]"
        } else {
            Write-Log "Queue: Empty/Clear." "Green" "[OK]"
        }
    }

    # Finalize Report
    $reportData | Out-File $reportPath -Encoding UTF8
    Write-Section "FINISHED"
    Write-Host "Report saved to: $reportPath" -ForegroundColor Gray
    
    # Auto-open the log
    Invoke-Item $reportPath

} catch {
    Write-Log "Critical Error: $($_.Exception.Message)" "Red" "[ERROR]"
}

Write-Host "`nPress any key to exit..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
