# Enable aliases to be sudo’ed
LISTER="ls"

if command -v exa &>/dev/null; then
    LISTER="exa --icons"
    alias lt="exa -T"
    alias lt1="exa -TL1"
fi

alias sudo='sudo '

alias ..="cd .."
alias ...="cd ../.."
alias ll="$LISTER -l"
alias la="$LISTER -la"
alias l="$LISTER"
alias ~="cd ~"
alias dotfiles='cd $DOTFILES_PATH'

# Git
alias gaa="git add -A"
alias gc='$DOTLY_PATH/bin/dot git commit'
alias gca="git add --all && git commit --amend --no-edit"
alias gco="git checkout"
alias gd='$DOTLY_PATH/bin/dot git pretty-diff'
alias gs="git status -sb"
alias gf="git fetch --all -p"
alias gps="git push"
alias gpsf="git push --force"
alias gpl="git pull --rebase --autostash"
alias gb="git branch"
alias gl='$DOTLY_PATH/bin/dot git pretty-log'

# Utils
alias k='kill -9'
alias i.='(idea $PWD &>/dev/null &)'
alias c.='(code $PWD &>/dev/null &)'
alias o.='open .'
alias up='dot package update_all'

# personal

alias nv='nvim'
alias rgr='ranger'
alias clear="clear && printf '\e[3J'"
