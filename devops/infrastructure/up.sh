#!/usr/bin/env bash
set -e

# ==============================================================================
# PHASE 1: WAKE UP THE VIRTUAL INFRASTRUCTURE OVER SSH
# ==============================================================================
echo "=== 🚀 Phase 1: Ensuring Virtual Nodes are Active (Mint Host) ==="

# Check if ArchLinux is running; if not, fire it up headlessly
ssh galyn@100.74.100.15 "vboxmanage list runningvms | grep -q 'ArchLinux' || vboxmanage startvm 'ArchLinux' --type headless"

# Check if Debian is running; if not, fire it up headlessly
ssh galyn@100.74.100.15 "vboxmanage list runningvms | grep -q 'Debian' || vboxmanage startvm 'Debian' --type headless"

# ==============================================================================
# PHASE 2: SYNCHRONIZE CONTAINER FLEET VIA DOCKER SOCKET
# ==============================================================================
echo "=== 🐳 Phase 2: Synchronizing Container Engines (Terraform) ==="
export DOCKER_HOST="tcp://100.74.100.15:2375"
terraform apply -auto-approve

# ==============================================================================
# PHASE 3: PUSH CONFIGURATIONS, ENVIRONMENT ALIASES & TMUX LAYOUTS
# ==============================================================================
echo "=== 👑 Phase 3: Pushing System Configurations & Environments ==="

# Execute the playbook directly on the Mint host via SSH using the -t flag for the sudo password prompt
ssh -t galyn@100.74.100.15 "cd /home/galyn/homelab-ops && ansible-playbook sys_update.yaml -K"

echo "=== 🎉 Lab Environment Unified and Verified! ==="
