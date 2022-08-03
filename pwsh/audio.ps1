# audio.ps1

$headsetDeviceName = "Headset Logitech"
$hdmiDeviceName = "Monitor AOC LCD"

# Definir interface de saída audio padrão headset
function Invoke-AudioHeadset { nircmd setdefaultsounddevice $headsetDeviceName 1 && nircmd infobox "Audio: $headsetDeviceName" "Info" }

# Definir interface de saída audio padrão monitor
function Invoke-AudioMonitor { nircmd setdefaultsounddevice $hdmiDeviceName 1 && nircmd infobox "Audio: $hdmiDeviceName" "Info" }

# aliases
new-alias -name "audio-headset" Invoke-AudioHeadset
new-alias -name "audio-monitor" Invoke-AudioMonitor