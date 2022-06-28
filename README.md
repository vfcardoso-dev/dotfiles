# My dotfiles


```powershell
# How to import on pwsh

get-childitem 'c:\path\to\dotfiles\pwsh' | foreach-object { 
  . $_.fullname 
}
```