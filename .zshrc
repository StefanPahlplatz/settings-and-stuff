# Path to the oh-my-zsh installation.
export ZSH=/home/stefan/.oh-my-zsh

# The theme
ZSH_THEME="agnoster"
DEFAULT_USER=stefan

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(git command-not-found aterminal autojump chucknorris common-aliases django docker npm node pip python yarn zsh-autosuggestions)

# Aliases
alias zshconf="gvim ~/.zshrc"
alias PATH='echo $PATH | tr ":" "\n" | nl | sort'

# Activate autojump
[[ -s /home/stefan/.autojump/etc/profile.d/autojump.sh ]] && source /home/stefan/.autojump/etc/profile.d/autojump.sh

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh
