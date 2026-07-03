#!/usr/bin/env bash
set -euo pipefail

# TARGET HOST VAR (Easy configuration management swapping later)
MINT_HOST="galyn@100.74.100.15"

# ==============================================================================
# PHASE 1: PARALLEL INFRASTRUCTURE VM PROVISIONING CHECK
# ==============================================================================
echo "=== 🚀 Phase 1: Ensuring Virtual Nodes are Active (Mint Host) ==="

# Trigger parallel checks directly on the Mint virtualization target
ssh "$MINT_HOST" bash -s << 'EOF'
  echo "Checking headless node runtime matrices..."
  
  # Orchestrate ArchLinux headless layer
  if ! vboxmanage list runningvms | grep -q 'ArchLinux'; then
    echo "Starting ArchLinux Node headlessly..."
    vboxmanage startvm 'ArchLinux' --type headless
  else
    echo "ArchLinux Node is already active."
  fi

  # Orchestrate Debian headless layer
  if ! vboxmanage list runningvms | grep -q 'Debian'; then
    echo "Starting Debian Node headlessly..."
    vboxmanage startvm 'Debian' --type headless
  else
    echo "Debian Node is already active."
  fi
EOF

# ==============================================================================
# PHASE 2: SYNCHRONIZE CONTAINER FLEET VIA TAILSCALE MESH SOCKET
# ==============================================================================
echo "=== 🐳 Phase 2: Synchronizing Container Engines (Terraform) ==="
export DOCKER_HOST="tcp://100.74.100.15:2375"

# Initialize configurations silently if working from a fresh sandbox state
terraform init -backend=true > /dev/null 2>&1 || true
terraform apply -auto-approve

# ==============================================================================
# PHASE 3: TELEMETRY & SYSTEM CONFIGURATION ENFORCEMENT
# ==============================================================================
echo "=== 👑 Phase 3: Pushing System Configurations & Environments ==="

# Execute configuration baseline validation playbooks over secure terminal allocation
ssh -t "$MINT_HOST" "cd /home/galyn/homelab-ops && ansible-playbook sys_update.yaml -K"

echo "=== 🎉 Lab Environment Unified and Verified! ==="
