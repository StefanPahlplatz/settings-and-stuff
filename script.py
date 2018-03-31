#! /usr/bin/env python3

import locale
import os
import sys
from collections import namedtuple
from enum import Enum
from subprocess import call

import apt
from dialog import Dialog


class How(Enum):
    SCRIPT = 1
    APT = 2
    SNAP = 3
    NPM = 4
    MANUAL = 5


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
    code, options = d.checklist(question, choices=[(x.name, "", False) for x in choices])
    check_code(code)
    return options


def check_code(code):
    if code != d.OK:
        if d.yesno("Are you sure you want to quit? All your settings will be lost.") == d.OK:
            quit()


d.msgbox(
    "Welcome\n\nThis script will guide you through installing all the basic software you would normally do yourself.")

"""
Programming languages menu
"""
prog_lang = {
    'go': Program('Go', How.APT),
    'nodejs npm': Program('Node & NPM', How.APT),
    'rustc': Program('Rust', How.APT),
    'default-jdk': Program('Java', How.APT),
    'hello': Program('Hello', How.SNAP),
}
prog_lang_choices = ask_checklist("Let's start with your programming languages", prog_lang.values())

"""
Programming tools menu
"""
prog_tools = {
    'vim': Program('Vim', How.APT),
    'vscode': Program('VS Code', How.SNAP),
    'pipenv': Program('Pipenv', How.MANUAL),
    'virtualenv': Program('Virtualenv', How.MANUAL),
}
prog_tools_choices = ask_checklist("Select your programming tools.", prog_tools.values())

"""
Programs
"""
programs = {
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
    'zsh': Program('ZSH', How.MANUAL),
    'fish': Program('FISH', How.MANUAL)
}
shell_choices = ask_checklist("Select your shell", shells.values())

"""
Fonts
"""
# POWERLINE = "Powerline fonts"
# PROG_FONT = "Programming fonts"
# EXTRAS = "Ubuntu extras (Microsoft fonts)"
# font_choices = ask_checklist("Select your fonts", [POWERLINE, PROG_FONT, EXTRAS])

d.msgbox("The script will now install all the programs. Sit back and relax.")
clear()

print("Updating system")
cache = apt.cache.Cache()
cache.update()
cache = apt.cache.Cache()

print("Upgrading system")
cache.upgrade()

all_choices = prog_lang_choices + prog_tools_choices + program_choices + shell_choices
all_programs = {**prog_lang, **prog_tools, **programs, **shells}
snap_list = []
npm_list = []

for installation_name, program in all_programs.items():
    for program_name in all_choices:
        if program.name == program_name:
            if program.how == How.APT:
                cache[installation_name].mark_install()
            elif program.how == How.SNAP:
                snap_list.append(installation_name)
            elif program.how == How.NPM:
                npm_list.append(installation_name)
            else:
                continue

print("Installing applications with apt")
cache.commit()

print("Installing applications with snap")
command = ["snap", "install", ''.join(snap_list)]
call(command)
