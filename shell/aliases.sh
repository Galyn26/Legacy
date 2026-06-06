#!/bin/bash

# --- Laboratory Lifecycle Operations ---
alias start-lab='VBoxManage startvm "ArchLinux" --type headless && VBoxManage startvm "Debian" --type headless'
alias stop-lab='VBoxManage controlvm "ArchLinux" acpipowerbutton && VBoxManage controlvm "Debian" acpipowerbutton'

# --- API & Gateway Backends ---
alias start-odysseus='python3 -m uvicorn app:app --host 0.0.0.0 --port 7000'

