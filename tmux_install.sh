cd dotfiles 
# Link tmux conf to home directory
stow -t ~ tmux

# Clone TPM manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Source the tmux configuration
tmux source-file ~/.tmux.conf

# Install script for installing the plugins for tmux
bash ~/.tmux/plugins/tpm/scripts/install_plugins.sh
