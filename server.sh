#!/bin/sh

sudo apt -y update
sudo apt -y upgrade

sudo apt -y install fonts-powerline git zsh wget vim

# ZSH
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chsh -s `which zsh`

# Node
curl -sL https://deb.nodesource.com/setup_9.x | sudo -E bash -
sudo apt -y install nodejs
sudo apt-get install -y build-essential

# Spaceship theme
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

# Vim
# Getting my config file
$(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/dotfiles/.vimrc -O ~/.vimrc)
# Create the required directories
mkdir -p "~/.vim" "~/.vim/autoload" "~/.vim/bundle" "~/.vim/colors"
# Install all plugins
yes "" | vim +PlugInstall +qall
cp "~/.vim/bundle/onedark.vim/autoload/onedark.vim" "~/.vim/autoload/"
cp "~/.vim/bundle/onedark.vim/colors/onedark.vim" "~/.vim/colors/"
# Autoformat tools
sudo apt -y install astyle # Source code indenter for C, C++, Objective-C, C#, and Java
sudo apt -y install python-autopep8 # Python formatter
sudo pip3 install yapf
sudo npm install -g js-beautify
sudo npm install -g typescript-formatter
sudo apt -y install tidy
# Vim autocomplete
cd "~/.vim/bundle/YouCompleteMe"
./install.py
cd
# Install a patched font
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v1.2.0/SourceCodePro.zip -O fonts.zip
mkdir ~/.fonts
unzip fonts.zip -d ~/.fonts
fc-cache -f -v

sudo reboot now
