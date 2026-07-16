#!/usr/bin/env bash
set -euo pipefail

# 1. Install codebase-memory-mcp if not present
if ! command -v codebase-memory-mcp &> /dev/null && [ ! -f "$HOME/.local/bin/codebase-memory-mcp" ]; then
    echo "Installing codebase-memory-mcp..."
    curl -fsSL https://raw.githubusercontent.com/DeusData/codebase-memory-mcp/main/install.sh | bash -s -- --skip-config
fi

# Ensure bin is in path
export PATH="$HOME/.local/bin:$PATH"

# 2. Perform indexing
echo "Running codebase-memory-mcp indexing..."
output_json=$(codebase-memory-mcp cli index_repository --repo-path "$PWD" --persistence true || true)
echo "Indexer output:"
echo "$output_json"

# Try to parse the JSON output to get the project name
project_name="E-VIN-INTERNSHIP-AI-INNOVATION"
if [[ "$output_json" =~ \"project\":\"([^\"]+)\" ]]; then
    project_name="${BASH_REMATCH[1]}"
fi

# 3. Check if graph.db.zst was created
if [ ! -f ".codebase-memory/graph.db.zst" ]; then
    echo "Warning: .codebase-memory/graph.db.zst was not created automatically (known Windows/platform issue)."
    echo "Attempting manual compression using zstd..."
    
    mkdir -p .codebase-memory
    cache_db_file="$HOME/.cache/codebase-memory-mcp/$project_name.db"
    
    if [ -f "$cache_db_file" ]; then
        cp "$cache_db_file" .codebase-memory/graph.db
        if command -v zstd &> /dev/null; then
            zstd -9 --rm .codebase-memory/graph.db -o .codebase-memory/graph.db.zst
            echo "Manual compression completed successfully."
        else
            echo "Error: zstd is not installed. Cannot manually compress the database." >&2
            exit 1
        fi
    else
        echo "Error: Could not find cache database file at $cache_db_file" >&2
        exit 1
    fi
else
    echo "Success: .codebase-memory/graph.db.zst generated successfully by the tool."
fi

# 4. Check git configurations
echo "Verifying .gitattributes..."
if [ ! -f ".gitattributes" ] || ! grep -q ".codebase-memory/graph.db.zst merge=ours" ".gitattributes"; then
    echo "Configuring .gitattributes..."
    echo ".codebase-memory/graph.db.zst merge=ours" >> .gitattributes
fi

echo "Verifying .gitignore..."
if ! grep -q "!.codebase-memory/graph.db.zst" ".gitignore"; then
    echo "Configuring .gitignore..."
    {
        echo ""
        echo "# codebase-memory-mcp graph database tracking"
        echo ".codebase-memory/*"
        echo "!.codebase-memory/graph.db.zst"
    } >> .gitignore
fi

# 5. Check if git check-ignore returns nothing for the graph.db.zst file
if git check-ignore -q ".codebase-memory/graph.db.zst"; then
    echo "Error: .codebase-memory/graph.db.zst is ignored by Git!" >&2
    exit 1
fi

echo "Success: codebase-memory-mcp is successfully configured and tracked."
