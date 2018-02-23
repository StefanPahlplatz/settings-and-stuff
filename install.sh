#!/bin/bash
blue() { printf "\n\033[0;34m $* \033[0m\n\n" && (echo $* >> /tmp/pahlplatz.log) ;}
red() { printf "\n\033[0;31m $* \033[0m\n\n" && (echo ERROR: $* >> /tmp/pahlplatz.log) ;}

echo "Installer started $(date)" >> /tmp/pahlplatz.log
chmod 777 /tmp/pahlplatz.log

# Install the dialog package
sudo apt-get install -y dialog 

# Welcome dialog
dialog --title 'Welcome' --msgbox 'Hey thanks for using my installer.\n -Stefan' 10 30

# Store the home and user
name=$(echo $USER)
home=$(eval echo "~$name")

# Options
cmd=(dialog --separate-output --checklist "Select additional packages to install with <SPACE>:" 22 76 16)
options=(1 "Node 9.x & npm" on
         2 "Powerline fonts" on
         3 "Vim" on
         4 "ZSH" on
         5 "Theme & icon packs" on
		 6 "Gimp" off
         7 "Spotify" off
         8 "Virtualbox" off
         9 "Filezilla" off
         10 "Google Chrome" off
		 11 "VS Code" off
         12 "Bluetooth headset software" off
         13 "Firefox" off
         14 "Sway" off
	 )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
echo $choices > /tmp/.choices

dialog --title "Let's get this party started!" --msgbox "The script will now install your selected components, sit back and enjoy." 13 60
clear

blue Installing the default stuff \(system basics\)...

sudo apt update -y && sudo apt-get -y upgrade
sudo apt -y install htop git fortune dconf-cli curl build-essential cmake python-dev python3-dev snapd gparted linux-headers-generic ranger python3-pip xclip 

for choice in $choices
do
	case $choice in
		1)
			blue Now installing Node & npm...
			curl -sL https://deb.nodesource.com/setup_9.x -o nodesource_setup.sh
            yes "" | bash nodesource_setup.sh
            sudo apt install -y nodejs
            sudo apt install -y yarn
            ;;
		2)
            blue Now installing the powerline fonts...
            sudo apt install -y fonts-powerline
			;; 
		3)
		    blue Now installing vim...
            sudo apt install -y vim
            # Getting my config file
		    $(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/files/.vimrc -O ~/.vimrc)
            # Create the required directories
            mkdir -p "$home/.vim" "$home/.vim/autoload" "$home/.vim/bundle" "$home/.vim/colors"
            # Install all plugins
            yes "" | vim +PlugInstall +qall
            cp "$home/.vim/bundle/onedark.vim/autoload/onedark.vim" "$home/.vim/autoload/"
            cp "$home/.vim/bundle/onedark.vim/colors/onedark.vim" "$home/.vim/colors/"
            # Vim autocomplete
            cd "$home/.vim/bundle/YouCompleteMe"
            ./install.py    
            ;;
        4)
            blue Now installing zsh...
			sudo apt install -y zsh
			chsh -s $(which zsh)
            # Install oh-my-zsh
			sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" 
			git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$home/.zsh-syntax-highlighting"
            git clone git://github.com/zsh-users/zsh-autosuggestions "$home/.oh-my-zsh/plugins/zsh-autosuggestions"
            # My zsh config
			$(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/files/.zshrc -O "$home/.zshrc")
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
        5)
            blue Installing themes...
            sudo add-apt-repository -y ppa:daniruiz/flat-remix
            sudo apt update -y
            sudo apt install -y flat-remix-gnome arc-themes flat-remix gnome-tweak-tool
            ;;
        6)
            blue Installing gimp...
            sudo apt install -y gimp
            ;;
        7)
            blue Installing spotify...
            sudo snap install spotify
            ;;
        8) 
            blue Installing Virtualbox...
            sudo apt install -y virtualbox virtualbox-guest-additions-iso
            sudo adduser x vboxusers
            ;;
        9)
            blue Installing filezilla...
            sudo apt install -y filezilla
            ;;
        10)
            blue Installing chrome...
            wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
            echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
            sudo apt -y update
            sudo apt-get -y install google-chrome-stable
            ;;
        11)
            blue Installing VS Code...
            curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
            sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
            sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
			sudo apt update -y
			sudo apt install -y code
			python -m pip install -U autopep8
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
            $(wget -q https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/files/settings.json -O $HOME/.config/Code/User/settings.json)
			;;
		12)
			blue Installing headset software...
			sudo apt install -y pulseaudio-bluetooth
			;;
        13)
            blue Installing firefox...
            sudo apt install -y firefox
            ;;
        14)
            blue Installing sway...
            sudo add-apt-repository ppa:s.noack/ppa
            sudo apt -y update
            sudo apt -y install sway
            mkdir ~/.config/sway
            $(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/files/config -O "$home/.config/sway/config")
            sudo apt install -y j4-dmenu-desktop
            ;;
    esac
done

sudo apt install ubuntu-restricted-extras -y
sudo apt autoremove -y 

dialog --title "Done!" --msgbox "All done, the last step is to logout. Make sure that you set a powerline font for your terminal." 12 80
clear

blue Waiting 10 seconds and then logging out...
sleep 10
gnome-session-quit
