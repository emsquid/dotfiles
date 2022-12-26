unsetopt beep nomatch
bindkey -e

export EDITOR="nvim"
export PATH=$PATH:~/.local/bin
export STARSHIP_CONFIG=~/.config/starship/starship.toml

alias ll="ls -la --color=always"
alias grep="grep -e"

eval "$(starship init zsh)"
