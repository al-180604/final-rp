param(
    [string]$ProjectRoot = (Split-Path -Parent $PSScriptRoot)
)

$ErrorActionPreference = 'Stop'

$diagramDir = Join-Path $ProjectRoot 'diagrams'
$outputDir = Join-Path $ProjectRoot 'Images\mermaid'
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

$diagrams = Get-ChildItem -LiteralPath $diagramDir -Filter '*.mmd' | Sort-Object Name
if ($diagrams.Count -eq 0) {
    throw "No Mermaid source files found in $diagramDir"
}

foreach ($diagram in $diagrams) {
    $output = Join-Path $outputDir ($diagram.BaseName + '.png')
    Write-Host "Rendering $($diagram.Name) -> $output"
    & npx.cmd -y '@mermaid-js/mermaid-cli' `
        -i $diagram.FullName `
        -o $output `
        -b white `
        -s 2
    if ($LASTEXITCODE -ne 0) {
        throw "Mermaid rendering failed for $($diagram.FullName)"
    }
}

Write-Host "Rendered $($diagrams.Count) Mermaid diagrams."
