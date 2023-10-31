#!/bin/bash

# Get script path
script_path="$(dirname "$(readlink -f "$0")")"

# Archivo JSON que contiene la lista de emojis
#emoji_file="$script_path/emojis.json"

# Leer la lista de emojis desde el archivo JSON usando jq
#emojis=("$(jq -r '.[] | .emoji + ":" + .description + ":" + .category + ":" + (.tags | join(",")) + ":" + (.aliases | join(","))' "$emoji_file")")

# Generar la cadena de búsqueda usando Rofi
#selected_emoji=$(printf "%s\n" "${emojis[@]}" | rofi -dmenu -i -p "Selecciona un emoji:" | awk -F ':' '{print $1}')

#rofi -modi yy:./y1.sh -show yy
#selected_emoji=$(rofi -modi Emojis:$script_path/emojis/selector.sh -show Emojis )
#


# # Copiar el emoji seleccionado y su información adicional al portapapeles usando xclip
# if [ -n "$selected_emoji" ]; then
#     echo -n "$selected_emoji" | xclip -selection clipboard
#     # Buscar información adicional del emoji seleccionado
#     emoji_info=$(printf "%s\n" "${emojis[@]}" | grep "$selected_emoji")
#     echo "Emoji seleccionado \"$selected_emoji\" copiado al portapapeles."
#     echo "Información adicional: $emoji_info"
#     xdotool type --clearmodifiers "$selected_emoji"
# else
#     echo "Ningún emoji seleccionado."
# fi

rofi -modi Emojis:$script_path/emojis/selector.sh,Gitmojis:$script_path/gitmojis/selector.sh -show Emojis
