param (
    $sourceDir = $(Split-Path -Path $MyInvocation.MyCommand.Definition -Parent),
    $targetDirPattern = "~/Documents/Visual Studio */Code Snippets/Visual C#/My Code Snippets",
    $pattern = "*.snippet"
)

$targetDirs = dir $targetDirPattern
foreach ($targetDir in $targetDirs)
{
    copy-item -force -verbose $sourceDir\$pattern $targetDir
}
