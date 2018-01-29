# Path to the oh-my-zsh installation.
export ZSH=/home/stefan/.oh-my-zsh

# The theme
ZSH_THEME="agnoster"
DEFAULT_USER=stefan

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(git command-not-found aterminal autojump chucknorris common-aliases django docker npm node pip python yarn zsh-autosuggestions)

# Functions
function lazygit() {
    git add .
    git commit -a -m "$1"
    git push
}

# Aliases
alias zshrc="vim ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias PATH='echo $PATH | tr ":" "\n" | nl | sort'
alias up='sudo apt-get upgrade && sudo apt-get update -y && sudo apt autoremove -y'

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh
source ~/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
