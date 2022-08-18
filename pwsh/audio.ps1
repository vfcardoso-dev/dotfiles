# audio.ps1

$headsetDeviceName = "Headset Logitech"
$hdmiDeviceName = "Monitor AOC LCD"

# Definir interface de saída audio padrão headset
function Invoke-AudioHeadset { nircmd setdefaultsounddevice $headsetDeviceName 1 && nircmd infobox "Audio: $headsetDeviceName" "Info" }

# Definir interface de saída audio padrão monitor
function Invoke-AudioMonitor { nircmd setdefaultsounddevice $hdmiDeviceName 1 && nircmd infobox "Audio: $hdmiDeviceName" "Info" }


function Invoke-GetAllFunctions {
    $aliases = New-Object System.Collections.ArrayList;
    $aliases.AddRange((
        [Tuple]::Create("audio-headset", "Invoke-AudioHeadset", "Define HEADSET como saída de audio padrão"),
        [Tuple]::Create("audio-monitor", "Invoke-AudioMonitor", "Define MONITOR como saída de audio padrão")
    ));
    return $aliases
}

function Invoke-HelpAudio {
    write-host '==============================='
    write-host 'Ajuda - Seção AUDIO:'
    write-host '==============================='

    foreach ($i in Invoke-GetAllFunctions) {
        write-host "- $($i.Item1):   $($i.Item3)"
    }

    write-host ''
}

# registrando aliases
new-alias -name "dothelp-audio" Invoke-HelpAudio

foreach ($i in Invoke-GetAllFunctions) {
    new-alias -name $i.Item1 -value $i.Item2
}