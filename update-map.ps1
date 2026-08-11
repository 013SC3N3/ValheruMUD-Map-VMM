# Copy the latest Mudlet map export into the repo and publish it.
# Author: O13SC3N3 (Shinra) - https://github.com/013SC3N3
# Usage:  .\update-map.ps1  [-Source <path to the .dat>] [-Force]
param(
    [string]$Source,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

# Repo always stores the map under this name; exports keep whatever name Mudlet saved.
$MapName = "VMM.dat"
$ExportDir = "$env:USERPROFILE\OneDrive\Desktop\MudletUI\side_project\mudlet_map_viewer"

if (-not $Source) {
    $newest = Get-ChildItem -Path $ExportDir -Filter *.dat -File -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if (-not $newest) { throw "No .dat export found in $ExportDir" }
    $Source = $newest.FullName
    Write-Output "Using newest export: $($newest.Name) ($($newest.LastWriteTime))"
}
if (-not (Test-Path $Source)) { throw "Map export not found: $Source" }

# Refuse to publish an export older than what's live, so a stale leftover file can't
# silently roll the map back. -Force overrides.
$published = git -C $PSScriptRoot log -1 --format=%cI -- "maps/$MapName"
if ($published -and -not $Force) {
    if ((Get-Item $Source).LastWriteTime -lt [datetime]::Parse($published)) {
        throw "Export $(Split-Path $Source -Leaf) is OLDER than the published map ($published). Re-export from Mudlet, or pass -Force to publish it anyway."
    }
}

Copy-Item $Source (Join-Path $PSScriptRoot "maps\$MapName") -Force
git -C $PSScriptRoot add "maps/$MapName"

# Exits 0 when nothing changed - the export is byte-identical to what's published.
git -C $PSScriptRoot diff --cached --quiet
if ($LASTEXITCODE -eq 0) {
    Write-Output "Map unchanged - nothing to publish."
    return
}

git -C $PSScriptRoot commit -m "Update map $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git -C $PSScriptRoot push
Write-Output "Pushed. Watch the build on the repo's Actions tab."
