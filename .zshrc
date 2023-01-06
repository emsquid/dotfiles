HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000 

unsetopt beep nomatch
bindkey -e

alias ll="ls -la --color=always"
alias grep="grep -e"

eval "$(starship init zsh)"
