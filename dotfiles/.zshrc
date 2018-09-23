# Path to the oh-my-zsh installation.
export ZSH=/home/stefan/.oh-my-zsh

bindkey '^H' backward-kill-word

# ZSH settings
ZSH_THEME="spaceship"
DEFAULT_USER=stefan
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
ENABLE_CORRECTION="false"
DISABLE_AUTO_UPDATE="false"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'


# Plugins
plugins=(git command-not-found common-aliases zsh-autosuggestions zsh-syntax-highlighting docker docker-compose)


# Settings
export UPDATE_ZSH_DAYS=14
export LANG=en_US.UTF-8
export EDITOR='vim'
export GIT_EDITOR='vim'
export ECTO_EDITOR=$EDITOR
export SSH_KEY_PATH='~/.ssh/rsa_id'


# Functions
function lazygit() {
        git add .
        git commit -a -m "$1"
        git push
}

function copy() {
        xclip -sel clip < "$1"
}

function up() {
        sudo apt update
        sudo apt upgrade
        sudo apt autoremove
        sudo apt clean
        sudo snap refresh
}

function o() {
        xdg-open "$1"
}


# Aliases
alias PATH='echo $PATH | tr ":" "\n" | nl | sort'
alias wifi='nmtui'
alias r='trash-put'
alias z='vim ~/.zshrc'
alias v='vim'
alias sz='source ~/.zshrc'
alias sv='source ~/.vimrc'
alias freespace='ncdu'
alias csc='mono-csc'
alias s='sudo systemctl'
alias py='python3'

# ZSH cache
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
        mkdir $ZSH_CACHE_DIR
fi


# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Use trash-cli instead of rm
alias rm='echo "This is not the command you are looking for. Use r instead"; false'
