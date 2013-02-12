param (
    [string[]] $pptxPaths = $(throw 'must specify paths to powerpoint files')
)

Set-StrictMode -Version Latest

Add-type -AssemblyName office
$application = New-Object -ComObject powerpoint.application
#$application.visible = [Microsoft.Office.Core.MsoTriState]::msoTrue

foreach ($pptxPath in $pptxPaths)
{
    $pdfPath = [System.IO.Path]::ChangeExtension($pptxPath, '.pdf')

    Write-Debug "Opening $pptxPath"
    # http://msdn.microsoft.com/en-us/library/office/microsoft.office.interop.powerpoint.presentations.open(v=office.14).aspx
    $presentation = $application.Presentations.open(
        $pptxPath, 
        [Microsoft.Office.Core.MsoTriState]::msoTrue,     # readonly   == true
        [Microsoft.Office.Core.MsoTriState]::msoFalse,    # untitled   == false
        [Microsoft.Office.Core.MsoTriState]::msoFalse)    # WithWindow == false
    Write-Debug "Saving $pdfPath"
    $presentation.SaveCopyAs($pdfPath, [Microsoft.Office.Interop.PowerPoint.PpSaveAsFileType]::ppSaveAsPDF);

    Write-Debug "Closing $pptxPath"
    $presentation.Close()
}

$application.Quit()

# likely not needed, but keeping in case it helps the RCW/COM clean up
[gc]::collect()
[gc]::WaitForPendingFinalizers()