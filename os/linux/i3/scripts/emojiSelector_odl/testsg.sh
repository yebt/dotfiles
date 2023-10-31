#!/usr/bin/env bash

# vari=""
#
# if [ -n "$vari" ]; then
#     echo "vari is not null"
# else
#     echo "vari is null"
# fi

# Definir un array con las opciones del menú
opciones=("Opción 1" "Opción 2" "Opción 3" "Opción 4")

# Definir una variable para el formato de Rofi
rofi_format=""

# Construir el formato de Rofi a partir del array de opciones
for opcion in "${opciones[@]}"; do
  rofi_format="${rofi_format}${opcion}\n"
done

# Llamar a Rofi con las opciones del menú y recibir la selección del usuario
eleccion=$(echo -e "$rofi_format" | rofi -dmenu -p "Selecciona una opción:")

# Imprimir la opción seleccionada (esto es solo para fines de prueba)
echo "Opción seleccionada: '$eleccion'"

if [ -n "$eleccion" ]; then
    echo "Opción seleccionada: '$eleccion'"
else
    echo "Ninguna opción seleccionada."
fi
