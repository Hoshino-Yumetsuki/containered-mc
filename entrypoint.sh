#!/bin/bash
set -e

# Configure UV_DEFAULT_INDEX based on PYPI_URL if not set
if [ -z "$UV_DEFAULT_INDEX" ]; then
    echo "UV_DEFAULT_INDEX not set, using PYPI_URL: $PYPI_URL"
    export UV_DEFAULT_INDEX="$PYPI_URL"
else
    echo "Using UV_DEFAULT_INDEX: $UV_DEFAULT_INDEX"
fi

# Function to install Python dependencies using uv
install_python_deps() {
    if [ -f "$1" ]; then
        echo "Installing Python dependencies from $1 using uv..."
        uv pip install --system -r "$1"
    fi
}

# Check for dependencies in /data directory
if [ -f "/data/requirements.txt" ]; then
    echo "Found requirements.txt in /data directory"
    install_python_deps "/data/requirements.txt"
fi

# Check for additional requirements
if [ -f "/data/requirements.txt" ]; then
    echo "Installing requirements from /data/requirements.txt..."
    uv pip install --system -r /data/requirements.txt
fi

# Change to Minecraft working directory
cd /data

# Check for custom command
if [ -n "$CUSTOM_COMMAND" ]; then
    echo "Running custom command: $CUSTOM_COMMAND"
    eval "$CUSTOM_COMMAND"
else
    # Start MCDReforged
    echo "Starting MCDReforged in /data directory"
    python -m mcdreforged
fi
