#!/bin/bash
clear

figlet "CYBER COCKPIT"
figlet "WELCOME GALYN"

sleep 2

fastfetch

sleep 2

SESSION="cockpit"
tmux has-session -t $SESSION 2>/dev/null
if [ $? != 0 ]; then
        tmux new-session -d -s $SESSION -n System

        tmux split-window -h -t $SESSION:0
        tmux select-pane -t 0

        tmux split-window -v -t $SESSION:0

        tmux send-keys -t $SESSION:0.0 "journalctl -xe" C-m
        tmux send-keys -t $SESSION:0.2 "htop" C-m
        tmux send-keys -t $SESSION:0.1 "bmon" C-m

fi

tmux attach-session -t $SESSION