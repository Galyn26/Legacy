# ==============================================================================
# LEGACY LABORATORY INFRASTRUCTURE APPENDS
# Place this at the bottom of your ~/.bashrc file on Linux Mint MATE
# ==============================================================================

# Force window geometric resizing for heavy visual layouts
printf '\e[8;220;280t'

clear
echo ""
toilet -f mono12 -F metal "HACKER  COCKPIT"
echo ""

echo ""
toilet -f mono12 -F gay "WELCOME GALYN"
echo ""

sleep 2
neofetch
sleep 2

# Initialize custom prompt engine
eval "$(starship init bash)"

# Automatically trigger the terminal-native observability multiplexer on login
[ -z "$TMUX" ] && ~/shell/init/mint_tmux_launcher.sh

# Source modular infrastructure aliases if available
if [ -f ~/legacy/shell/aliases.sh ]; then
    source ~/legacy/shell/aliases.sh
fi

# ==============================================================================
# LEGACY LABORATORY LOGIN ENVIRONMENT INJECTIONS
# Place this inside ~/.bash_profile or ~/.profile on Headless Nodes
# ==============================================================================

# Automatically trigger localized telemetry matrices upon direct shell landing
if [ -z "$TMUX" ]; then
    ~/bin/cybercockpit.sh       # Executed on Arch Linux Node
fi

if [ -z "$TMUX" ]; then
    ~/bin/debiancockpit.sh      # Executed on Debian Linux Node
fi


# Append this to ~/.profile on Alpine
if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
    clear
    # [Your Micro Cockpit ASCII Art + Fastfetch Here]
    
    [ -f ~/.local/bin/micro-tmux.sh ] && ~/.local/bin/micro-tmux.sh
    sleep 2
    exec tmux attach-session -t micro 2>/dev/null || exec tmux new-session -s micro
fi

# Append this to ~/.bashrc on Fedora
if [ -n "$PS1" ] && [ -z "$TMUX" ]; then
    # [Your Fedora Neofetch / Banner Logic Here]
    
    [ -f ~/.local/bin/devops-tmux.sh ] && ~/.local/bin/devops-tmux.sh
    exec tmux attach-session -t devops 2>/dev/null || exec tmux new-session -s devops
fi