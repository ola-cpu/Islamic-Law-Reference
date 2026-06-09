# Capture les captures d'écran Play Store via integration_test.
# Prérequis : émulateur Android ou appareil connecté (flutter devices).
param(
  [string]$DeviceId = ""
)

$ErrorActionPreference = "Stop"
Set-Location (Join-Path $PSScriptRoot "..")

$devices = flutter devices 2>&1 | Out-String
if ($devices -notmatch "android|emulator") {
  Write-Warning "Aucun appareil Android détecté. Lancez un émulateur puis relancez ce script."
  exit 1
}

$outDir = Join-Path (Get-Location) "store\screenshots"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$deviceArg = @()
if ($DeviceId) { $deviceArg = @("-d", $DeviceId) }

Write-Host "Capture en cours — fichiers exportés vers build/ et $outDir"
flutter test integration_test/store_screenshots_test.dart @deviceArg --reporter expanded

$built = Get-ChildItem -Path "build" -Recurse -Filter "*.png" -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -match '^\d{2}_' } |
  Sort-Object LastWriteTime -Descending

foreach ($shot in $built) {
  Copy-Item $shot.FullName (Join-Path $outDir $shot.Name) -Force
  Write-Host "  -> $($shot.Name)"
}

Write-Host "Terminé. Vérifiez store/screenshots/"
