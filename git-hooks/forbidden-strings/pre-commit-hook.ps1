# search for any files that have 'do not checkin' in them, as those should be reverted first
# NOTE: we *could* revert the change ourselves in this script, but rather than risk losing
# important changes, we only check the contents of the files

# uncomment this line to help debug the operation of this script
#$DebugPreference = 'Continue'

Set-StrictMode -Version Latest

$OFS = "`n`t" # put newlines and a tab between array items in output strings

$gitConfigSection = 'threebirds'
$gitConfigKey = 'forbiddenstrings'
$gitConfigName = "$gitConfigSection.$gitConfigKey"

$stringsToSearchFor = @(
    git config --get-all $gitConfigName | 
        %{ $_ -split ',' } # split on comma so users can set a single config value instead of needing to use multivar support
)

if ($stringsToSearchFor.Length -eq 0)
{
    $stringsToSearchFor = @(
        'DO NOT CHECKIN',
        'DO NOT CHECK-IN'
    )
    Write-Debug "Did not find any strings to exclude via git config of $gitConfigName, using defaults:$OFS$stringsToSearchFor"
}
else
{
    Write-Debug "Search patterns from git config $gitConfigName to use for commit changes:$OFS$stringsToSearchFor"
}

$gitStatusZ = git status --porcelain -z

# if status is null, then there are no changes in index or working tree, so nothing to check
if ($gitStatusZ -eq $null) { return }

$currentGitStatusLines = $gitStatusZ.Split([char]0)

Write-Debug "git status --porcelain returned status of:$OFS$currentGitStatusLines"

$gitStatusLinesToCheck = @($currentGitStatusLines |
    # filter the files based on their status in the index (the first character of the status line). See the notes
    # for the --porcelain format at http://www.kernel.org/pub/software/scm/git/docs/git-status.html - we only want to
    # include files that are modified, added, renamed, or copied in the index - filtering out deleted, untracked, and ignored.
    ?{ $_ -match '^[MARC][ MDAU] ' } 
)
Write-Debug "git status lines to be checked:$OFS$gitStatusLinesToCheck"

# remove the 3 status characters at the front of the line
$relativeFilePaths = @($gitStatusLinesToCheck | %{ $_.Substring(3) })
Write-Debug "relative file paths to be checked:$OFS$relativeFilePaths"

$relativeFilePathsThatExist = @($relativeFilePaths |
    ?{ Test-Path -PathType Leaf -Path $_ }
)
Write-Debug "relative file paths that exist:$OFS$relativeFilePathsThatExist"

if ($relativeFilePathsThatExist.Length -eq 0)
{
    return
}
$patternMatches = @(Select-String -Context 3 -SimpleMatch -Pattern $stringsToSearchFor -Path $relativeFilePathsThatExist)

Write-Debug "$($patternMatches.Length) matches found:$OFS$patternMatches"

if ($patternMatches.Length -ne 0)
{
    #Write-Warning "Cannot perform git commit due to files with forbidden strings found:`n$patternMatches"
    #Write-Error "Cannot perform git commit due to files with forbidden strings found"
    Write-Host -ForegroundColor Red -BackgroundColor Black "Cannot perform git commit due to files with forbidden strings found`n`n$patternMatches"
    #Write-Host -ForegroundColor Red -BackgroundColor Black "$patternMatches"
    # git commit needs a non-zero exit code to signal that it should abort the commit
    exit 1
}
