# Path to the oh-my-zsh installation.
export ZSH=/home/stefan/.oh-my-zsh

# The theme
ZSH_THEME="spaceship"
DEFAULT_USER=stefan

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(git command-not-found aterminal common-aliases django npm node pip python yarn ng zsh-autosuggestions)

# Functions
function lazygit() {
    git add .
    git commit -a -m "$1"
    git push
}

# Aliases
alias vimrc="vim ~/.vimrc"
alias PATH='echo $PATH | tr ":" "\n" | nl | sort'
alias up='sudo apt -y update && sudo apt-get upgrade -y && sudo apt-get autoremove -y'
alias z='vim /home/stefan/.zshrc'
alias r='ranger'
alias wifi='nmtui'
alias r='ranger'
alias z='vim /home/stefan/.zshrc'
alias v='vim ~/.vimrc'
alias sz='source ~/.zshrc'
alias sv='source ~/.vimrc'

# NPM global path
NPM_CONFIG_PREFIX=~/.npm-global
export PATH=$PATH:/home/stefan/.npm-global/bin          # NPM package path

# Autocomplete color
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=7'

# Preferred editor
export EDITOR='vim'
export ECTO_EDITOR=$EDITOR

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh
source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
