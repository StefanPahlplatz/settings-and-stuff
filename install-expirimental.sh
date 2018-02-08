#!/bin/bash
blue() { printf "\n\033[0;34m $* \033[0m\n\n" && (echo $* >> /tmp/pahlplatz.log) ;}
red() { printf "\n\033[0;31m $* \033[0m\n\n" && (echo ERROR: $* >> /tmp/pahlplatz.log) ;}

echo "Installer started $(date)" >> /tmp/pahlplatz.log
chmod 777 /tmp/pahlplatz.log

if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

apt-get install -y dialog 

dialog --title 'Welcome' --msgbox 'Hey thanks for using my installer.\n -Stefan' 10 30

dialog --no-cancel --inputbox "First, please enter the name of your user account." 10 60 2> /tmp/.name
chmod 777 /tmp/.name
name=$(cat /tmp/.name)
home=$(eval echo "~$name")
shred -u /tmp/.name

cmd=(dialog --separate-output --checklist "Select additional packages to install with <SPACE>:" 22 76 16)
options=(1 "Node 9.x & npm" on
         2 "Powerline fonts" on
         3 "Vim" on
         4 "ZSH" on
         5 "Theme & icon packs" on
		 6 "Gimp" off
	 )
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
echo $choices > /tmp/.choices

dialog --title "Let's get this party started!" --msgbox "The script will now install your selected components, sit back and enjoy." 13 60

blue \[1\/99\] Installing the default stuff \(system basics\)...

apt-get update && sudo apt-get -y upgrade
apt-get -y install htop git fortune dconf-cli curl build-essential cmake python-dev python3-dev 

for choice in $choices
do
	case $choice in
		1)
			blue Now installing Node & npm...
			curl -sL https://deb.nodesource.com/setup_9.x -o nodesource_setup.sh
            yes "" | bash nodesource_setup.sh
			apt-get install -y nodejs
            ;;
		2)
            blue Now installing the powerline fonts...
            apt-get install fonts-powerline
			;; 
		3)
		    blue Now installing vim...
            apt-get install -y vim
		    $(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/files/.vimrc -O ~/.vimrc)
            mkdir -p "$home/.vim" "$home/.vim/autoload" "$home/.vim/bundle" "$home/.vim/colors"
            yes "" | vim +PlugInstall +qall
            cp "$home/.vim/bundle/onedark.vim/autoload/onedark.vim" "$home/.vim/autoload/"
            cp "$home/.vim/bundle/onedark.vim/colors/onedark.vim" "$home/.vim/colors/"
            
            cd "$home/.vim/bundle/YouCompleteMe"
            ./install.py    
            ;;
        4)
            blue Now installing zsh...
			apt-get install -y zsh
			chsh -s $(which zsh)
			sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" 
			git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$home/.zsh-syntax-highlighting"
            git clone git://github.com/zsh-users/zsh-autosuggestions "$home/.oh-my-zsh/plugins/zsh-autosuggestions"
			$(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/files/.zshrc -O "$home/.zshrc")
            chmod -R 755 /usr/local/share/zsh/site-functions
            wget -O gogh https://git.io/vQgMr && chmod +x gogh && echo 03 | ./gogh && rm gogh
            ;;
        5)
            blue Installing themes...
            add-apt-repository -y ppa:daniruiz/flat-remix
            apt-get update
            apt install flat-remix-gnome arc-themes flat-remix gnome-tweak-tool
            ;;
        6)
            apt-get install gimp
            ;;
    esac
done

apt autoremove -y 

dialog --title "Done!" --msgbox "All done, restart your system to see al changes in effect." 12 80
clear
