# external.ps1

# Previsão do Tempo
function Invoke-WttrIn { Invoke-RestMethod http://wttr.in }

# aliases
new-alias -name "wttr" -value Invoke-WttrIn