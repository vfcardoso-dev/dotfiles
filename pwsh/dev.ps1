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

function Invoke-GetAllFunctionsDev {
    $aliases = New-Object System.Collections.ArrayList;
    $aliases.AddRange((
        [Tuple]::Create("guid", "Invoke-GenerateNewGuid", "Gerar N guids aleatórias"),
        [Tuple]::Create("grep", "findstr", "Encontrar strings em fluxos de dados"),
        [Tuple]::Create("droid", "Invoke-AndroidEmulator", "Rodar emulador android")
    ));
    return $aliases
}

function Invoke-HelpDev {
    write-host '==============================='
    write-host 'Ajuda - Seção DEV:'
    write-host '==============================='

    foreach ($i in Invoke-GetAllFunctionsDev) {
        write-host "- $($i.Item1):   $($i.Item3)"
    }

    write-host ''
}

# registrando aliases
new-alias -name "dotfiles-help-dev" Invoke-HelpDev

foreach ($i in Invoke-GetAllFunctionsDev) {
    new-alias -name $i.Item1 -value $i.Item2
}