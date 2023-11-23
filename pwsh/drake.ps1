# drake.ps1

# Rodar Ngrok apontando para Drake local
function Invoke-NgrokDrake { D:\Tools\ngrok\ngrok.exe http http://localhost:2500 --host-header="rewrite" }

# Rodar Ngrok apontando para azure storage local
function Invoke-NgrokStorage { D:\Tools\ngrok\ngrok.exe http "https://127.0.0.1:10000" --host-header="rewrite" }

# Rodar Ngrok usando arquivo de configuração em %USERPROFILE%/.ngrok2/ngrok.yml
function Invoke-NgrokStartAll { D:\Tools\ngrok\ngrok.exe start --all }

# Clear All: Redis and Messages
function Invoke-ClearAll { kli clear redis && kli clear messages _drake_ Ok }

# Recuperar nova chave de script
function Invoke-NewDbScript { 
    param([Parameter(Mandatory=$true)][string] $description)
    kli db script $description
}

# Apply patches nos bancos master e associados do drake local (RC)
function Invoke-PatchMaster { cmd /c 'kli db patch drake_master 1' }

# Apply patches nos bancos master e associados do drake local (HF)
function Invoke-PatchHfMaster { cmd /c 'kli db patch drake_master 2' }

# Apply patches nos bancos testes do drake local (RC)
function Invoke-PatchTest { cmd /c 'kli db patch drake_testes 1' }

# Apply patches nos bancos testes do drake local (HF)
function Invoke-PatchHfTest { cmd /c 'kli db patch drake_testes 2' }

# Traduzir com kli
function Invoke-TranslateAdd { 
    param(
        [Parameter(Mandatory=$true)][string] $term, 
        [Parameter(Mandatory=$true)][string] $key, 
        [Parameter(Mandatory=$true)][int] $instance=1,
        [Parameter(Mandatory=$false)][string] $preffix = 'JS__COMMON__')

    kli text translate add $term $preffix$key $instance
}

# Remover tradução com kli
function Invoke-TranslateDel { 
    param([Parameter(Mandatory=$true)][string] $key, [Parameter(Mandatory=$true)][int] $instance=1)
    kli text translate del $instance $key
}

# Alternar entre bancos master RC e HF
function Invoke-SwitchDb {
    param([Parameter(Mandatory=$true)][string] $suffix)

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

    write-host "Bancos master e testes definidos para o ambiente '$($suffix)'";
}

function Invoke-ClearMobileRoot() {
    rm -force -recurse node_modules && rm -force -recurse platforms && rm -force -recurse plugins && rm -force -recurse www
}

function Invoke-GetAllFunctionsDrake {
    $aliases = New-Object System.Collections.ArrayList;
    $aliases.AddRange((
        [Tuple]::Create("ngrok-drake", "Invoke-NgrokDrake", "Rodar Ngrok apontando para Drake local"),
        [Tuple]::Create("ngrok-storage", "Invoke-NgrokStorage", "Rodar Ngrok apontando para azure storage local"),
        [Tuple]::Create("ngrok-all", "Invoke-NgrokStartAll", "Rodar Ngrok usando arquivo de configuração"),
        [Tuple]::Create("clearall", "Invoke-ClearAll", "Clear all redis items and core.messages registers"),
        [Tuple]::Create("patchrc", "Invoke-PatchMaster", "Apply patches no banco master e associados do drake local (RC)"),
        [Tuple]::Create("patchhf", "Invoke-PatchHfMaster", "Apply patches no banco master e associados do drake local (HF)"),
        [Tuple]::Create("patchtestrc", "Invoke-PatchTest", "Apply patches no banco testes do drake local (RC)"),
        [Tuple]::Create("patchtesthf", "Invoke-PatchHfTest", "Apply patches no banco testes do drake local (HF)"),
        [Tuple]::Create("translateadd", "Invoke-TranslateAdd", "Traduzir com kli"),
        [Tuple]::Create("translatedel", "Invoke-translateDel", "Remover tradução com kli"),
        [Tuple]::Create("kscript", "Invoke-NewDbScript", "Recuperar nova chave de script"),
        [Tuple]::Create("switchdb", "Invoke-SwitchDb", "Alternar entre bancos master RC e HF"),
        [Tuple]::Create("clearmobile", "Invoke-ClearMobileRoot", "Limpa as pastas de dependências e código auto-gerado do ionic")
    ));
    return $aliases
}

function Invoke-HelpDrake {
    write-host '==============================='
    write-host 'Ajuda - Seção DRAKE:'
    write-host '==============================='

    foreach ($i in Invoke-GetAllFunctionsDrake) {
        write-host "- $($i.Item1):   $($i.Item3)"
    }

    write-host ''
}

# registrando aliases
new-alias -name "dotfiles-help-drake" Invoke-HelpDrake

foreach ($i in Invoke-GetAllFunctionsDrake) {
    new-alias -name $i.Item1 -value $i.Item2
}