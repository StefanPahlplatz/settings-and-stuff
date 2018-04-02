#!/bin/bash
blue() { printf "\n\033[0;34m $* \033[0m\n\n" && (echo $* >> /tmp/pahlplatz.log) ;}
red() { printf "\n\033[0;31m $* \033[0m\n\n" && (echo ERROR: $* >> /tmp/pahlplatz.log) ;}

quit() {
        rm /tmp/.choices
        clear
        exit
}

check_quit() {
        # If cancelled, drop the dialog
        if [ $? -ne 0 ]; then
                quit
        fi;
}

echo "Installer started $(date)" >> /tmp/pahlplatz.log
chmod 777 /tmp/pahlplatz.log

# Install the dialog package
sudo apt-get install -y dialog

# Welcome dialog
dialog --title 'Welcome' --msgbox 'This installer will guide you through installing all the basic programs you will need.' 10 30

# Store the home and user
name=$(echo $USER)
home=$(eval echo "~$name")

# Programming languages
cmd=(dialog --separate-output --checklist "Select your programming languages" 22 76 16)
options=(
"node" "Node 9.x & npm" on
"go" "Golang" off
"rust" "Rust" off
"java" "Java JDK" off
)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
check_quit

# Programming tools
cmd=(dialog --separate-output --checklist "Select your programming tools" 22 76 16)
options=(
"pipenv" "Pipenv" off
"virtualenv" "Virtualenv" off
"yarn" "Yarn" off
)
choices="$choices $("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)"
check_quit

# Editors
cmd=(dialog --separate-output --checklist "Select your editors" 22 76 16)
options=(
"vim" "Vim" off
"code" "VS Code" off
"atom" "Atom" off
)
choices="$choices $("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)"
check_quit

# Programs
cmd=(dialog --separate-output --checklist "Select your programs" 22 76 16)
options=(
"reccomended" "Collection of utilities & libraries" on
"gimp" "Gimp" off
"spotify" "Spotify" off
"filezilla" "Filezilla" off
"virtualbox" "Virtualbox" off
"chrome" "Chrome" off
"firefox" "Firefox" off
"pulseaudio" "Pulseaudio" off
"blender" "Blender" off
"ncdu" "View free space on your disk" off
)
choices="$choices $("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)"
check_quit

# Shell
cmd=(dialog --radiolist "Select your shell" 22 76 16)
options=(
"zsh" "ZSH" on
"fish" "Fish" off
"default" "Default" off
)
choices="$choices $("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)"
check_quit

# Fonts
cmd=(dialog --separate-output --checklist "Select additional fonts" 22 76 16)
options=(
"powerline" "Powerline fonts" on
"extras" "Ubuntu Restricted Extras" off
)
choices="$choices $("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)"
check_quit

dialog --msgbox "Let's start" 6 18
clear

# Update system
sudo apt -y update && sudo apt -y upgrade

# Install required applications
for i in curl wget git cmake snapd; do
        sudo apt-get -y install $i
done

for choice in $choices
do
        case $choice in
                vim)
                        sudo apt -y install vim
                        ;;
                node)
                        curl -sL https://deb.nodesource.com/setup_9.x -o nodesource_setup.sh
                        yes "" | bash nodesource_setup.sh
                        sudo apt -y install nodejs
                        sudo apt -y instal npm
                        mkdir ~/.npm-global
                        npm config set prefix '~/.npm-global'
                        echo "export PATH=~/.npm-global/bin:$PATH" >> ~/.profile
                        source ~/.profile
                        ;;
                go)
                        sudo apt -y install golang-go
                        ;;
                rust)
                        sudo apt -y install rustc
                        ;;
                java)
                        sudo apt -y install default-jdk
                        ;;
                pipenv)
                        pip3 install pipenv
                        ;;
                virtualenv)
                        pip3 install virtualenv
                        ;;
                yarn)
                        sudo apt install -y yarn
                        ;;
                vim)
                        sudo apt install -y vim
                        # Getting my config file
                        $(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/dotfiles/.vimrc -O ~/.vimrc)
                        # Create the required directories
                        mkdir -p "$home/.vim" "$home/.vim/autoload" "$home/.vim/bundle" "$home/.vim/colors"
                        # Install all plugins
                        yes "" | vim +PlugInstall +qall
                        cp "$home/.vim/bundle/onedark.vim/autoload/onedark.vim" "$home/.vim/autoload/"
                        cp "$home/.vim/bundle/onedark.vim/colors/onedark.vim" "$home/.vim/colors/"
                        # Autoformat tools
                        sudo apt -y install astyle # Source code indenter for C, C++, Objective-C, C#, and Java
                        sudo apt -y install python-autopep8 # Python formatter
                        pip3 install yapf
                        npm install -g js-beautify
                        npm install -g typescript-formatter
                        sudo apt -y install tidy
                        # Vim autocomplete
                        cd "$home/.vim/bundle/YouCompleteMe"
                        ./install.py
                        cd
                        ;;
                code)
                        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
                        sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
                        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
                        sudo apt -y update
                        sudo apt install -y code
                        pip3 install -U autopep8
                        code --install-extension formulahendry.auto-close-tag
                        code --install-extension formulahendry.auto-rename-tag
                        code --install-extension mgmcdermott.vscode-language-babel
                        code --install-extension msjsdiag.debugger-for-chrome
                        code --install-extension EditorConfig.editorconfig
                        code --install-extension nepaul.editorconfiggenerator
                        code --install-extension dbaeumer.vscode-eslint
                        code --install-extension k--kato.intellij-idea-keybindings
                        code --install-extension Zignd.html-css-class-completion
                        code --install-extension shd101wyy.markdown-preview-enhanced
                        code --install-extension Zignd.html-css-class-completion
                        code --install-extension PKief.material-icon-theme
                        code --install-extension eg2.vscode-npm-script
                        code --install-extension christian-kohler.npm-intellisense
                        code --install-extension kumar-harsh.graphql-for-vscode
                        code --install-extension zhuangtongfa.material-theme
                        code --install-extension christian-kohler.path-intellisense
                        code --install-extension esbenp.prettier-vscode
                        code --install-extension DSKWRK.vscode-generate-getter-setter
                        code --install-extension natewallace.angular2-inline
                        code --install-extension joelday.docthis
                        code --install-extension eg2.tslint
                        code --install-extension ms-python.python
                        mkdir -p ~/.config/Code/User/settings.json
                        $(wget -q https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/dotfiles/settings.json -O $HOME/.config/Code/User/settings.json)
                        ;;
                atom)
                        sudo add-apt-repository -y ppa:webupd8team/atom
                        sudo apt -y update
                        sudo apt -y install atom
                        ;;
                reccomended)
                        for i in htop fortune dconf-cli build-essential cmake python-dev python3-dev snapd gparted linux-headers-generic ranger python3-pip xclip; do
                                sudo apt-get -y install $i
                        done
                        ;;
                gimp)
                        sudo apt -y install gimp
                        ;;
                spotify)
                        snap install spotify
                        ;;
                filezilla)
                        sudo apt -y install filezilla
                        ;;
                virtualbox )
                        sudo apt -y install virtualbox virtualbox-guest-additions-iso
                        ;;
                chrome)
                        wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
                        echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
                        sudo apt -y update
                        sudo apt -y install google-chrome-stable
                        ;;
                firefox)
                        sudo apt -y install firefox
                        ;;
                pulseaudio)
                        sudo apt -y install pulseaudio-bluetooth
                        ;;
                blender)
                        sudo apt -y install blender
                        ;;
                ncdu)
                        sudo apt -y install ncdu
                        ;;
                zsh)
                        sudo apt -y install zsh
                        chsh -s $(which zsh)
                        # Install oh-my-zsh
                        exit | sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
                        # Install zsh-syntax-highlighting
                        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
                        # Install zsh-autosuggestions
                        git clone git://github.com/zsh-users/zsh-autosuggestions "$home/.oh-my-zsh/plugins/zsh-autosuggestions"
                        # My zsh config
                        $(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/dotfiles/files/.zshrc -O "$home/.zshrc")
                        sed -i 's/stefan/'"$USER"'/g' ~/.zshrc
                        chmod -R 755 /usr/local/share/zsh/site-functions
                        # Color scheme
                        wget -O gogh https://git.io/vQgMr && chmod +x gogh && echo 03 | ./gogh && rm gogh
                        # Fix permissions
                        sudo chmod -R 755 /usr/local/share/zsh/site-functions
                        # Install ZSH Spaceship theme
                        git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
                        ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
                        ;;
                fish)
                        sudo apt -y install fish
                        curl -L https://get.oh-my.fish | fish
                        omf install https://github.com/jhillyerd/plugin-git
                        ;;
                powerline)
                        sudo apt -y install fonts-powerline
                        ;;
                extras)
                        sudo apt -y install ubuntu-restricted-extras
                        ;;
                *)
                        ;;
        esac
done

sudo apt -y update && sudo apt -y upgrade && sudo apt -y autoremove

dialog --msgbox "Done! Log out for all changes to take effect." 10 25
quit
