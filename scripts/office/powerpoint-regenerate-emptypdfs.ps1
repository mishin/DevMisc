param (
    [string] $targetDirectory = "Z:\Marketing\Clients\Gulf States Toyota\February 2013"
)

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

while ($true)
{
    $zeroBytePdfs = dir -r $targetDirectory -fi *.pdf | ?{ $_.Length -eq 0 }
    if (-not $zeroBytePdfs) { return; }

    $pptxPaths = $zeroBytePdfs | %{ [io.path]::ChangeExtension($_.FullName, '.pptx') }

    & "$scriptPath\powerpoint-regenerate-pdf.ps1" $pptxPaths
}
