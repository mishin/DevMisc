Import-Module PsGet
Import-Module Pscx -arg  @{PromptTheme = 'James'; ModulesToImport = @{Prompt = $true}}

$env:path += ";$home\Documents\bin"
