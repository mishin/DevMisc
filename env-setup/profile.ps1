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

function tfedit-files([string[]] $paths)
{
    write-debug "Invoking tf edit on paths $paths"
    tf edit $paths
#    foreach ($path in $paths)
#    {
#        write-debug "Invoking tf edit on file $path"
#        tf edit $path
#    }
}

$env:TFPT_ONLINE_EXCLUDE = '_ReSharper.*,LiveIntellisense,*.user,*.suo,TestResults,bin,obj,Debug,Release,*.ncrunchsolution,*.ncrunchproject,*.dll,*.pdb,*.crunchsolution.cache'
function tfsclean-dir([string] $path = '.')
{
    tfpt treeclean $path /r /i '/exclude:_ReSharper.*,LiveIntellisense,*.user,*.suo;*.ncrunchsolution;*.ncrunchproject'
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

function n
{
    $files = @($args) + @($input)
    $inputPaths = $files | 
        %{ first-not-empty $_.path, $_.fullname, $_ } |
        %{ expand-wildcards $_ }
        #?{ test-path -pathtype leaf $_ }
    edit-files $inputPaths
}

function ntf
{
    $files = @($args) + @($input)
    $inputPaths = $files | 
        %{ first-not-empty $_.path, $_.fullname, $_ } |
        %{ expand-wildcards $_ } |
        sort -uniq
        #?{ test-path -pathtype leaf $_ }

    tfedit-files $inputPaths
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

$sourceDir = 'C:\github\Main'
function s { cd $sourceDir }
if (($pwd.Path -eq $home) -and (test-path -pathtype container $sourceDir))
{
    cd $sourceDir
}

$pocDir = 'C:\github\Spikes'
function poc { cd $pocDir }

remove-item alias:lp -ea 0
$linqpadDir = 'C:\github\Main\LINQPad'
function lp { cd $linqpadDir }

function tfs
{
    Add-PSSnapin TfsBPAPowerShellSnapIn -ea 0
    TFSSnapin.ps1
}

function db
{
    $global:sourceDir = 'c:\github\Main\Database'
    cd $sourceDir
}

function main
{
    $global:sourceDir = 'c:\github\Main'
    cd $sourceDir
}

function linqpad
{
    robocopy \\tsclient\c\github\Main\LINQPad c:\github\Main\LINQPad /mir
    robocopy \\tsclient\c\github\Main\Libraries\servershared c:\github\Main\Libraries\servershared *.dll *.exe *.exe.config /mir /xd *resharper* /xd *testresults* /xd *tests /xd obj
    robocopy \\tsclient\c\github\Main\Libraries\DMClientLib c:\github\Main\Libraries\DMClientLib *.dll *.exe *.exe.config /mir /xd *resharper* /xd *testresults* /xd *tests /xd obj
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

#function github
#{
#    . 'C:\github\posh-git\profile.example.ps1'
#    $global:sourceDir = 'C:\github'
#    cd $sourceDir
#}



# Load posh-git example profile
#$env:path += ";${env:ProgramFiles(x86)}\Git\cmd"
#$env:path += ";${env:ProgramFiles(x86)}\Git\bin"

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

#Import-Module .\posh-git
#Import-Module posh-git
#Enable-GitColors
#Start-SshAgent -Quiet

# keep this last so it overrides anything from previous loaded modules
Import-Module Pscx -arg $docs\WindowsPowerShell\Modules\Pscx.UserPreferences.ps1
Import-Module PsGet
