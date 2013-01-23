New-PSDrive -Name HKCR -PSProvider Registry -Root HKEY_CLASSES_ROOT
 
new-item -path HKCR:directory/shell/powershell
new-item -path HKCR:directory/shell/powershell/command
set-item -path HKCR:directory/shell/powershell -value "Open PowerShell Here"
set-item -path HKCR:directory/shell/powershell/command -value "C:\Windows\system32\WindowsPowerShell\v1.0\powershell.exe -NoExit -Command Set-Location -LiteralPath '%L'"