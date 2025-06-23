# === CONFIGURATION ===
$vm2 = "Ubuntu-2"
$sshUser = "deepayan"
$sshIP = "192.168.56.101"
$logEnabled = $true
$logPath = "C:\VMScaler\autoscale_log.txt"
$vboxManage = "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"

# === GET CPU LOAD FROM VM1 ===
$cpuLine = ssh "$sshUser@$sshIP" "top -bn1 | grep 'Cpu(s)'" 2>&1
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# === PARSE CPU LOAD ===
if ($cpuLine -match "Cpu\(s\):\s+(\d+\.\d+)\s+us,\s+(\d+\.\d+)\s+sy") {
    $user = [double]$matches[1]
    $system = [double]$matches[2]
    $cpuLoad = $user + $system
} else {
    $msg = "$timestamp - ERROR - Could not parse CPU load. Output: $cpuLine"
    Write-Host $msg -ForegroundColor Red
    if ($logEnabled) { Add-Content -Path $logPath -Value $msg }
    exit 1
}

# === SCALING LOGIC ===
if ($cpuLoad -gt 50) {
    try {
        & "$vboxManage" startvm "$vm2" --type headless
        $msg = "$timestamp - High CPU load detected ($cpuLoad%). Attempted to start $vm2."
    } catch {
        $msg = "$timestamp - ERROR starting $vm2 : $($_.Exception.Message)"
    }
}
elseif ($cpuLoad -lt 30) {
    try {
        & "$vboxManage" controlvm "$vm2" acpipowerbutton
        $msg = "$timestamp - Low CPU load detected ($cpuLoad%). Attempted to stop $vm2."
    } catch {
        $msg = "$timestamp - ERROR stopping $vm2 : $($_.Exception.Message)"
    }
}
else {
    $msg = "$timestamp - CPU load normal ($cpuLoad%). No action taken."
}

# === LOG OUTPUT ===
Write-Host $msg -ForegroundColor Cyan
if ($logEnabled) { Add-Content -Path $logPath -Value $msg }
