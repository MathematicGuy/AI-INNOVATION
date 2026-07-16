# scripts/verify-codebase-mcp.ps1
$ErrorActionPreference = "Stop"

# 1. Install codebase-memory-mcp if not present
if (!(Get-Command codebase-memory-mcp -ErrorAction SilentlyContinue) -and !(Test-Path "$env:USERPROFILE\.local\bin\codebase-memory-mcp.exe")) {
    Write-Host "Installing codebase-memory-mcp..."
    $installScript = Join-Path $env:TEMP "install-codebase-memory-mcp.ps1"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.ps1" -OutFile $installScript
    Unblock-File $installScript
    & $installScript --skip-config
}

# Ensure .local\bin is in the process Path if it exists
$localBin = "$env:USERPROFILE\.local\bin"
if (Test-Path $localBin) {
    $env:Path = "$localBin;" + $env:Path
}

# 2. Perform indexing
Write-Host "Running codebase-memory-mcp indexing..."
$outputJson = & codebase-memory-mcp cli index_repository --repo-path $PWD.Path --persistence true | Out-String
Write-Host "Indexer output:`n$outputJson"

# Try to parse the JSON output to get the project name
$projectName = "E-VIN-INTERNSHIP-AI-INNOVATION"
try {
    if ($outputJson -match '(\{.*\})') {
        $jsonObj = $Matches[1] | ConvertFrom-Json
        if ($jsonObj.project) {
            $projectName = $jsonObj.project
        }
    }
} catch {
    Write-Warning "Could not parse indexing output JSON: $_"
}

# 3. Check if graph.db.zst was created
$dbZstPath = Join-Path $PWD.Path ".codebase-memory\graph.db.zst"
if (!(Test-Path $dbZstPath)) {
    Write-Host "Warning: .codebase-memory/graph.db.zst was not created automatically (known Windows issue #400)."
    Write-Host "Attempting manual compression using zstd..."
    
    # Ensure .codebase-memory directory exists
    $cbMemDir = Join-Path $PWD.Path ".codebase-memory"
    if (!(Test-Path $cbMemDir)) {
        New-Item -ItemType Directory -Path $cbMemDir | Out-Null
    }
    
    $cacheDbFile = Join-Path $env:USERPROFILE ".cache\codebase-memory-mcp\$projectName.db"
    if (Test-Path $cacheDbFile) {
        $tempDb = Join-Path $cbMemDir "graph.db"
        Copy-Item -Path $cacheDbFile -Destination $tempDb -Force
        
        # Compress using zstd
        if (Get-Command zstd -ErrorAction SilentlyContinue) {
            & zstd -9 --rm $tempDb -o $dbZstPath
            Write-Host "Manual compression completed successfully: $dbZstPath"
        } else {
            Write-Error "Error: zstd is not installed. Cannot manually compress the database on Windows."
            exit 1
        }
    } else {
        Write-Error "Error: Could not find cache database file at $cacheDbFile"
        exit 1
    }
} else {
    Write-Host "Success: .codebase-memory/graph.db.zst generated successfully by the tool."
}

# 4. Check git configurations
Write-Host "Verifying .gitattributes..."
$gitAttrPath = Join-Path $PWD.Path ".gitattributes"
$attrLine = ".codebase-memory/graph.db.zst merge=ours"
if (!(Test-Path $gitAttrPath) -or !((Get-Content $gitAttrPath) -match [regex]::Escape($attrLine))) {
    Write-Host "Configuring .gitattributes..."
    Add-Content -Path $gitAttrPath -Value "`r`n$attrLine"
}

Write-Host "Verifying .gitignore..."
$gitIgnorePath = Join-Path $PWD.Path ".gitignore"
$ignoreLine = "!.codebase-memory/graph.db.zst"
if (!(Test-Path $gitIgnorePath) -or !((Get-Content $gitIgnorePath) -match [regex]::Escape($ignoreLine))) {
    Write-Host "Configuring .gitignore..."
    Add-Content -Path $gitIgnorePath -Value "`r`n`r`n# codebase-memory-mcp graph database tracking`r`n.codebase-memory/*`r`n!.codebase-memory/graph.db.zst"
}

# 5. Check if git check-ignore returns nothing for the graph.db.zst file
$checkIgnore = git check-ignore ".codebase-memory/graph.db.zst"
if ($checkIgnore) {
    Write-Error "Error: .codebase-memory/graph.db.zst is ignored by Git!"
    exit 1
}

Write-Host "Success: codebase-memory-mcp is successfully configured and tracked."
