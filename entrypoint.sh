#! /bin/bash

if [ "$(ls -A /opt/minecraft)" ]; then
    echo "Directory is not empty, skipping..."

else
    echo "Directory is empty, installing MCDReforged..."
    cd /opt/minecraft
    python -m venv venv
    source /opt/minecraft/venv/bin/activate
    pip install mcdreforged
    python -m mcdreforged init
    deactivate
fi

cd /opt/minecraft
source /opt/minecraft/venv/bin/activate
pip install -U mcdreforged

if [ -f "/opt/minecraft/requirements.txt" ]; then
    echo "Installing requirements..."
    pip install -r requirements.txt
fi

python -m mcdreforged
