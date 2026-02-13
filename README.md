# Network Printer Diagnostic Tool (printerdiag)

Developed by Matthew Deiter (matthewdeiter.com)
GitHub Repository: https://github.com/mjdeiter/printerdiag/

---

## Overview
The Network Printer Diagnostic Tool is a lightweight PowerShell script designed to automate the initial troubleshooting steps for local and network printers. Instead of manually checking services and pinging IP addresses, this tool aggregates vital printer health data into a single console view and an automated text report.

## Key Features
* Print Spooler Check: Verifies if the local Windows Print Spooler service is running.
* IP Extraction: Automatically pulls the PrinterHostAddress from the printer port configuration.
* Connectivity Testing: Performs a network ping to confirm the hardware is reachable.
* SNMP Status: Identifies if SNMP is enabled for the specific printer port.
* Queue Monitoring: Counts pending print jobs that might be blocking the queue.
* Dual Logging: Outputs results to the PowerShell console and saves a detailed .txt report to your desktop.
* Auto-Report: Automatically opens the generated report upon completion.

---

## How To Use

### Prerequisites
* Operating System: Windows 10/11 or Windows Server.
* Permissions: You may need to run PowerShell as an Administrator to access certain printer port details and service statuses.

### Execution
1. Download the printerdiag.ps1 file.
2. Open PowerShell and navigate to the directory containing the script.
3. Run for all printers:
   .\printerdiag.ps1
4. Run for a specific printer:
   .\printerdiag.ps1 -PrinterName "Your-Printer-Name"

---

## Sample Output
The script generates a report on your desktop named Printer_Diag_Results.txt. It follows this structure:

[OK] Spooler service is active.  
ANALYZING: HP-OfficeJet-Pro-8710  
ADDRESS: 192.168.1.50  
[OK] Network: Hardware is ONLINE.  
[!] Queue: 2 job(s) waiting.

---

## Version History

| Version | Description |
| :--- | :--- |
| 1.0 | Initial release. |
| 1.1 | Added IP extraction and dual-logging (Console + File). |
| 1.2 | Added SNMP capability check and version tracking. |
| 1.2.1 | Fixed parameter block position error for better stability. |

---

## License
This project is open-source. Feel free to fork, modify, and use it in your own environments. If you find it helpful, a link back to matthewdeiter.com is always appreciated.
