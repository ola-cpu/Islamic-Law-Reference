# Télécharge les polices Amiri (OFL) pour l'arabe et les exports PDF.
$fontsDir = Join-Path $PSScriptRoot "..\assets\fonts"
New-Item -ItemType Directory -Force -Path $fontsDir | Out-Null
$base = "https://github.com/aliftype/amiri/raw/main"
Invoke-WebRequest -Uri "$base/Amiri-Regular.ttf" -OutFile (Join-Path $fontsDir "Amiri-Regular.ttf")
Invoke-WebRequest -Uri "$base/Amiri-Bold.ttf" -OutFile (Join-Path $fontsDir "Amiri-Bold.ttf")
Write-Host "Polices installées dans assets/fonts/"
