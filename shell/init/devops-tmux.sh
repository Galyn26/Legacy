#!/bin/bash
SESSION="devops"

# Check if the tmux session already exists
tmux has-session -t $SESSION 2>/dev/null

if [ $? != 0 ]; then
    # Create the session in the background (-d) and name the first window "deck"
    tmux new-session -d -s $SESSION -n "deck"

    # Split the screen: Top pane and Bottom pane
    tmux split-window -v -t $SESSION:0

    # Split the bottom half horizontally (creating Left and Right bottom panes)
    tmux split-window -h -t $SESSION:0.1

    # Pane 0.0 (Top half): DNF history to track system changes
    tmux send-keys -t $SESSION:0.0 "dnf history list | head -n 20" C-m

    # Pane 0.1 (Bottom Left): Live Network traffic visualizer (bmon)
    tmux send-keys -t $SESSION:0.1 "bmon" C-m

    # Pane 0.2 (Bottom Right): Ready to run linting on your automation books
    tmux send-keys -t $SESSION:0.2 "echo '=== Ansible-Lint Deck ==='; ansible-lint --version" C-m
fi