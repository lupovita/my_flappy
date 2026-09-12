[CmdletBinding()]
param(
  [string]$WorktreePath,
  [switch]$Apply
)

$ErrorActionPreference = 'Stop'
$commonGitDir = (git rev-parse --path-format=absolute --git-common-dir).Trim()
$repoRoot = Split-Path -Parent $commonGitDir
$worktreeRoot = Join-Path $repoRoot 'worktrees'
$mainBranch = 'main'

if (-not (Test-Path -LiteralPath $worktreeRoot)) {
  throw "Expected worktree directory does not exist: $worktreeRoot"
}

$records = @()
$record = @{}
foreach ($line in (git -C $repoRoot worktree list --porcelain)) {
  if ([string]::IsNullOrWhiteSpace($line)) {
    if ($record.Count) { $records += [pscustomobject]$record; $record = @{} }
    continue
  }
  $key, $value = $line -split ' ', 2
  $record[$key] = $value
}
if ($record.Count) { $records += [pscustomobject]$record }

function Test-IsEligible([object]$Record) {
  if (-not $Record.branch) { return $false }
  $branch = $Record.branch -replace '^refs/heads/', ''
  if ($branch -eq $mainBranch) { return $false }
  $path = [IO.Path]::GetFullPath($Record.worktree)
  if (-not $path.StartsWith(([IO.Path]::GetFullPath($worktreeRoot)), [StringComparison]::OrdinalIgnoreCase)) { return $false }
  git -C $repoRoot merge-base --is-ancestor $branch $mainBranch 2>$null
  return $LASTEXITCODE -eq 0
}

$eligible = @($records | Where-Object { Test-IsEligible $_ })
if (-not $Apply) {
  if (-not $eligible) { Write-Output 'No merged worktrees are eligible for cleanup.'; exit 0 }
  $eligible | ForEach-Object {
    $branch = $_.branch -replace '^refs/heads/', ''
    Write-Output "$($_.worktree) [$branch]"
  }
  exit 0
}

if (-not $WorktreePath) { throw 'Specify -WorktreePath with -Apply.' }
$target = [IO.Path]::GetFullPath($WorktreePath)
$match = $eligible | Where-Object { [IO.Path]::GetFullPath($_.worktree) -eq $target }
if (-not $match) { throw 'Refusing cleanup: the path is not an eligible merged worktree.' }

$branch = $match.branch -replace '^refs/heads/', ''
git -C $repoRoot worktree remove -- $target
git -C $repoRoot branch -d -- $branch
Write-Output "Removed merged worktree and local branch: $target [$branch]"
