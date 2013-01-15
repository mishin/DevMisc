param (
    $repositoryRootDirectory = $null
)

$filePatternsToCopy = @(
    'pre-commit*'
)

Set-StrictMode -Version Latest

# uncomment this line to help debug the operation of this script
#$DebugPreference = 'Continue'

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
$env:Path += ";$scriptPath"

if ($repositoryRootDirectory -eq $null)
{
    $repositoryRootDirectory = Get-RepositoryRootDirectory
}

if ($repositoryRootDirectory -eq $null)
{
    throw 'need to run this script from inside a git repository OR pass the root directory of the repository to the script'
}

if (-not (Test-Path -PathType Container $repositoryRootDirectory))
{
    throw "specified repository root directory $repositoryRootDirectory does not exist"
}

$gitHooksDirectory = Join-Path $repositoryRootDirectory '.git/hooks'
if (-not (Test-Path -PathType Container $gitHooksDirectory))
{
    throw "Could not find repository git hooks directory $gitHooksDirectory"
}

Copy-Item -Path $scriptPath\* -Include $filePatternsToCopy -Destination $gitHooksDirectory -Verbose