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