# My configurations
export FZF_BASE=/usr/bin/fzf

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git
       	 zsh-syntax-highlighting
         zsh-autosuggestions
         fzf
	 zsh-bat
	 you-should-use
        )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

_z_cd() {
    cd "$@" || return "$?"

    if [ "$_ZO_ECHO" = "1" ]; then
        echo "$PWD"
    fi
}

z() {
    if [ "$#" -eq 0 ]; then
        _z_cd ~
    elif [ "$#" -eq 1 ] && [ "$1" = '-' ]; then
        if [ -n "$OLDPWD" ]; then
            _z_cd "$OLDPWD"
        else
            echo 'zoxide: $OLDPWD is not set'
            return 1
        fi
    else
        _zoxide_result="$(zoxide query -- "$@")" && _z_cd "$_zoxide_result"
    fi
}

zi() {
    _zoxide_result="$(zoxide query -i -- "$@")" && _z_cd "$_zoxide_result"
}


alias za='zoxide add'

alias zq='zoxide query'
alias zqi='zoxide query -i'

alias zr='zoxide remove'
zri() {
    _zoxide_result="$(zoxide query -i -- "$@")" && zoxide remove "$_zoxide_result"
}


_zoxide_hook() {
    zoxide add "$(pwd -L)"
}

chpwd_functions=(${chpwd_functions[@]} "_zoxide_hook")

# This allows for preservation of scrollback in tmux sessions control l also works
alias clear="clear -x"


#!/bin/bash

echo "Starting SSH key loading script"

# Function to start SSH agent
start_ssh_agent() {
    echo "Starting SSH agent..."
    eval $(ssh-agent -s)
    if [ $? -ne 0 ]; then
        echo "Failed to start SSH agent."
        exit 1
    fi
    echo "SSH agent started successfully."
    echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
    echo "SSH_AGENT_PID=$SSH_AGENT_PID"
}

# Check if SSH agent is already running
if [ -z "$SSH_AUTH_SOCK" ] || [ -z "$SSH_AGENT_PID" ]; then
    start_ssh_agent
else
    # Check if the agent is actually responsive
    ssh-add -l &>/dev/null
    if [ $? -eq 2 ]; then
        echo "Existing SSH agent is not responsive. Starting a new one."
        start_ssh_agent
    else
        echo "SSH agent is already running."
        echo "SSH_AUTH_SOCK=$SSH_AUTH_SOCK"
        echo "SSH_AGENT_PID=$SSH_AGENT_PID"
    fi
fi

# Add all private keys in the .ssh directory
echo "Searching for SSH keys in ~/.ssh/"
for key in ~/.ssh/id_* ~/.ssh/identity; do
    if [[ -f "$key" && "$key" != *.pub ]]; then
        echo "Checking key: $key"
        
        # Check file permissions
        if [[ "$(stat -c %a "$key")" != "600" ]]; then
            echo "Warning: Incorrect permissions on $key. Fixing..."
            chmod 600 "$key"
        fi
        
        # Try to add the key
        echo "Attempting to add key: $key"
        ssh-add "$key" < /dev/tty
        if [ $? -eq 0 ]; then
            echo "Successfully added $key"
        else
            echo "Failed to add $key. It might be in an unsupported format or you cancelled the passphrase entry."
        fi
    fi
done

echo "Script completed. Listing added keys:"
ssh-add -l

alias audiobook_usage="grep -h 'User' /home/steini/docker/audiobookshelf/metadata/logs/daily/* | grep -v 'steini'  | sed 's/.*User/User/' | uniq"
alias sync_fnp="rsync -avh /mnt/fenrir_mnt/fnp/movies /mnt/varpa_mnt/backup"
alias sync_myanonamous="rsync -avh /mnt/fenrir_mnt/myanonamouse /mnt/varpa_mnt/backup"

alias nvim="/usr/local/bin/nvim"
