# Path to your oh-my-zsh installation.
export ZSH=/home/stefan/.oh-my-zsh

# The theme
ZSH_THEME="robbyrussell"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Manual PATH variable
export PATH="/usr/local/share/anaconda3/bin:/usr/local/go/bin:/home/stefan/.pyenv/bin:/usr/local/go/bin:/home/stefan/.pyenv/bin:usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
"

# Aliases
alias f="~/Documents/fontys"
alias datawall="~/Documents/go/src/DataWall"
alias zshconf="gvim ~/.zshrc"
