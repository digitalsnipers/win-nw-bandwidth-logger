# Windows Network Bandwidth Logger

A PowerShell-based bandwidth monitoring script that logs per-interface network utilization (Sent, Received, and Total bandwidth) in **Mbps** on Windows systems.

## 📌 Features

- Logs bandwidth usage of all network interfaces
- Stores logs in **CSV format**
- Creates **separate log files per interface**
- Measures bandwidth in **Mbps** with accurate delta calculations
- Handles counter resets and ensures stable performance over time


Each `.csv` file contains:
Timestamp,Sent_Mbps,Received_Mbps,Total_Mbps


## ⚙️ How It Works

- Uses `Get-Counter` to measure `Bytes Sent/sec` and `Bytes Received/sec` for all interfaces.
- Samples at **1-second intervals** and calculates Mbps values.
- Rounds values to **2 decimal places** for clean CSV logs.
- Automatically creates daily folders and log files per interface.
- Sanitizes interface names to create valid filenames (e.g., `Wi-Fi` → `Wi_Fi.csv`).

## ▶️ Running the Script

1. Save the script as `process.ps1`.
2. Open PowerShell **as Administrator**.
3. Change baseDirectory in script as your desired location to save logs
4. Run:

```powershell
.\process.ps1
```
⚠️ This will run indefinitely in a loop. Use Ctrl + C to stop.



