# Generates a unique name for every window, e.g., "cockpit-143522" (Hour-Minute-Second)
SESSION="cockpit-$(date +%H%M%S)"

# Since the session name is now unique every time, this will always create a fresh one
if ! tmux has-session -t "$SESSION" 2>/dev/null; then

        # Create the new detached session with our unique name
        tmux new-session -d -s "$SESSION"

        # Pane 0.0: Run btop
        tmux send-keys -t "$SESSION" 'btop' C-m

        # Pane 0.1: Split horizontally and go home
        tmux split-window -h -t "$SESSION"
        tmux send-keys -t "$SESSION:0.1" 'cd ~' C-m

        # Pane 0.2: Split vertically under the home pane and tail syslog
        # NOTE: On newer Linux distros, you might need 'journalctl -f' if syslog is empty!
        tmux split-window -v -t "$SESSION:0.1"
        tmux send-keys -t "$SESSION:0.2" 'tail -f /var/log/syslog' C-m

        # Focus back on the terminal pane (0.1)
        tmux select-pane -t "$SESSION:0.1"
fi

# Attach to our brand new unique session
tmux attach -t "$SESSION"