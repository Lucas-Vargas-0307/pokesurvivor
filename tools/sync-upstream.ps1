<#
.SYNOPSIS
    Sincroniza los cambios del repositorio oficial (JPTER78/pokesurvivor) con la rama local actual.

.DESCRIPTION
    1. Comprueba o añade el remote 'upstream'.
    2. Descarga las últimas novedades con 'git fetch upstream main'.
    3. Si hay novedades, las fusiona (merge) manteniendo las modificaciones de 8 jugadores.
    4. Vuelve a compilar el juego con 'tools/build.js'.
    5. Ejecuta las pruebas automáticas para garantizar que todo sigue funcionando.

.PARAMETER Expose
    Si se especifica, compila con '--expose' para mantener window.G accesible en depuración.
#>

[CmdletBinding()]
param(
    [switch]$Expose
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$rootDir = Split-Path -Parent $scriptDir
Set-Location $rootDir

Write-Host "=== Sincronización con Upstream (JPTER78/pokesurvivor) ===" -ForegroundColor Cyan

# 1. Configurar remote upstream si no existe
$remotes = git remote
if ($remotes -notcontains "upstream") {
    Write-Host "[1/5] Añadiendo remote upstream..." -ForegroundColor Yellow
    git remote add upstream https://github.com/JPTER78/pokesurvivor.git
} else {
    Write-Host "[1/5] Remote upstream verificado." -ForegroundColor Green
}

# 2. Descargar commits de upstream
Write-Host "[2/5] Descargando novedades de upstream/main..." -ForegroundColor Yellow
git fetch upstream main

# 3. Comprobar si hay cambios pendientes
$upstreamRev = (git rev-parse upstream/main).Trim()
$mergeBase = (git merge-base HEAD upstream/main).Trim()

if ($upstreamRev -eq $mergeBase) {
    Write-Host "[OK] Ya estás completamente al día con el repositorio original." -ForegroundColor Green
    exit 0
}

Write-Host "[3/5] Se han detectado actualizaciones en upstream. Fusionando..." -ForegroundColor Yellow
git merge upstream/main -m "Merge upstream updates from JPTER78/pokesurvivor"
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Hubo un conflicto al fusionar. Resuelve los conflictos manualmente y luego compila." -ForegroundColor Red
    exit 1
}

# 4. Reconstruir los archivos de distribución
Write-Host "[4/5] Recompilando el juego..." -ForegroundColor Yellow
$buildArgs = @("tools/build.js")
if ($Expose) { $buildArgs += "--expose" }
& node $buildArgs
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Falló la compilación con tools/build.js." -ForegroundColor Red
    exit 1
}

# 5. Ejecutar tests
Write-Host "[5/5] Ejecutando tests de verificación..." -ForegroundColor Yellow
& node --test tests/net.test.cjs
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Los tests de red/cooperativo han fallado." -ForegroundColor Red
    exit 1
}

& node --test tests/*.test.cjs
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Algunos tests del proyecto han fallado." -ForegroundColor Red
    exit 1
}

Write-Host "=== Sincronización completada con éxito al 100% ===" -ForegroundColor Green
Write-Host "Puedes revisar los cambios con 'git status' y subirlos con 'git push origin main'." -ForegroundColor Cyan
