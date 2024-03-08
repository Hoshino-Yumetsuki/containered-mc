#! /bin/bash

if [ "$(ls -A /home/container/minecraft)" ]; then
    echo "Directory is not empty, skipping..."

else
    echo "Directory is empty, installing MCDReforged..."
    cd /home/container/minecraft
    python -m venv venv
    source /home/container/minecraft/venv/bin/activate
    pip install mcdreforged
    python -m mcdreforged init
    deactivate
fi

cd /home/container/minecraft
source /home/container/minecraft/venv/bin/activate
pip install -U mcdreforged

if [ -f "/home/container/minecraft/requirements.txt" ]; then
    echo "Installing requirements..."
    pip install -r requirements.txt
fi

python -m mcdreforged
