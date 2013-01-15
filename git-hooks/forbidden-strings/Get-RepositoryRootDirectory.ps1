# attempts to figure out the root directory for the 'current' 
# git repository by checking up the parent chain of directories

param (
)

Set-StrictMode -Version Latest

# uncomment this line to help debug the operation of this script
#$DebugPreference = 'Continue'

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition

$directoryToCheck = (pwd).Path

Write-Debug "Starting checks with $directoryToCheck"
while ($directoryToCheck -ne $null)
{
    $potentialGitHooksPath = Join-Path $directoryToCheck '.git/hooks'
    if (Test-Path -PathType Container $potentialGitHooksPath)
    {
        Write-Debug "Found existing .git/hooks directory at $potentialGitHooksPath, returning $directoryToCheck as repository root"
        return $directoryToCheck
    }
    $directoryToCheck = [System.IO.Path]::GetDirectoryName($directoryToCheck)
    Write-Debug "Doing next check on $directoryToCheck"
}
