# external.ps1

# Previsão do Tempo
function Invoke-WttrIn { Invoke-RestMethod http://wttr.in }

# A new hope
function Invoke-ANewHope { telnet towel.blinkenlights.nl }


function Invoke-GetAllFunctionsExternal {
    $aliases = New-Object System.Collections.ArrayList;
    $aliases.AddRange((
        [Tuple]::Create("weather", "Invoke-WttrIn", "Previsão do Tempo"),
        [Tuple]::Create("anewhope", "Invoke-ANewHope", "A new hope")
    ));
    return $aliases
}

function Invoke-HelpExternal {
    write-host '==============================='
    write-host 'Ajuda - Seção EXTERNAL:'
    write-host '==============================='

    foreach ($i in Invoke-GetAllFunctionsExternal) {
        write-host "- $($i.Item1):   $($i.Item3)"
    }

    write-host ''
}

# registrando aliases
new-alias -name "dotfiles-help-external" Invoke-HelpExternal

foreach ($i in Invoke-GetAllFunctionsExternal) {
    new-alias -name $i.Item1 -value $i.Item2
}