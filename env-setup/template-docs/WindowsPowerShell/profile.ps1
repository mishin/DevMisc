# since we want to use a common profile location instead of a shell-specific one, redefine $profile to point to the common one

#"Profile started as $profile"
$profile = $MyInvocation.MyCommand.Definition
#"Profile changed to $profile"


$env:path += ";." # yeah, i'm ok with current dir in my path

$env:path += ";${env:ProgramFiles(x86)}\Microsoft Visual Studio 11.0\Common7\IDE"
#$env:path += ";${env:ProgramFiles(x86)}\Microsoft Visual Studio 10.0\Common7\IDE"
$env:path += ";${env:ProgramFiles(x86)}\KDiff3"


# not sure if we should ever use these first 3
#$env:path += ";${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v7.0A\Bin"
#$env:path += ";${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v7.0A\Bin\x64"
#$env:path += ";${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v7.0A\Bin\NETFX 4.0 Tools"
#$env:path += ";${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v7.0A\Bin\NETFX 4.0 Tools\x64"

$env:path += ";${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v8.0A\Bin\NETFX 4.0 Tools\x64"
$env:path += ";${env:ProgramFiles(x86)}\Microsoft SDKs\Windows\v8.0A\Bin\NETFX 4.0 Tools"

$env:path += ";$env:windir\Microsoft.NET\Framework64\v4.0.30319"

set-alias msbuild32 C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe
set-alias msbuild64 C:\Windows\Microsoft.NET\Framework64\v4.0.30319\msbuild.exe

$docs = [environment]::GetFolderPath('mydocuments')
$env:path += ";$docs\bin"

# include subdirs of docs bin
dir -r $docs\bin |
    ?{ $_.PsIsContainer } |
    %{ $_.FullName } |
    %{ $env:path += ";$_" }
# include ruby if it's installed
dir C:\Ruby19?\bin |
    %{ $env:path += ";$_" }

function don  { $global:DebugPreference = 'Continue' }
function doff { $global:DebugPreference = 'SilentlyContinue' }

function first-not-empty([string[]] $strings)
{
    $strings |
        ?{ [string]::IsNullOrEmpty($_) -eq $false } |
        select -first 1
}

function Get-ProgramFilesPath([string] $relativePath)
{
	$checkPath = "${env:ProgramFiles(x86)}\$relativePath"
	if (test-path -type leaf $checkPath) { return $checkPath }

	$checkPath = "$env:ProgramFiles\$relativePath"
	if (test-path -type leaf $checkPath) { return $checkPath }
	
	throw "could not find a ProgramFiles path for $relativePath"
}

function edit-files([string[]] $paths)
{
    foreach ($path in $paths)
    {
        write-debug "Invoking editor on file $path"
		$editor = Get-ProgramFilesPath("Notepad++\notepad++.exe")
        & $editor $path
    }
}

function expand-wildcards([string] $path)
{
    if (test-path $path)
    {
        dir $path
    }
    else
    {
        $path
    }
}

function dm { cd 'C:\github\DevMisc' }
function gco { git checkout $args }
function gs { git status $args }
function gd { git diff $args }

function n
{
    $files = @($args) + @($input)
    $inputPaths = $files | 
        %{ first-not-empty $_.path, $_.fullname, $_ } |
        %{ expand-wildcards $_ }
        #?{ test-path -pathtype leaf $_ }
    edit-files $inputPaths
}

filter p { $_.$args }
filter f { $_.fullname }
function oc { $input | out-clipboard -width 9999 }
function foc { $input | f | oc }
function hosts { n $env:windir\system32\drivers\etc\hosts }
function pe { n $profile }
new-alias -force ss select-string
filter ss { $_ | select-string $args }
filter ssl { $_ | select-string -list $args | p path }

$binaryExtensions = '.exe', '.dll', '.pdb', '.png', '.mdf', '.docx', '.dat', '.cache', '.original'
filter sst { $_ | ?{ $binaryExtensions -notcontains $_.Extension } | select-string $args }

$sourceDir = "$docs\GitHub"
function s { cd $sourceDir }
if (($pwd.Path -eq $home) -and (test-path -pathtype container $sourceDir))
{
    cd $sourceDir
}

function diff-allprojects
{
    $projectsInSln = cat AllProjects.sln |
        %{ if ($_ -match 'Project\("{(?<sln_guid>.*)}"\) = "(?<project_name>.*)", "(?<project_path>.*)", "{(?<project_guid>.*)}"') { $matches['project_path'] } } |
        sort
    $projectsInFilesystem = dir -r -fi *.csproj | 
        %{ $_.fullname.Replace("$(pwd)\", "") } |
        sort
    compare-object $projectsInSln $projectsInFilesystem
}

function pon
{
    $global:GitPromptSettings.EnablePromptStatus = $true
}

function poff
{
    $global:GitPromptSettings.EnablePromptStatus = $false
}

# import the GitHub shell settings from the GitHub for Windows install
$githubShellPath = "$env:LOCALAPPDATA\GitHub\shell.ps1"
if (test-path -PathType Leaf $githubShellPath)
{
    . $githubShellPath
}
# this is the profile that GitHub passes for its own shell, so source that here to get the same effect
$githubProfilePath = "$env:github_posh_git\profile.example.ps1"
if (test-path -PathType Leaf $githubProfilePath)
{
    . $githubProfilePath
}

function open-ongithub
{
    $gitRemoteOutput = git remote -v
    $gitRemoteOutput = [String]::Join([environment]::newline, $gitRemoteOutput)
    
    if ($gitRemoteOutput -match '(https://github.com/[^/]+/[^/]+)\.git ')
    {
        write-debug "Matches is $matches"
        $repoUrl = $matches[1]
    }
    else
    {
        throw 'Could not find a remote under github.com'
    }

    $gitStatus = Get-GitStatus
    $repoRoot = split-path $gitStatus.gitdir
    $pwdRelativePath = $pwd.ProviderPath.Substring($repoRoot.Length)
    $pwdRelativePath = $pwdRelativePath.Replace('\', '/')
    
    $fullUrl = '{0}/tree/{1}{2}' -f $repoUrl, $gitStatus.Branch, $pwdRelativePath
    write-debug "Opening github repo $fullUrl"
    [system.diagnostics.process]::Start($fullUrl)
}

# keep this last so it overrides anything from previous loaded modules
Import-Module Pscx -arg $docs\WindowsPowerShell\Modules\Pscx.UserPreferences.ps1
Import-Module PsGet
