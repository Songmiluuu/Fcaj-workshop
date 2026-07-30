$ErrorActionPreference = "Stop"

$hugoCommand = Get-Command hugo -ErrorAction SilentlyContinue
$hugoPath = if ($hugoCommand) {
    $hugoCommand.Source
} else {
    Join-Path $PSScriptRoot "..\.tools\hugo-0.134.3\hugo.exe"
}

if (-not (Test-Path -LiteralPath $hugoPath)) {
    throw "Hugo Extended 0.134.3 was not found. Install Hugo or update `$hugoPath in build.ps1."
}

& $hugoPath --gc --minify --baseURL "/"
