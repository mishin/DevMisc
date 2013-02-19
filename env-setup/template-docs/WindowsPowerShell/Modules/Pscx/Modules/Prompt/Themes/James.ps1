# ---------------------------------------------------------------------------
# Author: James Manning
# Desc:   James' prompt, colors and host window title updates.
# Date:   Nov 17, 2010
# Site:   http://pscx.codeplex.com
# Usage:  In your options hashtable place the following setting:
#
#         PromptTheme = 'James'
# ---------------------------------------------------------------------------
#requires -Version 2.0
param([hashtable]$Theme)

Set-StrictMode -Version 2.0

# ---------------------------------------------------------------------------
# Colors
# ---------------------------------------------------------------------------
#$Theme.HostBackgroundColor   = if ($Pscx:IsAdmin) { 'DarkRed' } else { 'Black' }
#$Theme.HostForegroundColor   = if ($Pscx:IsAdmin) { 'White'   } else { 'Gray'  }
#$Theme.PromptForegroundColor = if ($Pscx:IsAdmin) { 'Yellow'  } else { 'White' }
#$Theme.PrivateData.ErrorForegroundColor = if ($Pscx:IsAdmin) { 'DarkCyan' }

$Theme.HostBackgroundColor   = 'Black'
$Theme.HostForegroundColor   = 'White'
$Theme.PromptForegroundColor = 'Yellow'

# ---------------------------------------------------------------------------
# Prompt ScriptBlock
# ---------------------------------------------------------------------------
$Theme.PromptScriptBlock = {
    param($Id)

    if($NestedPromptLevel)
    {
        new-object string ([char]0xB7), $NestedPromptLevel
    }

    #"[managed thread id is $([threading.thread]::CurrentThread.ManagedThreadId)]"

    if (test-path function:Write-VcsStatus)
    {
        #"Left = $([console]::CursorLeft) Top = $([console]::CursorTop)`n"
        Write-VcsStatus
        #"Left = $([console]::CursorLeft) Top = $([console]::CursorTop)`n"
    }

#   "[$Id] $([char]0xBB)"
    "$((Get-Location).ProviderPath) $([char]0xBB)"
}

# ---------------------------------------------------------------------------
# Window Title Update ScriptBlock
# ---------------------------------------------------------------------------
$Theme.UpdateWindowTitleScriptBlock = {
	split-path -leaf (Get-Location)
#	'-'
#	'Windows PowerShell'

	if($Pscx:IsAdmin)
	{
		' (Administrator)'
	}

	if ($Pscx:IsWow64Process)
	{
		' (x86)'
	}
}

#clear-host
