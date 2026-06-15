#!/usr/bin/env bash

# Navigate to your homelab operations directory
cd "$HOME/homelab-ops" || { echo "Directory not found!"; exit 1; }

echo "==========================================="
echo " Starting Homelab Multi-OS Update Routine  "
echo "==========================================="

# Run the playbook and prompt for the sudo password (-K)
ansible-playbook sys_update.yaml -K

echo "==========================================="
echo " Update Routine Complete!                  "
echo "=========================================== "
