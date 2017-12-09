# settings-and-stuff [![Build Status](https://travis-ci.org/StefanPahlplatz/settings-and-stuff.svg?branch=master)](https://travis-ci.org/StefanPahlplatz/settings-and-stuff)

> A collection of settings for various programs and plugins. 

Install & configures some basic stuff like zsh and vim.
```
wget -O install.sh https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/install.sh
chmod +x install.sh
./install.sh
```
Press CTRL+D when zsh opens to continue the installation.

# Other stuff
For the pixel saver plugin to work properly:
```
cd ~/.local/share/gnome-shell/extensions/pixel-saver@deadalnix.me/themes
mv Ambiance Ambiance.bak
ln -s default Ambiance
```
credit to ebruck for this one.


