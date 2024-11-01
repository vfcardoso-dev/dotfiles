# dev.ps1

# Gerar N Guids
function Invoke-GenerateNewGuid { 
  param([Parameter()][int] $count)

  $count = $count -eq 0 ? 1 : $count;

  for($i=0; $i -lt $count; $i++) {
    [guid]::NewGuid().ToString() 
  }
}

function Invoke-RemoveCsprojDuplicates {
  Param(
    [string]$filePath = $(throw "You must supply a file path")
  )

  $filePath = Resolve-Path $filePath

  "> Searching for project files in $filePath"

  $projectFiles = Get-ChildItem -Path $filePath -Include *.csproj -Recurse -Attributes !reparsepoint `
  | Where-Object { $_.FullName -notmatch "\\packages\\?" } `
  | Select-Object -ExpandProperty FullName
  
  "> Found $($projectFiles.Count) project files"
  
  Foreach($projectFile in $projectFiles) {
      $xml = [xml] (Get-Content $projectFile)
      
      Write-Host "> $projectFile " -Foreground Green

      $entries = $xml.Project.ItemGroup.Compile + $xml.Project.ItemGroup.Content + $xml.Project.ItemGroup.Folder | Group-Object Include
      $duplicateEntries = $entries | Where-Object Count -gt 1

      "- Found $($duplicateEntries.Count) duplicate entries"

      if (!$duplicateEntries) {
          continue
      }
      
      foreach ($duplicateEntry in $duplicateEntries) {
          While ($duplicateEntry.Group.Count -gt 1) {
              $e = $duplicateEntry.Group[0]
              $e.ParentNode.RemoveChild($e) | Out-Null
              $duplicateEntry.Group.Remove($e) | Out-Null
          }
      }

      $xml.Save($projectFile) | Out-Null

      "- Removed $($duplicateEntries.Count) duplicate entries"
  }
}

# Histórico do powershell
function Invoke-CheckServiceStatus {
  param([Parameter(Mandatory=$true)][string] $url)
  
  curl -s -o /dev/null -w "$url %{http_code}" $url; write-output `r
}

# Histórico do powershell
function Invoke-PowershellHistory {
  param([Parameter(Mandatory=$true)][string] $search)
  
  Get-Content (Get-PSReadlineOption).HistorySavePath | where-object { $_ -like "*$($search)*" }
}

# Rodar emulador android
function Invoke-AndroidEmulator { 
  param([Parameter()][string] $avdName)
  
  if ($avdName) {
    . $env:ANDROID_SDK_ROOT\emulator\emulator.exe -avd $avdName 
  } else {
    write-output "Escolha um AVD da lista e rode o comando novamente: droid NOME_DO_AVD"
    . $env:ANDROID_SDK_ROOT\emulator\emulator.exe -list-avds
  }
}

# Gerar cpfs aleatórios
function GenerateRandomChunk {
  return (Get-Random -Minimum 0 -Maximum 999).ToString('000');
}

function CalculateCheckDigit {
  param(
    [Parameter(Mandatory=$true)][string] $chunk1,
    [Parameter(Mandatory=$true)][string] $chunk2,
    [Parameter(Mandatory=$true)][string] $chunk3,
    [Parameter()][string] $vd1
  )
  
  $chunk4 = !$vd1 ? "" : $vd1;
  [int[]]$numbers = "$chunk1$chunk2$chunk3$chunk4".ToCharArray() | foreach-object {invoke-expression $_};

  $sum = 0;
  $index = 0;
  $start = !$vd1 ? 10 : 11;

  for ($num = $start; $num -ge 2; $num--) {
    $sum += [int]::parse($numbers[$index]) * $num;
    $index++;
  }

  $remainder = $sum % 11;
  return $remainder -lt 2 ? 0 : 11 - $remainder;
}

function GenerateCpf {
  $chunk1 = GenerateRandomChunk;
  $chunk2 = GenerateRandomChunk;
  $chunk3 = GenerateRandomChunk;
  $vd1 = CalculateCheckDigit $chunk1 $chunk2 $chunk3;
  $vd2 = CalculateCheckDigit $chunk1 $chunk2 $chunk3 $vd1;

  write-host "$chunk1.$chunk2.$chunk3-$vd1$vd2"
}

function Invoke-CreateCpf {
  param([Parameter()][int] $count)

  $count = $count -eq 0 ? 1 : $count;

  for($i=0; $i -lt $count; $i++) {
    GenerateCpf
  }
}

function Invoke-Where {
  param([Parameter()][string] $executable)

  (get-command $executable).Path
}

function Invoke-GetAllFunctionsDev {
    $aliases = New-Object System.Collections.ArrayList;
    $aliases.AddRange((
        [Tuple]::Create("guid", "Invoke-GenerateNewGuid", "Gerar N guids aleatórias"),
        [Tuple]::Create("grep", "findstr", "Encontrar strings em fluxos de dados"),
        [Tuple]::Create("droid", "Invoke-AndroidEmulator", "Rodar emulador android"),
        [Tuple]::Create("shistory", "Invoke-PowershellHistory", "Histórico de comandos do powershell"),
        [Tuple]::Create("cpf", "Invoke-CreateCpf", "Cria N CPFs aleatórios válidos"),
        [Tuple]::Create("svcstat", "Invoke-CheckServiceStatus", "Checa status de serviço online"),
        [Tuple]::Create("rmdupcsproj", "Invoke-RemoveCsprojDuplicates", "Remove referências duplicadas no arquivo csproj"),
        [Tuple]::Create("whereis", "Invoke-Where", "Semelhante ao comando 'where' do bash")
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