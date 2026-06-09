# Prépare le build AAB pour Play Console (test interne ou production).
$ErrorActionPreference = "Stop"
$root = Join-Path $PSScriptRoot ".."
Set-Location $root

Write-Host "=== Islamic Law Reference — préparation release Play ===" -ForegroundColor Cyan

$keyProps = Join-Path $root "android\key.properties"
$keyExample = Join-Path $root "android\key.properties.example"
$keystore = Join-Path $root "android\upload-keystore.jks"

if (-not (Test-Path $keyProps)) {
  Write-Host ""
  Write-Host "Aucun android/key.properties trouvé." -ForegroundColor Yellow
  Write-Host "Pour la Play Store, créez d'abord un keystore :" -ForegroundColor Yellow
  Write-Host "  cd android"
  Write-Host "  keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload"
  Write-Host "  copy key.properties.example key.properties"
  Write-Host "  # Éditez key.properties"
  Write-Host ""
  $cont = Read-Host "Continuer avec la clé DEBUG (tests locaux uniquement) ? [o/N]"
  if ($cont -notmatch '^[oOyY]') { exit 1 }
} elseif (-not (Test-Path $keystore)) {
  Write-Host "key.properties existe mais upload-keystore.jks est introuvable." -ForegroundColor Red
  exit 1
} else {
  Write-Host "Keystore release détecté." -ForegroundColor Green
}

Write-Host ""
Write-Host "flutter pub get..."
flutter pub get | Out-Null

Write-Host "flutter build appbundle --release..."
flutter build appbundle --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$aab = Join-Path $root "build\app\outputs\bundle\release\app-release.aab"
if (Test-Path $aab) {
  $size = [math]::Round((Get-Item $aab).Length / 1MB, 2)
  Write-Host ""
  Write-Host "AAB prêt : $aab ($size Mo)" -ForegroundColor Green
  Write-Host "Politique web : https://ola-cpu.github.io/Islamic-Law-Reference/privacy.html"
  Write-Host "Guide test interne : store\GUIDE_DEMARRAGE.md"
  Write-Host "Play Console : https://play.google.com/console"
} else {
  Write-Host "AAB introuvable après le build." -ForegroundColor Red
  exit 1
}
