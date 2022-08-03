# drake.ps1

# Rodar Ngrok apontando para Drake local
function Invoke-NgrokDrake { D:\Tools\ngrok\ngrok.exe http http://localhost:2500 -host-header="rewrite" }

# Rodar Ngrok apontando para azure storage local
function Invoke-NgrokStorage { D:\Tools\ngrok\ngrok.exe http https://127.0.0.1:10000 -host-header="rewrite" }

# Clear All: Redis and Messages
function Invoke-ClearAll { kli clear redis && kli clear messages _drake_ Ok }

# Recuperar nova chave de script
function Invoke-NewDbScript { 
    param([Parameter()][string] $description)
    kli db script $description
}

# Apply patches nos bancos master e testes do drake local (RC)
function Invoke-PatchMaster { cmd /c 'kli db patch --% "^drake_(master|testes)$" 1' }

# Apply patches nos bancos master e testes do drake local
function Invoke-PatchTenants { cmd /c 'kli db patch --% "rc_drake_" 1' }

# Apply patches nos bancos hotfix
function Invoke-PatchHfTenants { cmd /c 'kli db patch --% "^hf_drake_" 2' }

# Apply patches nos bancos master e testes do drake local (HF)
function Invoke-PatchHfMaster { cmd /c 'kli db patch --% "^drake_(master|testes)$" 2' }

# Traduzir com kli
function Invoke-TranslateAdd { 
    param([Parameter()][string] $term, [Parameter()][string] $key)
    kli text translate add $term JS__COMMON__$key 1
}

# Remover tradução com kli
function Invoke-TranslateDel { 
    param([Parameter()][string] $key)
    kli text translate del 1 JS__COMMON__$key
}

function Invoke-SwitchDb {
    param([Parameter()][string] $suffix)

    $suffix = $suffix -eq '' ? 'rc' : $suffix;

    $query = @"
        declare @targetPrefix varchar(2) = '$($suffix)';

        declare @oldPrefix varchar(2) = case when @targetPrefix = 'hf' then 'rc' else 'hf' end;
        declare @oldDrakeMasterName sysname = @oldPrefix + N'_drake_master';
        declare @oldDrakeTestesName sysname = @oldPrefix + N'_drake_testes';
        declare @targetDrakeMasterName sysname = @targetPrefix + N'_drake_master';
        declare @targetDrakeTestesName sysname = @targetPrefix + N'_drake_testes';
        declare @stmt nvarchar(max);

        IF DB_ID('drake_master') IS NOT NULL AND DB_ID(@oldDrakeMasterName) IS NULL
        set @stmt = 'alter database drake_master modify name = ' + quotename(@oldDrakeMasterName);
        exec (@stmt);

        IF DB_ID('drake_testes') IS NOT NULL AND DB_ID(@oldDrakeTestesName) IS NULL
        set @stmt = 'alter database drake_testes modify name = ' + quotename(@oldDrakeTestesName);
        exec (@stmt);

        IF DB_ID(@targetDrakeMasterName) IS NOT NULL
        set @stmt = 'alter database ' + QUOTENAME(@targetDrakeMasterName) + ' modify name = drake_master';
        exec (@stmt);

        IF DB_ID(@targetDrakeTestesName) IS NOT NULL
        set @stmt = 'alter database ' + QUOTENAME(@targetDrakeTestesName) + ' modify name = drake_testes';
        exec (@stmt);
"@

    Import-Module sqlserver

    Invoke-Sqlcmd -ServerInstance "localhost" -Database "master" -Query $query
}

# function Invoke-ListAliases {
#     $aliases = New-Object System.Collections.ArrayList;
#     $aliases.AddRange((
#         [Tuple]::Create(1,"string 1",$function:InvokeClearAll),
#         [Tuple]::Create(2,"string 2",$function:InvokeClearAll),
#         [Tuple]::Create(3,"string 3",$function:Invoke-ClearAll) 
#     ));
#     return $aliases
# }

# foreach ($i in Invoke-ListAliases) {
#     Write-Host $i
# }

# aliases
new-alias -name "ngrok-drake" Invoke-NgrokDrake
new-alias -name "ngrok-storage" Invoke-NgrokStorage
new-alias -name "clearall" Invoke-ClearAll
new-alias -name "patchg" Invoke-PatchMaster
new-alias -name "patcht" Invoke-PatchTenants
new-alias -name "patchhfm" Invoke-PatchHfMaster
new-alias -name "patchhft" Invoke-PatchHfTenants
new-alias -name "translateadd" Invoke-TranslateAdd
new-alias -name "translatedel" Invoke-translateDel
new-alias -name "kscript" Invoke-NewDbScript
new-alias -name "switchdb" Invoke-SwitchDb