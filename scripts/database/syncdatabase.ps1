param (
	$databaseName = 'ClientDb'
	$sourceServerName = '3bs001cmedev'
	$targetServerName = 'localhost'
)

# make sure the required SMO assemblies are loaded
$null = [reflection.assembly]::loadwithpartialname('Microsoft.SqlServer.Smo')
$null = [reflection.assembly]::loadwithpartialname('Microsoft.SqlServer.SmoExtended')

$sourceServer = New-Object Microsoft.SqlServer.Management.SMO.Server $sourceServerName
$sourceDatabase = $sourceServer.Databases[$databaseName]

#Define a Transfer object and set the required options and properties.
$xfr = New-Object Microsoft.SqlServer.Management.SMO.Transfer $sourceDatabase

#Set this objects properties
$xfr.CopyAllObjects = $false
$xfr.CopyAllTables = $true
$xfr.CopySchema = $true
$xfr.CopyData = $true

$xfr.DestinationDatabase = $databaseName
$xfr.DestinationServer = $targetServerName
$xfr.DestinationLoginSecure = $true

$xfr.Options.WithDependencies = $true
$xfr.Options.ContinueScriptingOnError = $true
write-host "Transferring data"
$xfr.TransferData()

# script-target version
$xfr.Options.FileName = join-path $env:temp 'transfer.sql'
$xfr.Options.ToFileOnly = $true
write-host "Writing script version to $($xfr.Options.FileName)"
$xfr.ScriptTransfer()

