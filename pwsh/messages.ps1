# messages.ps1

function Invoke-Toilet {
    Write-Host @"
  _____
  |   D
  |   |
  |   |
  \___|            _
    ||  _______  -( (-
    |_'(-------)  '-'
       |       /
_____,-\__..__|_____
     
     Já volto!
"@
}

function Invoke-Coffee {
    Write-Host @"
   ( (
    ) )
  ........
  |      |]
  \      /    Já volto! 
    `----'
"@
}



function Invoke-GetAllFunctions {
    $aliases = New-Object System.Collections.ArrayList;
    $aliases.AddRange((
        [Tuple]::Create("toilet", "Invoke-Toilet", "Exibe mensagem 'Volto Logo' com toilet"),
        [Tuple]::Create("coffee", "Invoke-Coffee", "Exibe mensagem 'Volto Logo' com xícara de café")
    ));
    return $aliases
}

function Invoke-HelpMessages {
    write-host '==============================='
    write-host 'Ajuda - Seção MESSAGES:'
    write-host '==============================='

    foreach ($i in Invoke-GetAllFunctions) {
        write-host "- $($i.Item1):   $($i.Item3)"
    }

    write-host ''
}

# registrando aliases
new-alias -name "dothelp-messages" Invoke-HelpMessages

foreach ($i in Invoke-GetAllFunctions) {
    new-alias -name $i.Item1 -value $i.Item2
}