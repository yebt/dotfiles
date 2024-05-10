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

#
alias lzg='lazygit'
alias lzd='lazydocker'
alias c='code .'

# 
alias pdown="podman-compose down"
alias pup="podman-compose up -d"

# git
# #########################
typeset -g _git_log_fuller_format='%C(bold yellow)commit %H%C(auto)%d%n%C(bold)Author: %C(blue)%an <%ae> %C(reset)%C(cyan)%ai (%ar)%n%C(bold)Commit: %C(blue)%cn <%ce> %C(reset)%C(cyan)%ci (%cr)%C(reset)%n%+B'
typeset -g _git_log_oneline_format='%C(bold yellow)%h%C(reset) %s%C(auto)%d%C(reset)'
typeset -g _git_log_oneline_medium_format='%C(bold yellow)%h%C(reset) %<(50,trunc)%s %C(bold blue)%an %C(reset)%C(cyan)%as (%ar)%C(auto)%d%C(reset)'
local gmodule_home=${0:A:h}

local gprefix
zstyle -s ':zim:git' aliases-prefix 'gprefix' || gprefix=G

alias ${gprefix}l='git log --topo-order --pretty=format:"${_git_log_fuller_format}"'
alias ${gprefix}ls='git log --topo-order --stat --pretty=format:"${_git_log_fuller_format}"'
alias ${gprefix}ld='git log --topo-order --stat --patch --pretty=format:"${_git_log_fuller_format}"'
alias ${gprefix}lf='git log --topo-order --stat --patch --follow --pretty=format:"${_git_log_fuller_format}"'
alias ${gprefix}lo='git log --topo-order --pretty=format:"${_git_log_oneline_format}"'
alias ${gprefix}lO='git log --topo-order --pretty=format:"${_git_log_oneline_medium_format}"'
alias ${gprefix}lg='git log --graph --pretty=format:"${_git_log_oneline_format}"'
alias ${gprefix}lG='git log --graph --pretty=format:"${_git_log_oneline_medium_format}"'
alias ${gprefix}lv='git log --topo-order --show-signature --pretty=format:"${_git_log_fuller_format}"'
alias ${gprefix}lc='git shortlog --summary --numbered'
alias ${gprefix}lr='git reflog'

unset gmodule_home gprefix

# #########################
