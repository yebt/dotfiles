#!/bin/bash

# -------------------------------

FG_BLACK="\033[30m"
FG_RED="\033[31m"
FG_GREEN="\033[32m"
FG_YELLOW="\033[33m"
FG_BLUE="\033[34m"
FG_MAGENTA="\033[35m"
FG_CYAN="\033[36m"
FG_WHITE="\033[37m"

BG_BLACK="\033[40m"
BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"
BG_BLUE="\033[44m"
BG_MAGENTA="\033[45m"
BG_CYAN="\033[46m"
BG_WHITE="\033[46m"

FS_BOLD="\033[1m"
FS_DIM="\033[2m"
FS_ITALIC="\033[3m"
FS_UNDERLINE="\033[4m"
FS_INVERT="\033[7m"
FS_STRIKETHROUGH="\033[9m"

F_RESET="\033[0m"

# -------------------------------
title() {
    echo -e "# ${FS_BOLD}${FG_WHITE}${1}${F_RESET}"
}
stitle() {
    echo -e "${FS_BOLD}${FS_ITALIC}${FG_BLUE}${1}${F_RESET}"
}
dim(){
    echo -e "${FS_ITALIC}${FS_DIM}${1}${F_RESET}"
}
option() {
    echo -e "${FS_ITALIC}${FG_CYAN}${1}${F_RESET}"
}

alert() {
    icon=$1
    color=$2
    message=$3
    bg_color_p="BG_${color}"
    bg_color="${!bg_color_p}"
    fg_color_p="FG_${color}"
    fg_color="${!fg_color_p}"
    echo -e " ${bg_color}${FS_BOLD}[${icon}]${F_RESET} ${FS_BOLD}${fg_color}${message}${F_RESET}"
}
success() {
    alert "OK" "GREEN" "$1"
}

error() {
    alert "X" "RED" "$1"
}
warning() {
    alert "!" "YELLOW" "$1"
}
inf() {
    alert "i" "BLUE" "$1"
}
mag(){
    alert "-" "MAGENTA" "$1"
}

# -------------------------------

ALLOW_COMMIT_TYPES=(
    "feat:introduces a new feature to the codebase:Minor"
    "fix:patches a bug in your codebase:Patch"
    "build:changes that affect the build system or external dependencies:Patch"
    "chore:routine tasks or updates that don't modify src or test files:Patch"
    "ci:changes to our CI configuration files and scripts:Patch"
    "docs:changes only affecting documentation:Patch"
    "perf:improvements that increase performance:Patch"
    "refactor:code changes that neither fix a bug nor add a feature:Patch"
    "revert:reverts a previous commit:Patch"
    "style:changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc):Patch"
    "test:adding or correcting tests:Patch"
)

# -------------------------------

CT=""
CONTEXT=""
CONTEXT_SUFIX=""
DESCRIPTION=""
BODY=""
FOOTER=""

# -------------------------------

# Manejar SIGINT (Ctrl-C)
trap 'exit 130' SIGINT

# -------------------------------

# TRIM
trim() {
    # Esta función recorta los espacios al principio y al final de la cadena
    local var="$1"
    var="${var#"${var%%[![:space:]]*}"}"   # quitar espacios iniciales
    var="${var%"${var##*[![:space:]]}"}"   # quitar espacios finales
    echo -n "$var"
}

# Commit Type
select_commit_type() {


    # Función para formatear la salida para fzf
    format_for_fzf() {
        for i in "${ALLOW_COMMIT_TYPES[@]}"; do
            commit_type=${i%%:*}
            rest=${i#*:}
            description=${rest%%:*}
            version="${rest##*:}"
            printf '%s\t%s\t%s\n' "$commit_type" "$description" "$version"
        done
    }

    # Ejecuta fzf con las opciones formateadas
    selected=$(format_for_fzf | fzf --height 50% --with-nth=1 --delimiter='\t' --preview="echo -e \"{2}${FS_BOLD}\n{3}\"" --preview-window=right:50%:wrap --header="Select Commit Type")

    # Comprobar si fzf fue cancelado
    catch_cc

    # Extrae el tipo de commit seleccionado
    selected_commit_type=$(echo "$selected" | cut -f1)

    CT=$selected_commit_type
    if [ -n "$CT" ]; then
        success $CT
        dim  " > $(echo "$selected" | cut -f2)"
        option  " > $(echo "$selected" | cut -f3)"
    fi
}

# BYE
bye(){
    if [ -z "$CT" ]; then
        echo ">Bye"
    fi
}

# Catch ctr-c cancel
catch_cc(){
    # Comprobar si fzf fue cancelado
    if [ $? -eq 130 ]; then
        exit 130
    fi
}

# -------------------------------

stitle "# Commit type"
select_commit_type

stitle "# Introducing BREAKING CHANGES?"
read -p "$(dim ' > y/n [n] ')" -n 1 -r

catch_cc

[ -n "$REPLY" ] && echo

if [[ $REPLY =~ ^[Yy]$ ]]
then
    FOOTER='BREAKING CHANGES'
    CONTEXT_SUFIX='!'
    #echo " Write beraking changes: "
    read -p "$(dim ' > Write beraking changes: ')"  FOOTER
    #FOOTER="$FOOTER: $REPLY"
    if [ -n "$FOOTER" ]
    then
        FOOTER="BREAKING CHANGE: $FOOTER"
    fi
fi

stitle "# Scope (optional)"
read -p "$(dim ' > ')" CONTEXT
if [ -n "$CONTEXT" ]
then
    CONTEXT="($CONTEXT)$CONTEXT_SUFIX"
fi

while [[ -z $(trim "$DESCRIPTION") ]]; do
    stitle "# Description:"
    read -p "$(dim ' > ')" DESCRIPTION
    [ -z "$DESCRIPTION" ] && error "Description required"
    # if [ -z "$DESCRIPTION" ]; then
    #      error "Description required"
    # fi
done


stitle "# Body (optional)"
read -p "$(dim ' > ')" BODY
if [ -n "$BODY" ]
then
    BODY="\n\n$BODY\n"
fi

if [ -n "$FOOTER" ]
then
    FOOTER="\n$FOOTER\n"
fi

COMMIT_FORMAT="$CT$CONTEXT: $DESCRIPTION$BODY$FOOTER"

git commit -m "$(echo -e "$COMMIT_FORMAT" )"
