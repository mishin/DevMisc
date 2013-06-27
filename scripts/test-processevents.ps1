$processStartInfo = New-Object Diagnostics.ProcessStartInfo
$processStartInfo.FileName = "C:\WINDOWS\system32\ping.exe"
$processStartInfo.Arguments = "localhost"
$processStartInfo.CreateNoWindow = $true
$processStartInfo.RedirectStandardOutput = $true
$processStartInfo.RedirectStandardError = $false
$processStartInfo.UseShellExecute = $false

$process = New-Object Diagnostics.Process
$process.StartInfo = $processStartInfo

$global:processOutputLines = @()
$global:position = $Host.UI.RawUI.CursorPosition

Register-ObjectEvent -InputObject $process -EventName OutputDataReceived -action {
    #"Lines in bucket before: $($global:processOutputLines.Length)" | out-host
    $global:processOutputLines += $EventArgs.data
    #"Lines in bucket after: $($global:processOutputLines.Length)" | out-host
    #"Got stdout message of: $($EventArgs.data)" | out-host
} | Out-Null
Register-ObjectEvent -InputObject $process -EventName Exited -action {
    #"Complete set of output: $global:processOutputLines" | out-host
    #"Second line of output: $($global:processOutputLines[1])" | out-host

    $bufferCells = $Host.UI.RawUI.NewBufferCellArray($global:processOutputLines[1], 'red', 'black')

    $Host.UI.RawUI.SetBufferContents($global:position, $bufferCells)

    #"EXIT." | out-host 
} | Out-Null

$process.Start() | Out-Null
$process.BeginOutputReadLine()