# dev.ps1

# Gerar N Guids
function Invoke-GenerateNewGuid { 
  param([Parameter()][int] $count)

  $count = $count -eq 0 ? 1 : $count;

  for($i=0; $i -lt $count; $i++) {
    [guid]::NewGuid().ToString() 
  }
}

# Rodar emulador android
function Invoke-AndroidEmulator { 
  param([Parameter()][string] $avdName)
  
  if ($avdName) {
    . $env:ANDROID_SDK_ROOT\emulator\emulator.exe -avd $avdName 
  } else {
    echo "Escolha um AVD da lista e rode o comando novamente: droid NOME_DO_AVD"
    . $env:ANDROID_SDK_ROOT\emulator\emulator.exe -list-avds
  }
}

# Previsão do Tempo
function Invoke-WttrIn { Invoke-RestMethod http://wttr.in }

new-alias -name "guid" -value Invoke-GenerateNewGuid
new-alias -name "grep" -value findstr
new-alias -name "droid" -value Invoke-AndroidEmulator