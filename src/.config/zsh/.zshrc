#
# ~/.zshrc
# ~/.config/zsh/.zshrc
#
# Assuming ~/dot:
#   $ cd ~/dot/src
#   $ ln -sf .config/zsh/.zshrc .zshrc
#

# Load shell profile
source "$HOME"/.config/sh/hwk

# Load shell scripts
source "$SHELL_DIRECTORY_CONFIG"/script/welcome

# Set history
export ZDOTDIR="$XDG_CONFIG_HOME"/zsh

HISTFILE=~/.cache/zhistfile
HISTSIZE=1000
SAVEHIST=1000

# Keybinds
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down

# Tab completions
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist

compinit
_comp_options+=(globdots)

# Zoxide
eval "$(zoxide init zsh)"
alias cd="z"

# Prompt
setopt promptsubst
autoload -U colors && colors
source "$SHELL_DIRECTORY_CONFIG"/prompt/zsh

# Plugins
[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

plug "zsh-users/zsh-autosuggestions"
plug "zsh-users/zsh-history-substring-search"
plug "zsh-users/zsh-syntax-highlighting"
plug "MichaelAquilina/zsh-you-should-use"
plug "jeffreytse/zsh-vi-mode"
