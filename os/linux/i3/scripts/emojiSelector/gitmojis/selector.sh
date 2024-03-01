#!/bin/bash

# Get script path
script_path="$(dirname "$(readlink -f "$0")")"

# Archivo JSON que contiene la lista de emojis
emoji_file="$script_path/gitmojis.json"

gitemojis=("$(jq -r '.[] | .emoji + ":" + .description + ":" + .name' "$emoji_file")")

if [ $# -ne 0 ]; then
    killall rofi
    selected_emoji=$(echo $1 | awk -F ':' '{print $1}')
    #notify-send $selected_emoji
    emoji_info=$(printf "%s\n" "${gitemojis[@]}" | grep "$selected_emoji")

    xdotool type --delay 100 "$selected_emoji"
    exit 0
fi

printf "%s\n" "${gitemojis[@]}"
