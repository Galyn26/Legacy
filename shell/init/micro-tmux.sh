#!/bin/sh
# Check if the 'micro' session already exists
tmux has-session -t micro 2>/dev/null

if [ $? -ne 0 ]; then
    # 1. Start a new detached session, name the window "cockpit"
    tmux new-session -d -s micro -n "cockpit"

    # 2. Split the window horizontally to create a right column (50% wide)
    tmux split-window -h -t micro:cockpit

    # 3. Split that new right-hand pane vertically to create top and bottom tiles
    tmux split-window -v -t micro:cockpit.1

    # 4. Send Alpine-specific telemetry monitoring to the right-side panes
    # Top-right pane (index 1): Live listening sockets and network traffic
    tmux send-keys -t micro:cockpit.1 "watch -n 2 netstat -tulpn" C-m

    # Bottom-right pane (index 2): Resource footprints via Alpine's busybox top
    tmux send-keys -t micro:cockpit.2 "top -d 2" C-m

    # 5. Focus back on the main left pane (index 0) so your cursor is ready to type
    tmux select-pane -t micro:cockpit.0
fi