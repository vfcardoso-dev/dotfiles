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

# aliases
new-alias toilet Invoke-Toilet
new-alias coffee Invoke-Coffee