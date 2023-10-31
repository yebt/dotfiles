#!/bin/bash

usage() {
    echo "Uso: $0 -m <modo> [-c]"
    echo "  -m <modo>: selection, full o app"
    echo "  -c: Copiar al portapapeles"
    exit 1
}

open_ubication(){
	#echo "$FILENAME"
	#echo $(basename $FILENAME)
	xdg-open $FILENAME &
}

notify() {
	if [ -f "$FILENAME" ]; then
		ACTION=$(dunstify  --action="default,Reply" --action="forwardAction,Forward" "Captura de pantalla" "Se ha tomado una captura de pantalla en $MODE mode. Haz clic aquí para abrir la ubicación." -a "Screenshot Script" -i "camera-photo"  )

		case "$ACTION" in
			"default")
				open_ubication
				;;
		esac

		#ACTION=$(dunstify --action="default,Reply" --action="forwardAction,Forward" "Message Received")

		# case "$ACTION" in
		# 	"default")
		# 		reply_action
		# 		;;
		# 	"forwardAction")
		# 		forward_action
		# 		;;
		# 	"2")
		# 		handle_dismiss
		# 		;;
		# esac
	fi
}

while getopts ":m:c" opt; do
    case $opt in
        m)
            MODE="$OPTARG"
            ;;
        c)
            COPY_TO_CLIPBOARD=true
            ;;
        \?)
            echo "Opción inválida: -$OPTARG" >&2
            usage
            ;;
        :)
            echo "La opción -$OPTARG requiere un argumento." >&2
            usage
            ;;
    esac
done

if [ -z "$MODE" ]; then
    echo "El modo (-m) es obligatorio."
    usage
fi

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_DIR="$HOME/Pictures/Screenshots"
FILENAME="$OUTPUT_DIR/screenshot_$TIMESTAMP.png"

case $MODE in
    selection)
        maim -s "$FILENAME"
        ;;
    full)
        maim "$FILENAME"
        ;;
    app)
        maim -i $(xdotool getactivewindow) "$FILENAME"
        ;;
    *)
        echo "Modo inválido: $MODE"
        usage
        ;;
esac

if [ "$COPY_TO_CLIPBOARD" = true ]; then
    xclip -selection clipboard -t image/png -i "$FILENAME"
fi

notify

exit 0

