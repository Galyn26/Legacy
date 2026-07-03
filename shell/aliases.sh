#!/bin/bash

# --- Laboratory Lifecycle Operations ---
alias start-lab='VBoxManage startvm "ArchLinux" --type headless && VBoxManage startvm "Debian" --type headless'
alias stop-lab='VBoxManage controlvm "ArchLinux" acpipowerbutton && VBoxManage controlvm "Debian" acpipowerbutton'

# --- API & Gateway Backends ---
alias start-odysseus='python3 -m uvicorn app:app --host 0.0.0.0 --port 7000'
# Deprecated because of odysseus runs on docker now

# ==============================================================================
# SECURE AI NETWORKING TUNNELS
# ==============================================================================

# Establish secure encrypted bridge from iMac Cockpit to Mint Odysseus AI Core
alias tunnel-odysseus="ssh -N -L 7777:127.0.0.1:7000 galyn@100.74.100.15"
# Also deprecated because of reason above, but still works for legacy purposes

# ==============================================================================
# PRIMARY LABORATORY ENTRY POINTS
# ==============================================================================

# Direct secure line to the main Linux Mint MATE bare-metal host via Tailscale
alias mint-cockpit="ssh galyn@100.74.100.15"


# ==============================================================================
# MacOS zshrc Snippet
# ==============================================================================
# Place this at the bottom of your ~/.zshrc file on MacOS

pfetch

echo ""
toilet -f future -F metal "Approach knowledge with the wonder of a child,"
toilet -f future -F metal "the scrutiny of an adult,"
toilet -f future -F metal "and the acceptance"
toilet -f future -F metal "of a stoic."
echo ""