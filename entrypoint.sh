#! /bin/bash

if [ "$INSTALL_MCDR" = "true" ] || [ -z "$(ls -A /opt/minecraft)" ]; then
    echo "Installing MCDReforged..."
    cd /opt/minecraft
    python -m venv venv
    source /opt/minecraft/venv/bin/activate
    pip install mcdreforged
    python -m mcdreforged init
    deactivate
else
    echo "Directory is not empty, skipping installation..."
fi

if [ ! -d "/opt/minecraft/venv" ]; then
    echo "Venv is not exist, please check the installation..."
    exit 1
fi

cd /opt/minecraft
source /opt/minecraft/venv/bin/activate
pip install -U mcdreforged

if [ -f "/opt/minecraft/requirements.txt" ]; then
    echo "Installing requirements..."
    pip install -r requirements.txt
fi

python -m mcdreforged
