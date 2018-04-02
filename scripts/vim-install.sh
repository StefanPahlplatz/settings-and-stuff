# Getting my config file
$(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/dotfiles/.vimrc -O ~/.vimrc)
# Create the required directories
mkdir -p "$HOME/.vim" "$HOME/.vim/autoload" "$HOME/.vim/bundle" "$HOME/.vim/colors"
# Install all plugins
yes "" | vim +PlugInstall +qall
cp "$HOME/.vim/bundle/onedark.vim/autoload/onedark.vim" "$HOME/.vim/autoload/"
cp "$HOME/.vim/bundle/onedark.vim/colors/onedark.vim" "$HOME/.vim/colors/"
# Autoformat tools
sudo apt install -y astyle # Source code indenter for C, C++, Objective-C, C#, and Java
sudo apt-get -y install python-autopep8 # Python formatter
sudo pip3 install yapf
npm install -g js-beautify
npm install -g typescript-formatter
sudo apt-get -y install tidy
# Vim autocomplete
cd "$HOME/.vim/bundle/YouCompleteMe"
./install.py
