# Getting my config file
$(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/files/.vimrc -O ~/.vimrc)
# Create the required directories
mkdir -p "$home/.vim" "$home/.vim/autoload" "$home/.vim/bundle" "$home/.vim/colors"
# Install all plugins
yes "" | vim +PlugInstall +qall
cp "$home/.vim/bundle/onedark.vim/autoload/onedark.vim" "$home/.vim/autoload/"
cp "$home/.vim/bundle/onedark.vim/colors/onedark.vim" "$home/.vim/colors/"
# Autoformat tools
sudo apt install -y astyle # Source code indenter for C, C++, Objective-C, C#, and Java
sudo apt-get -y install python-autopep8 # Python formatter
sudo pip3 install yapf
npm install -g js-beautify
npm install -g typescript-formatter
sudo apt-get -y install tidy
# Vim autocomplete
cd "$home/.vim/bundle/YouCompleteMe"
./install.py
