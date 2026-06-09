# Crée les illustrations de catégories (copie l'icône app en attendant des visuels dédiés).
$dir = Join-Path $PSScriptRoot "..\assets\images\categories"
$src = Join-Path $PSScriptRoot "..\store\icon\app_icon.png"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
if (-not (Test-Path $src)) { throw "Icône source introuvable: $src" }
$icons = @(
  'mosque', 'volunteer_activism', 'people', 'family_restroom', 'monetization_on',
  'gavel', 'favorite', 'restaurant', 'description', 'accessibility', 'account_balance'
)
foreach ($name in $icons) {
  Copy-Item $src (Join-Path $dir "$name.png") -Force
}
Write-Host "Illustrations copiées dans assets/images/categories/"
