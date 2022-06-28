# drake.ps1

# Rodar Ngrok apontando para Drake local
function Invoke-NgrokDrake { D:\Tools\ngrok\ngrok.exe http http://localhost:2500 -host-header="rewrite" }

# Rodar Ngrok apontando para azure storage local
function Invoke-NgrokStorage { D:\Tools\ngrok\ngrok.exe http https://127.0.0.1:10000 -host-header="rewrite" }

# Clear All: Redis and Messages
function Invoke-ClearAll { kli clear redis && kli clear messages _drake_ Ok }

# Apply patches nos bancos master e testes do drake local
function Invoke-PatchMaster { cmd /c 'kli db patch --% "^drake_(master|testes)$" 1' }

# Apply patches nos bancos master e testes do drake local
function Invoke-PatchRc { cmd /c 'kli db patch --% "rc_drake_" 1' }

# aliases
new-alias -name "ngrok-drake" Invoke-NgrokDrake
new-alias -name "ngrok-storage" Invoke-NgrokStorage
new-alias -name "clear-messages" Invoke-ClearAll
new-alias -name "patchg" Invoke-PatchMaster
new-alias -name "patchrc" Invoke-PatchRc