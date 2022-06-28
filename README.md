# My dotfiles

```powershell
get-childitem 'C:\Coding\Studying\dotfiles\pwsh' | foreach-object { 
  . $_.FullName 
}
```