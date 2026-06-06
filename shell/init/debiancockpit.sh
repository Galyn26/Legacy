#!/bin/bash
clear

figlet "DOCKER LAB"
figlet "WELCOME GALYN"

sleep 1
fastfetch
sleep 1

SESSION="debiancockpit"
tmux has-session -t $SESSION 2>/dev/null

if [ $? != 0 ]; then
        tmux new-session -d -s $SESSION -n DockerLab

        tmux split-window -h -t $SESSION:0
        tmux split-window -v -t $SESSION:0.1

        tmux send-keys -t $SESSION:0.0 'watch -n 2 "docker ps --format '\''table {{.Names}}\t{{.Status}}\t{{.Ports}}'\''"' C-m

        tmux send-keys -t $SESSION:0.1 'docker stats --no-stream' C-m

        tmux send-keys -t $SESSION:0.2 'journalctl -f -u docker' C-m

        tmux select-pane -t 0 -T "Containers"
        tmux select-pane -t 1 -T "Stats"
        tmux select-pane -t 2 -T "Logs"

        tmux select-layout even-horizontal
fi

tmux attach -t $SESSION