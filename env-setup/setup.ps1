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

# install psget
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

# install chocolatey
iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))

# don't install these packages, use the ones that come with GitHub for Windows
#cinstm git
#cinstm poshgit

# git stuff
cinstm githubforwindows
#cinstm TortoiseGit
#cinstm gitextensions
#cinstm git-flow-dependencies - see https://github.com/nvie/gitflow
#cinstm git.alias.standup

$docs = [environment]::GetFolderPath('mydocuments')
$env:path += ";$docs\bin"

$localDevMiscLocation = "$docs\GitHub\DevMisc"
git clone https://github.com/jamesmanning/DevMisc.git $localDevMiscLocation

cinstm kdiff3
git config --global diff.tool kdiff3
git config --global merge.tool kdiff3

# git aliases
git config --global alias.pa "!git add -A && git commit -v && git pull && git push"

cinstm linqpad4
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

# source the profile so the current shell is better off as well
. "$powershell_directory\profile.ps1"

# get PowerShell 3.0 before installing more apps
cinstm PowerShell

# install applications - see http://chocolatey.org/packages
cinstm DotNet4.5
cinstm notepadplusplus
cinstm 7zip
cinstm 7zip.commandline
cinstm sysinternals
cinstm fiddler
cinstm ChocolateyGUI
cinstm putty
cinstm curl
cinstm windirstat
cinstm GoogleChrome
cinstm stexbar
cinstm FoxitReader
cinstm grepwin
cinstm baretail
cinstm lastpass
cinstm RoyalTS
cinstm PoshRunner

# change chocolatey_bin_root to '\tools'
#cinstm toolsroot

# video viewers
#cinstm multiavchd

# user apps
#cinstm adobereader
#cinstm filezilla
#cinstm filezilla.commandline
#cinstm GoogleTalk
#cinstm HipChat
#cinstm launchy
#cinstm ultramon
#cinstm Slickrun
#cinstm WindowsLiveWriter
#cinstm tweetdeck
#cinstm iTunes
#cinstm imgburn
#cinstm Handbrake.WinGUI
#cinstm winrar
#cinstm evernote
#cinstm skype
#cinstm virtualbox
#cinstm Wget
#cinstm steam
#cinstm Everything
#cinstm jing
#cinstm clipx
#cinstm Monosnap
#cinstm mobalivecd - run linux livecd inside of windows

# powershell module?!?
#cinstm pscx

# cloud file storage
#cinstm dropbox
#cinstm SkyDrive
#cinstm googledrive

# editors
#cinstm sublimetext2
#cinstm vim
#cinstm markpad
#cinstm marker

# .NET stuff
#cinstm Fody - see addins list at https://github.com/Fody/Fody
#cinstm warmup - see http://devlicio.us/blogs/rob_reynolds/archive/2010/02/01/warmup-getting-started.aspx
#cinstm resharper
#cinstm dotPeek
#cinstm ilspy
#cinstm reflector
#cinstm monodevelop

# image editing
#cinstm InkScape
#cinstm paint.net
#cinstm gimp
#cinstm greenshot
#cinstm IcoFx

# security tools
#cinstm MicrosoftSecurityEssentials
#cinstm Secunia.PSI

# admin tools
#cinstm speccy - hardware info for machine
#cinstm wireshark
#cinstm autohotkey_l
#cinstm nmap
#cinstm teamviewer
#cinstm lockhunter
#cinstm ccleaner
#cinstm usbview
#cinstm RegScanner
#cinstm RegShot
#cinstm Revo.Uninstaller
#cinstm Wolfpack
#cinstm hmailserver
#cinstm adexplorer
#cinstm procdump - capture dumps during CPU spikes
#cinstm perfview
#cinstm ultradefrag

# dev tools
#cinstm windbg
#cinstm lessmsi
#cinstm expresso
#cinstm regexpixie
#cinstm logparser
#cinstm logparser.lizardgui
#cinstm smtp4dev
#cinstm resourcesextract
#cinstm ChirpyVSI
#cinstm Graphviz
#cinstm pdftk
#cinstm puppet
#cinstm SQLSentryPlanExplorer
#cinstm PlanExplorerSsmsAddin
#cinstm OctopusDeploy
#cinstm prototyper
#cinstm SelfSSL7
#cinstm pal - Performance Analysis of Logs (PAL) Tool
#cinstm ireport - free report designer for JasperReports
#cinstm appharborcli.install
#cinstm dotTrace
#cinstm sqlnexus - figure out sql perf issues
#cinstm sqldiagmanager
#cinstm webpicommandline
# WebPICMD.exe /Install /Products:WebMatrix
# WebPICMD.exe /List /ListOption:Available

# dev stacks / environments
#cinstm typescript.vs
#cinstm typescript
#cinstm CoffeeScript
#cinstm javaruntime
#cinstm javaruntime.x64
#cinstm java.jdk
#cinstm groovy
#cinstm scala
#cinstm erlang
#cinstm ruby
#cinstm clojure
#cinstm clojure.clr
#cinstm python
#cinstm nodejs
#cinstm nodejs.commandline
#cinstm PhantomJS
#cinstm Yeoman
#cinstm Compass
#cinstm mono
#cinstm VisualStudioExpress2012TFS
#cinstm VisualStudio2012WDX
#cinstm VisualStudio2012Ultimate
#cinstm VS2012SDK
#cinstm sharpdevelop
#cinstm stylecop

# data stores
#cinstm postgresql
#cinstm Couchbase
#cinstm couchdb
#cinstm memcached
#cinstm SqlServerExpress
#cinstm SqlServer2012Express
#cinstm rabbitmq
#cinstm redis
#cinstm MongoVUE
