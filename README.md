# 🖥️ VM AutoScaler – CPU-Based Virtual Machine Control using PowerShell

This project remotely monitors CPU usage of one VM (Ubuntu-1) and automatically starts/stops another VM (Ubuntu-2) depending on the load threshold.

---

## 📌 Features

- ✅ SSH-based CPU monitoring of Ubuntu VM
- ⚙️ Threshold-based VM control (start/stop) using VBoxManage
- 🧾 Logging with timestamps to track actions
- 🧪 Simulate load using `stress` tool
- 🔁 Compatible with Windows Task Scheduler for periodic execution

---

## 🛠️ Requirements

- **VirtualBox** installed with VBoxManage in `PATH`  
- **OpenSSH** client on Windows (optional: `ssh-copy-id` in Ubuntu)
- **Ubuntu VMs** with SSH enabled and reachable via Host-Only network
- PowerShell v5 or above (tested on Windows 10/11)

---

## 🚦 VM Network Setup (Host-Only)

- **Adapter 1 (Ubuntu-1 & Ubuntu-2)**: NAT (for internet access)
- **Adapter 2**: Host-Only Adapter (e.g., `192.168.56.x` series)

Verify IP via:
bash
ip a

```
📜 Script Overview
autoscale_master.ps1
Main script to monitor CPU and scale second VM

autoscale_log.txt
Timestamped log of actions taken
```
```
📊 Logic Flow
[Host (PowerShell)] 
     |
     | SSH
     v
[Ubuntu-1: CPU Load Check]
     |
     | Load > 50% → Start Ubuntu-2
     | Load < 30% → Stop Ubuntu-2
     v
[VBoxManage Actions]
```
🧪 Simulate High CPU Load
Run this inside Ubuntu-1:
```
sudo apt install stress
stress --cpu 4 --timeout 60
```
🔁 Setup Auto Run (Task Scheduler)
Open Task Scheduler → Create Task

Trigger: On schedule (e.g., every 5 mins)

Action:
powershell.exe -ExecutionPolicy Bypass -File "C:\VMScaler\autoscale_master.ps1"
Save & Enable
```
📁 Folder Structure
VMScaler/
│
├── autoscale_master.ps1
├── autoscale_log.txt
└── README.md
```
