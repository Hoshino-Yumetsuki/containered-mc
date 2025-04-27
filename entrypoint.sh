#!/bin/bash
set -e

# Configure UV_DEFAULT_INDEX based on PYPI_URL if not set
if [ -z "$UV_DEFAULT_INDEX" ]; then
    echo "UV_DEFAULT_INDEX not set, using PYPI_URL: $PYPI_URL"
    export UV_DEFAULT_INDEX="$PYPI_URL"
else
    echo "Using UV_DEFAULT_INDEX: $UV_DEFAULT_INDEX"
fi

# Install Python dependencies if found in mounted volume
if [ -f "/data/requirements.txt" ]; then
    echo "Installing Python dependencies from /data/requirements.txt using uv..."
    uv pip install --system --break-system-packages -r "/data/requirements.txt"
fi

# Change to Minecraft working directory
cd /data

# Start MCDReforged
echo "Starting MCDReforged in /data directory"
exec python -m mcdreforged
