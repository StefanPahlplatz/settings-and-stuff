# Path to the oh-my-zsh installation.
export ZSH=/home/stefan/.oh-my-zsh


# ZSH settings
ZSH_THEME="spaceship"
DEFAULT_USER=stefan
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
ENABLE_CORRECTION="true"
DISABLE_AUTO_UPDATE="false"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'


# Plugins
plugins=(git command-not-found common-aliases zsh-autosuggestions zsh-syntax-highlighting)


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


# Aliases
alias PATH='echo $PATH | tr ":" "\n" | nl | sort'
alias up='sudo apt -y update && sudo apt-get upgrade -y && sudo apt-get autoremove -y'
alias wifi='nmtui'
alias r='ranger'
alias z='vim ~/.zshrc'
alias v='vim'
alias sz='source ~/.zshrc'
alias sv='source ~/.vimrc'
alias freespace='ncdu'


# NPM global path
NPM_CONFIG_PREFIX=~/.npm-global
export PATH=$PATH:/home/stefan/.npm-global/bin          # NPM package path


# ZSH cache
ZSH_CACHE_DIR=$HOME/.cache/oh-my-zsh
if [[ ! -d $ZSH_CACHE_DIR ]]; then
    mkdir $ZSH_CACHE_DIR
fi


# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh
