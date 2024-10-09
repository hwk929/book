#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# Load shell profile
source "$HOME"/.config/sh/hwk

# Load shell scripts
source "$SHELL_DIRECTORY_CONFIG"/script/welcome

# Load prompt
source "$SHELL_DIRECTORY_CONFIG"/prompt/bash

# Set history
export HISTFILE="$XDG_STATE_HOME"/bash/history
