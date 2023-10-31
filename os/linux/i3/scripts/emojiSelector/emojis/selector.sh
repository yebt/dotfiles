#!/bin/bash

# Get script path
script_path="$(dirname "$(readlink -f "$0")")"

# Archivo JSON que contiene la lista de emojis
emoji_file="$script_path/emojis.json"

emojis=("$(jq -r '.[] | .emoji + ":" + .description + ":" + .category + ":" + (.tags | join(",")) + ":" + (.aliases | join(","))' "$emoji_file")")

if [ $# -ne 0 ]; then
    killall rofi
    selected_emoji=$(echo $1 | awk -F ':' '{print $1}')
    emoji_info=$(printf "%s\n" "${emojis[@]}" | grep "$selected_emoji")
    echo -n "$selected_emoji" | xclip -selection clipboard
    xdotool type --clearmodifiers "$selected_emoji"
    exit 0
fi

printf "%s\n" "${emojis[@]}"
