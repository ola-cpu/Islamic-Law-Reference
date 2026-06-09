# Télécharge les polices Amiri (OFL) pour l'arabe et les exports PDF.
$fontsDir = Join-Path $PSScriptRoot "..\assets\fonts"
New-Item -ItemType Directory -Force -Path $fontsDir | Out-Null
$urls = @{
  "Amiri-Regular.ttf" = @(
    "https://cdn.jsdelivr.net/gh/aliftype/amiri@main/fonts/Amiri-Regular.ttf",
    "https://raw.githubusercontent.com/aliftype/amiri/main/fonts/Amiri-Regular.ttf"
  )
  "Amiri-Bold.ttf" = @(
    "https://cdn.jsdelivr.net/gh/aliftype/amiri@main/fonts/Amiri-Bold.ttf",
    "https://raw.githubusercontent.com/aliftype/amiri/main/fonts/Amiri-Bold.ttf"
  )
}
foreach ($file in $urls.Keys) {
  $out = Join-Path $fontsDir $file
  $ok = $false
  foreach ($url in $urls[$file]) {
    try {
      Invoke-WebRequest -Uri $url -OutFile $out -UseBasicParsing
      $ok = $true
      break
    } catch {
      Write-Warning "Échec $url : $_"
    }
  }
  if (-not $ok) { throw "Impossible de télécharger $file" }
}
Write-Host "Polices installées dans assets/fonts/"
