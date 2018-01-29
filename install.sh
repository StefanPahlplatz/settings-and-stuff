#!/bin/bash

RCol='\e[0m'    # Text Reset

# Regular           Bold                Underline           High Intensity      BoldHigh Intens     Background          High Intensity Backgrounds
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';
echo -e "${Gre}[ ${RCol}01 ${Gre}] ${RCol}Updating system"
{
    sudo apt-get update && sudo apt-get -y upgrade
    sudo add-apt-repository ppa:daniruiz/flat-remix
} 

echo -e "${Gre}[ ${RCol}02 ${Gre}] ${RCol}Installing applications"
{
	sudo apt-get update
	sudo apt-get -y install vim zsh git fortune dconf-cli curl build-essential cmake python-dev python3-dev flat-remix-gnome arc-theme
	sudo apt-get install ubuntu-wallpapers-karmic ubuntu-wallpapers-lucid ubuntu-wallpapers-maverick ubuntu-wallpapers-natty ubuntu-wallpapers-oneiric ubuntu-wallpapers-precise ubuntu-wallpapers-quantal ubuntu-wallpapers-raring ubuntu-wallpapers-saucy
} 

echo -e "${Gre}[ ${RCol}03 ${Gre}] ${RCol}Installing nodejs"
{
    curl -sL https://deb.nodesource.com/setup_8.x -o nodesource_setup.sh
    yes "" | sudo bash nodesource_setup.sh
    sudo apt-get -y install nodejs 
}

echo -e "${Gre}[ ${RCol}04 ${Gre}] ${RCol}Fixing npm permissions"
{
	addnpmglobal=false
	if npm config get prefix | grep /usr/local; then
		sudo mkdir /usr/local/lib/node_modules
		sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}
	elif npm config get prefix | grep /usr; then
		mkdir ~/.npm-global
		npm config set prefix '~/.npm-global'
	fi
} 

echo -e "${Gre}[ ${RCol}05 ${Gre}] ${RCol}Installing oh-my-zsh"
{
	sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" 
} 

echo -e "${Gre}[ ${RCol}06 ${Gre}] ${RCol}Install powerline fonts"
{
	file="~/.local/share/fonts/Meslo LG S DZ Regular for Powerline.ttf"
	if [ -f "$file"]
	then
		git clone https://github.com/powerline/fonts.git --depth=1
		cd fonts
		./install.sh
		cd ..
		rm -rf fonts
	fi
} 

echo -e "${Gre}[ ${RCol}07 ${Gre}] ${RCol}Setup my zsh config"
{
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git .zsh-syntax-highlighting

	git clone git://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/plugins/zsh-autosuggestions

	$(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/files/.zshrc -O ~/.zshrc)
	sed -i 's/stefan/'$USER'/g' ~/.zshrc

	if [ "$addnpmglobal" = true ]; then
		echo "NPM_CONFIG_PREFIX=~/.npm-global" >> ~/.zshrc
		source ~/.zshrc
	fi
} 

echo -e "${Gre}[ ${RCol}08 ${Gre}] ${RCol}Installing cowsay"
{
	npm install -g cowsay 
}

echo -e "${Gre}[ ${RCol}09 ${Gre}] ${RCol}Installing gogh"
{
	wget -O gogh https://git.io/vQgMr && chmod +x gogh && echo 03 | ./gogh && rm gogh
} 

echo -e "${Gre}[ ${RCol}10 ${Gre}] ${RCol}Setting the terminal font"
{
	id=$(dconf list /org/gnome/terminal/legacy/profiles:/ | sed -n '1p')
	dconf write /org/gnome/terminal/legacy/profiles:/+$id+/font "'Meslo LG S DZ for Powerline Regular 12'"
} 

echo -e "${Gre}[ ${RCol}11 ${Gre}] ${RCol}Fixing zsh permissions"
{
	cd /usr/local/share/zsh
	sudo chmod -R 755 ./site-functions
	cd
}

echo -e "${Gre}[ ${RCol}12 ${Gre}] ${RCol}Downloading vim config"
{
	$(wget https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/files/.vimrc -O ~/.vimrc)
} 

echo -e "${Gre}[ ${RCol}13 ${Gre}] ${RCol}Setting up vim (this might take a while)"
{
	mkdir -p ~/.vim ~/.vim/autoload ~/.vim/bundle ~/.vim/colors
	yes "" | vim +PlugInstall +qall
	cp ~/.vim/bundle/onedark.vim/autoload/onedark.vim ~/.vim/autoload/
	cp ~/.vim/bundle/onedark.vim/colors/onedark.vim ~/.vim/colors/
	
	cd ~/.vim/bundle/YouCompleteMe
	./install.py
}

echo -e "${Gre}[ ${RCol}14 ${Gre}] ${RCol}Cleaning up"
sudo apt autoremove -y 

echo -e "${Gre}[ ${RCol}15 ${Gre}] ${RCol}Making zsh the default shell"
chsh -s $(which zsh)

echo -e "\n${BIGre}[ ${RCol}Done ${BIGre}] ${BIGre}Please log out to see all the changes in effect"
