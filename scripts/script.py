#! /usr/bin/env python3

"""
Requires
python3-dialog
python-apt
"""
import locale
import os
import sys
import urllib.request
from collections import namedtuple
from enum import Enum
from subprocess import call
from os import path, getcwd, chdir
from os.path import expanduser
import getpass

import apt
from dialog import Dialog

from spinner import Spinner


class How(Enum):
    APT = 1
    SNAP = 2
    NPM = 3
    MANUAL = 4

HOME = expanduser("~")
USER = getpass.getuser()
ROOT = getcwd()
# ZSHRC =
# "https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/dotfiles/.zshrc"
ZSHRC = ROOT + "/dotfiles/.zshrc"
# VIMRC =
# "https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/dotfiles/.vimrc"
VIMRC = ROOT + "/dotfiles/.vimrc"
# VSCODE_CONFIG =
# "https://raw.githubusercontent.com/StefanPahlplatz/settings-and-stuff/master/dotfiles/settings.json"
VSCODE_CONFIG = ROOT + "/dotfiles/settings.json"


d = Dialog(dialog="dialog", autowidgetsize=True)
d.set_background_title("StefanPahlplatz's Ubuntu Installer")
locale.setlocale(locale.LC_ALL, '')
Program = namedtuple('Program', ['name', 'how'])


def clear():
    os.system('clear')


def quit():
    clear()
    sys.exit()


def ask_checklist(question, choices):
    code, options = d.checklist(
        question, choices=[(x.name, "", False) for x in choices])
    check_code(code)
    return options


def check_code(code):
    if code != d.OK:
        if d.yesno("Are you sure you want to quit? All your settings will be lost.") == d.OK:
            quit()


def split(text):
    return text.split(' ')


d.msgbox(
    "Welcome\n\nThis script will guide you through installing all the basic software you would normally do yourself.")

"""
Programming languages menu
"""
prog_lang = {
    'golang-go': Program('Go', How.APT),
    'nodejs npm': Program('Node & NPM', How.APT),
    'rustc': Program('Rust', How.APT),
    'default-jdk': Program('Java', How.APT),
}
prog_lang_choices = ask_checklist(
    "Let's start with your programming languages", prog_lang.values())

"""
Programming tools menu
"""
prog_tools = {
    'vim': Program('Vim', How.APT),
    'vscode': Program('VS Code', How.SNAP),
    'pipenv': Program('Pipenv', How.MANUAL),
    'virtualenv': Program('Virtualenv', How.MANUAL),
    'yarn': Program('Yarn', How.APT),
}
prog_tools_choices = ask_checklist(
    "Select your programming tools.", prog_tools.values())

"""
Programs
"""
programs = {
    'software-properties-common python-software-properties curl wget htop fortune dconf-cli curl build-essential cmake python-dev python3-dev snapd gparted linux-headers-generic ranger xclip': Program('Common libraries & programs (recommended)', How.APT),
    'gimp': Program('Gimp', How.APT),
    'spotify': Program('Spotify', How.SNAP),
    'filezilla': Program('Filezilla', How.APT),
    'virtualbox virtualbox-guest-additions-iso': Program('Virtualbox', How.APT),
    'chrome': Program('Chrome', How.MANUAL),
    'firefox': Program('Firefox', How.APT),
    'livedown': Program('Livedown (Markdown server)', How.NPM),
    'ncdu': Program('NCDU', How.APT),
    'pulseaudio-bluetooth': Program('PulseAudio Bluetooth', How.APT),
    'blender': Program('Blender', How.APT),
}
program_choices = ask_checklist("Select your programs.", programs.values())

"""
Shell
"""
shells = {
    'zsh': Program('ZSH', How.APT),
    'fish': Program('Fish', How.APT)
}
shell_choices = ask_checklist(
    "Select which shells you want to install", shells.values())

try:
    shell = shell_choices[0].lower()
    if len(shell_choices) > 1:
        code, main_shell = d.menu("Select your main shell", choices=[
                                  (str(ind), program) for ind, program in enumerate(shell_choices)])
        check_code(code)
        if main_shell == 0:
            shell = 'zsh'
        elif main_shell == 1:
            shell = 'fish'
except IndexError:
    pass

"""
Fonts
"""
fonts = {
    'fonts-powerline': Program('Powerline fonts', How.APT),
    'restricted-extras': Program('Ubuntu restricted extras', How.MANUAL),
}
# PROG_FONT = "Programming fonts"
# EXTRAS = "Ubuntu extras (Microsoft fonts)"
# font_choices = ask_checklist("Select your fonts", [POWERLINE, PROG_FONT,
# EXTRAS])

d.msgbox("The script will now install all the programs. Sit back and relax.")
clear()

spinner = Spinner("Updating system")
spinner.start()
cache = apt.cache.Cache()
cache.update()
cache = apt.cache.Cache()
spinner.stop()

spinner.set_text("Upgrading system")
spinner.start()
cache.upgrade()
spinner.stop()

all_choices = prog_lang_choices + \
    prog_tools_choices + program_choices + shell_choices
all_programs = {**prog_lang, **prog_tools, **programs, **shells, **fonts}
snap_list = []
npm_list = []
manual_list = []
errors = []

for installation_name, program in all_programs.items():
    for program_name in all_choices:
        if program.name == program_name:
            if program.how == How.APT:
                try:
                    p = installation_name.split()
                    for i in p:
                        cache[i].mark_install()
                except KeyError:
                    errors.append("- Couldn't install {}".format(program_name))
            elif program.how == How.SNAP:
                snap_list.append(installation_name)
            elif program.how == How.NPM:
                npm_list.append(installation_name)
            elif program.how == How.MANUAL:
                manual_list.append(installation_name)
            else:
                raise NotImplementedError(
                    "Don't know how to implement" + str(program.how))

spinner.set_text("Installing applications with APT")
spinner.start()
cache.commit()
spinner.stop()

if snap_list:
    spinner.set_text("Installing applications with snap")
    spinner.start()
    command = ["snap", "install", "--classic", ''.join(snap_list)]
    call(command)
    spinner.stop()

if npm_list:
    spinner.set_text("Installing applications with NPM")
    spinner.start()
    command = ["npm", "install", "-g" ''.join(npm_list)]
    call(command)
    spinner.stop()

if manual_list:
    spinner.set_text("Running manual install scripts")
    spinner.start()
    for program in manual_list:
        if program == "pipenv":
            call(split("sudo add-apt-repository ppa:pypa/ppa -y"))
            call(split("sudo apt update"))
            call(split("sudo apt-get -y install pipenv"))
        elif program == "virtualenv":
            call(split("sudo apt-get -y install python3-pip"))
            call(split("pip3 install virtualenv"))
        elif program == "chrome":
            call(
                split("wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"))
            call(split("sudo dpkg -i google-chrome-stable_current_amd64.deb"))
            try:
                os.remove('google-chrome-stable_current_amd64.deb')
            except OSError:
                pass
        elif program == 'restricted-extras':
            call(split('sudo apt install ubuntu-restricted-extras -y'))
        else:
            print(
                "Installation for {} not yet implemented. If you think this is an error please create an issue on \
                https://github.com/StefanPahlplatz/settings-and-stuff".format(
                    program))
    spinner.stop()

print("Post install script")
if 'Fish' in all_choices:
    os.system("curl -L https://get.oh-my.fish | fish")
    os.system("omf install https://github.com/jhillyerd/plugin-git")

if 'ZSH' in all_choices:
    call(split("sudo apt -y install git wget"))

    # Install oh-my-zsh
    call(
        ["sh", "-c", '"$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"'])

    # Install zsh-autosuggestions
    call(
        split("git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions"))
    call(split("sudo apt -y install zsh-syntax-highlighting"))

    # Replace stefan with the current user
    with open(ZSHRC, "rt") as fin:
        with open("zsh", "wt") as fout:
            for line in fin:
                fout.write(line.replace('stefan', USER))
    os.rename('zsh', HOME + '/.zshrc')

    # Terminal color scheme
    url.retrieve('https://git.io/vQgMr', 'gogh')
    call(split("chmod +x gogh"))
    os.system(
        "wget -O gogh https://git.io/vQgMr && chmod +x gogh && echo 03 37 96 135 | ./gogh && rm gogh")

    # ZSH Theme
    os.system(
        'git clone https://github.com/denysdovhan/spaceship-prompt.git ~/.oh-my-zsh/custom/themes/spaceship-prompt')
    os.system(
        'ln -s ~/oh-my-zsh/custom/themes/spaceship-prompt/spaceship.zsh-theme ~/.oh-my-zsh/custom/themes/spaceship.zsh-theme')

if 'Vim' in all_choices:
    script = ROOT + "/scripts/vim-install.sh"
    call(["chmod", "+x", script])
    call(["sh", script])

if errors:
    d.msgbox(
        "The script encountered the following errors:\n\n{}".format("\n".join(errors)))
d.msgbox("Done! Log out to apply all changes.")
quit()
