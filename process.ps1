# Change this to the directory where you want to save the logs
$baseDirectory = "logs"
# Define the interval in seconds
$interval = 1  # Adjust as needed

# creating base dir if not exists
if (-not (Test-Path $baseDirectory)) {
    New-Item -ItemType Directory -Path $baseDirectory | Out-Null
}

# loop to continuously monitor network interfaces
while ($true) {
    
    # getting stats
    $newStats = Get-Counter "\Network Interface(*)\Bytes Sent/sec", "\Network Interface(*)\Bytes Received/sec"

    # current timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

    # Process each network interface (half of them is send and rest is receive)
    for ($i = 0; $i -lt ($newStats.CounterSamples.Count/2); $i++) {
        
        $interface = $newStats.CounterSamples[$i].InstanceName
        $sanitizedInterface = $interface -replace "[^a-zA-Z0-9]", "_"  # remove special characters for file naming
        $csvFile = "$baseDirectory\$sanitizedInterface.csv"

        # check if the file exists; if not, create it with headers
        if (-not (Test-Path $csvFile)) {
            "Timestamp,Sent_Mbps,Received_Mbps,Total_Mbps" | Out-File -FilePath $csvFile -Encoding utf8
        }

        # actual values
        $sentBps = $newStats.CounterSamples[$i].CookedValue
        $recvBps = $newStats.CounterSamples[$i + ($newStats.CounterSamples.Count / 2)].CookedValue

        # all to Mbps
        $sentMbps = [math]::Round(($sentBps * 8) / 1MB, 2)
        $recvMbps = [math]::Round(($recvBps * 8) / 1MB, 2)
        $totalMbps = [math]::Round($sentMbps + $recvMbps, 2)

        $sanitized_timestamp = $timestamp -replace ",", "_"

        # save to file
        "$sanitized_timestamp,$sentMbps,$recvMbps,$totalMbps" | Out-File -Append -FilePath $csvFile -Encoding utf8
    }

    Start-Sleep -Seconds $interval
}
