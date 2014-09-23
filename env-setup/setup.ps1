######
## NOTE: the contents of this file should be pasted into a powershell console or sourced
# 
# (new-object Net.WebClient).DownloadString("https://raw.github.com/jamesmanning/DevMisc/master/env-setup/profile.ps1") | iex
######

# powershell location for WinXP
# http://www.microsoft.com/en-us/download/details.aspx?id=16818
# powershell prereq 2.0 SP1 for WinXP
# http://go.microsoft.com/fwlink/?linkid=153680
# .Net 4.0 (pre-req for chocolatey) Web Installer
# http://www.microsoft.com/en-us/download/details.aspx?id=17851

# first set execution policy so we can run scripts
Set-ExecutionPolicy Unrestricted -Force

# install chocolatey
iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))


############################
##### Boxstarter setup #####
############################
cinst boxstarter

Get-Module Boxstarter.* -ListAvailable | Import-Module

Install-WindowsUpdate -AcceptEula
#Update-ExecutionPolicy Unrestricted
#Move-LibraryDirectory "Personal" "$env:UserProfile\skydrive\documents"
Set-ExplorerOptions -showHidenFilesFoldersDrives -showProtectedOSFiles -showFileExtensions
Set-TaskbarSmall
Enable-RemoteDesktop

#cinst VisualStudioExpress2012Web
cinst fiddler
#cinst mssqlserver2012express
cinst git-credential-winstore
#cinst console-devel
#cinst skydrive
#cinst poshgit
cinst windbg

cinst Microsoft-Hyper-V-All -source windowsFeatures
cinst IIS-WebServerRole -source windowsfeatures
cinst IIS-HttpCompressionDynamic -source windowsfeatures
cinst IIS-ManagementScriptingTools -source windowsfeatures
cinst IIS-WindowsAuthentication -source windowsfeatures
#cinst TelnetClient -source windowsFeatures

#Install-ChocolateyPinnedTaskBarItem "$env:windir\system32\mstsc.exe"
#Install-ChocolateyPinnedTaskBarItem "$env:programfiles\console\console.exe"

#copy-item (Join-Path (Get-PackageRoot($MyInvocation)) 'console.xml') -Force $env:appdata\console\console.xml

#Install-ChocolateyVsixPackage xunit http://visualstudiogallery.msdn.microsoft.com/463c5987-f82b-46c8-a97e-b1cde42b9099/file/66837/1/xunit.runner.visualstudio.vsix
#Install-ChocolateyVsixPackage autowrocktestable http://visualstudiogallery.msdn.microsoft.com/ea3a37c9-1c76-4628-803e-b10a109e7943/file/73131/1/AutoWrockTestable.vsix
































# don't install these packages, use the ones that come with GitHub for Windows
#cinst git
#cinst poshgit

# git stuff
cinst githubforwindows
#cinst TortoiseGit
#cinst gitextensions
#cinst git-flow-dependencies - see https://github.com/nvie/gitflow
#cinst git.alias.standup

# source necessary files to add git to our path
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

$docs = [environment]::GetFolderPath('mydocuments')
$env:path += ";$docs\bin"

$localDevMiscLocation = "$docs\GitHub\DevMisc"
git clone https://github.com/jamesmanning/DevMisc.git $localDevMiscLocation

cinst kdiff3
git config --global diff.tool kdiff3
git config --global merge.tool kdiff3

# git aliases
git config --global alias.pa "!git add -A && git commit -v && git pull --rebase && git push"
git config --global alias.ca "!git add -A && git commit -v"
git config --global alias.cp "!git commit -v && git pull --rebase && git push"
git config --global alias.pp "!git pull --rebase && git push"
git config --global alias.ae "!git config --global --edit"
git config --global alias.a "!git config --get-regexp alias"
git config --global alias.pps "!git stash save --include-untracked --no-keep-index && git pull --rebase && git push && git stash pop"
git config --global alias.pristine "!git reset --hard && git clean -x -f -d"

# avoid the git gui popup dialog about compressing the database due to loose objects
git config --global gui.gcwarning false

cinst linqpad4
$linqpadScriptDirectory = "$localDevMiscLocation\LINQPad"
$linqpadAppDataDirectory = "$env:APPDATA\LINQPad"
mkdir $linqpadAppDataDirectory

$linqpadXmlSettings = @"
<?xml version="1.0" encoding="utf-8"?>
<UserOptions xmlns="http://schemas.datacontract.org/2004/07/LINQPad">
  <CustomSnippetsFolder>$linqpadScriptDirectory</CustomSnippetsFolder>
  <DefaultQueryLanguage>Expression</DefaultQueryLanguage>
  <MaxQueryRows>1000</MaxQueryRows>
  <NoNativeKeysQuestion>true</NoNativeKeysQuestion>
  <PluginsFolder>$linqpadScriptDirectory\lib</PluginsFolder>
  <ConvertTabsToSpaces>true</ConvertTabsToSpaces>
  <ResultsInGrids>true</ResultsInGrids>
  <TabSize>4</TabSize>
</UserOptions>
"@

[io.file]::writealltext("$linqpadAppDataDirectory\QueryLocations.txt", $linqpadScriptDirectory)
[io.file]::writealltext("$linqpadAppDataDirectory\SnippetLocations.txt", $linqpadScriptDirectory)
[io.file]::writealltext("$linqpadAppDataDirectory\querypath.txt", $linqpadScriptDirectory)
[io.file]::writealltext("$linqpadAppDataDirectory\PluginLocations.txt", "$linqpadScriptDirectory\lib")
[io.file]::writealltext("$linqpadAppDataDirectory\RoamingUserOptions.xml", $linqpadXmlSettings)


# install psget
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

Install-Module Find-String
Install-Module ImageSorter
Install-Module PExtend
Install-Module PoshCode
Install-Module posh-git
Install-Module posh-npm
Install-Module pscx
Install-Module PsJson
Install-Module PsUrl
Install-Module pswatch

# a few variables to make things easier later on
$powershell_directory = split-path $profile
$documents_directory = split-path $powershell_directory
$bin_directory = join-path $documents_directory 'bin'

mkdir $powershell_directory
mkdir $bin_directory

# copy files to docs from our template, ignoring any that already exist
robocopy "$localDevMiscLocation\env-setup\template-docs" $docs /xc /xn /xo /xx /ndl /s # /l
robocopy "$localDevMiscLocation\env-setup\template-appdata" $env:AppData /xc /xn /xo /xx /ndl /s /l

# source the profile so the current shell is better off as well
. "$powershell_directory\profile.ps1"

# get PowerShell 3.0 before installing more apps
cinst PowerShell

# install applications - see http://chocolatey.org/packages
cinst DotNet4.5
cinst notepadplusplus
cinst 7zip
cinst 7zip.commandline
cinst sysinternals
cinst fiddler
cinst ChocolateyGUI
cinst putty
cinst curl
cinst windirstat
cinst GoogleChrome
cinst stexbar
cinst FoxitReader
cinst grepwin
cinst baretail
cinst lastpass
cinst RoyalTS
cinst PoshRunner

# change chocolatey_bin_root to '\tools'
#cinst toolsroot

# video viewers
#cinst multiavchd

# user apps
#cinst adobereader
#cinst filezilla
#cinst filezilla.commandline
#cinst GoogleTalk
#cinst HipChat
#cinst launchy
#cinst ultramon
#cinst Slickrun
#cinst WindowsLiveWriter
#cinst tweetdeck
#cinst iTunes
#cinst imgburn
#cinst Handbrake.WinGUI
#cinst winrar
#cinst evernote
#cinst skype
#cinst virtualbox
#cinst Wget
#cinst steam
#cinst Everything
#cinst jing
#cinst clipx
#cinst Monosnap
#cinst mobalivecd - run linux livecd inside of windows

# powershell module?!?
#cinst pscx

# cloud file storage
#cinst dropbox
#cinst SkyDrive
#cinst googledrive

# editors
#cinst sublimetext2
#cinst vim
#cinst markpad
#cinst marker

# .NET stuff
#cinst Fody - see addins list at https://github.com/Fody/Fody
#cinst warmup - see http://devlicio.us/blogs/rob_reynolds/archive/2010/02/01/warmup-getting-started.aspx
#cinst resharper
#cinst dotPeek
#cinst ilspy
#cinst reflector
#cinst monodevelop

# image editing
#cinst InkScape
#cinst paint.net
#cinst gimp
#cinst greenshot
#cinst IcoFx

# security tools
#cinst MicrosoftSecurityEssentials
#cinst Secunia.PSI

# admin tools
#cinst speccy - hardware info for machine
#cinst wireshark
#cinst autohotkey_l
#cinst nmap
#cinst teamviewer
#cinst lockhunter
#cinst ccleaner
#cinst usbview
#cinst RegScanner
#cinst RegShot
#cinst Revo.Uninstaller
#cinst Wolfpack
#cinst hmailserver
#cinst adexplorer
#cinst procdump - capture dumps during CPU spikes
#cinst perfview
#cinst ultradefrag

# dev tools
#cinst windbg
#cinst lessmsi
#cinst expresso
#cinst Codaxy.WkHtmlToPdf
#cinst regexpixie
#cinst logparser
#cinst logparser.lizardgui
#cinst smtp4dev
#cinst resourcesextract
#cinst ChirpyVSI
#cinst Graphviz
#cinst pdftk
#cinst puppet
#cinst SQLSentryPlanExplorer
#cinst PlanExplorerSsmsAddin
#cinst OctopusDeploy
#cinst prototyper
#cinst SelfSSL7
#cinst pal - Performance Analysis of Logs (PAL) Tool
#cinst ireport - free report designer for JasperReports
#cinst appharborcli.install
#cinst dotTrace
#cinst sqlnexus - figure out sql perf issues
#cinst sqldiagmanager
#cinst webpicommandline
# WebPICMD.exe /Install /Products:WebMatrix
# WebPICMD.exe /List /ListOption:Available

# dev stacks / environments
#cinst typescript.vs
#cinst typescript
#cinst CoffeeScript
#cinst javaruntime
#cinst javaruntime.x64
#cinst java.jdk
#cinst groovy
#cinst scala
#cinst erlang
#cinst ruby
#cinst clojure
#cinst clojure.clr
#cinst python
#cinst nodejs
#cinst nodejs.commandline
#cinst PhantomJS
#cinst Yeoman
#cinst Compass
#cinst mono
#cinst VisualStudioExpress2012TFS
#cinst VisualStudio2012WDX
#cinst VisualStudio2012Ultimate
#cinst VS2012SDK
#cinst sharpdevelop
#cinst stylecop

# data stores
#cinst postgresql
#cinst Couchbase
#cinst couchdb
#cinst memcached
#cinst SqlServerExpress
#cinst SqlServer2012Express
#cinst rabbitmq
#cinst redis
#cinst MongoVUE
