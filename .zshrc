unsetopt beep nomatch
bindkey -e

export EDITOR="nvim"
export PATH=$PATH:~/.local/bin

alias ll="ls -la --color=always"
alias grep="grep -e"

eval "$(starship init zsh)"
