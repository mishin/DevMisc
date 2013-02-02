######
## NOTE: the contents of this file should be pasted into a powershell console or sourced
# 
# (new-object Net.WebClient).DownloadString("https://raw.github.com/jamesmanning/DevMisc/master/env-setup/profile.ps1") | iex
######

# first set execution policy so we can run scripts
Set-ExecutionPolicy Unrestricted -Force

# install psget
(new-object Net.WebClient).DownloadString("http://psget.net/GetPsGet.ps1") | iex

# install chocolatey
iex ((new-object net.webclient).DownloadString("http://bit.ly/psChocInstall"))

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

# now copy our own PowerShell files
(new-object Net.WebClient).DownloadFile(
	"https://raw.github.com/jamesmanning/DevMisc/master/env-setup/profile.ps1",
	"$powershell_directory\profile.ps1")
(new-object Net.WebClient).DownloadFile(
	"https://raw.github.com/jamesmanning/DevMisc/master/env-setup/James.ps1",
	"$powershell_directory\Modules\pscx\Modules\Prompt\Themes\James.ps1")

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
cinst linqpad4
cinst stexbar
cinst kdiff3
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

# git stuff
#cinst githubforwindows
#cinst git
#cinst gitextensions
#cinst TortoiseGit
#cinst poshgit
#cinst git-flow-dependencies - see https://github.com/nvie/gitflow
#cinst git.alias.standup

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