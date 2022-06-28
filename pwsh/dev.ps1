# dev.ps1

# Gerar N Guids
function Invoke-GenerateNewGuid { 
  param([Parameter()][int] $count)

  $count = $count -eq 0 ? 1 : $count;

  for($i=0; $i -lt $count; $i++) {
    [guid]::NewGuid().ToString() 
  }
}

# Previsão do Tempo
function Invoke-WttrIn { Invoke-RestMethod http://wttr.in }

new-alias -name "guid" -value Invoke-GenerateNewGuid
new-alias -name "grep" -value findstr