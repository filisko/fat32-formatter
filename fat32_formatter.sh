#!/bin/bash
# FAT32 FORMATTER
#
# Copyright (C) 2017 Filis Futsarov
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

# MESSAGES
LANGUAGE=${LANG:0:2}
if [ $LANGUAGE == 'es' ]; then
    MSG_TITLE="Formatear dispositivo USB como FAT32"
    MSG_CHOOSE_DEVICE="Seleccione el dispositivo USB que desee formatear con formato FAT32"
    MSG_CHOOSE_DEVICE_ERROR="No has seleccionado ningún dispositivo USB para formatear"
    MSG_FORMAT="Formatear"
    MSG_CLOSE="Cerrar"
    MSG_MODEL="Modelo"
    MSG_LABEL="Etiqueta"
    MSG_PATH="Ruta del dispositivo"
    MSG_SIZE="Tamaño"
    MSG_CONTINUE="Continuar"
    MSG_BACK="Volver"
    MSG_FORMAT_CONFIRMATION="¿Estás seguro de que deseas formatear este dispositivo? <b>$dev</b>"
    MSG_FORMAT_CONFIRMATION_YES="Sí, estoy seguro"
    MSG_FORMAT_CONFIRMATION_NO="No, mejor volver"
    MSG_ENTER_LABEL="Introduce la nueva etiqueta del dispositivo (máx. 11 carácteres)"
    MSG_ENTER_LABEL_ERROR="¡Debes introducir una nueva etiqueta para el dispositivo! Inténtalo de nuevo"
    MSG_UNMOUTING="Desmontando particiones montadas del dispositivo ..."
    MSG_FORMATTING="Limpiando tabla de particiones y formateando ..."
    MSG_FORMATTING_STARTED="Formateo iniciado"
    MSG_FORMATTING_SUCCESS="¡Dispositivo formateado con éxito!"
else
    MSG_TITLE="Format USB device as FAT32"
    MSG_CHOOSE_DEVICE="Select the USB device you want to format with FAT32 format"
    MSG_CHOOSE_DEVICE_ERROR="You have not selected any USB device to format"
    MSG_FORMAT="Format"
    MSG_CLOSE="Close"
    MSG_MODEL="Model"
    MSG_LABEL="Label"
    MSG_PATH="Device path"
    MSG_SIZE="Size"
    MSG_CONTINUE="Continue"
    MSG_BACK="Go Back"
    MSG_FORMAT_CONFIRMATION="Are you sure you want to format this device? <b>$dev</b>"
    MSG_FORMAT_CONFIRMATION_YES="Yes, I'm sure"
    MSG_FORMAT_CONFIRMATION_NO="No, better go back"
    MSG_ENTER_LABEL="Enter the new device label (max. 11 characters)"
    MSG_ENTER_LABEL_ERROR="You must enter a new label for the device! Try again"
    MSG_UNMOUTING="Removing mounted partitions from the device ..."
    MSG_FORMATTING="Clearing partition table and formatting ..."
    MSG_FORMATTING_STARTED="Formatting started"
    MSG_FORMATTING_SUCCESS="Device successfully formatted!"
fi

while true; do
    oldifs=$IFS
    IFS=';'
    lsblk=$(sudo lsblk -o LABEL,MODEL,NAME,SIZE,TYPE,HOTPLUG -n -P -p | grep 'HOTPLUG="1"' | grep 'TYPE="disk"' | sed 's/ TYPE="disk" HOTPLUG="1"//' | cut -d '"' -f 2,4,6,8 | tr '"' ';' | tr "\n" ";")
    dev=$(zenity --list --width=500 --height=300 --print-column=3 --title="$MSG_TITLE" --text="$MSG_CHOOSE_DEVICE" --ok-label="$MSG_FORMAT" --cancel-label="$MSG_CLOSE" --column="$MSG_LABEL" --column="$MSG_MODEL" --column="$MSG_PATH" --column="$MSG_SIZE" $lsblk)

    case $? in
    0)
        if [ "$dev" == "" ]; then
            zenity --info --title="$MSG_TITLE" --text="$MSG_CHOOSE_DEVICE_ERROR" --ok-label="$MSG_BACK"
        else
            zenity --question --title="$MSG_TITLE" --text="$MSG_FORMAT_CONFIRMATION" --ok-label="$MSG_FORMAT_CONFIRMATION_YES" --cancel-label="$MSG_FORMAT_CONFIRMATION_NO"
            case $? in
            0)
                name=$(zenity --entry --title="$MSG_TITLE" --text="$MSG_ENTER_LABEL" --ok-label="$MSG_CONTINUE" --cancel-label="$MSG_BACK")
                case $? in
                0)
                    if [ "$name" == "" ]; then
                        zenity --warning --title="$MSG_TITLE" --text="$MSG_ENTER_LABEL_ERROR"
                    else
                        (
                            if mount | grep "$dev" > /dev/null; then
                                echo "# $MSG_UNMOUTING"
                                sudo umount -f $dev* 2> /dev/null
                            fi

                            echo "# $MSG_FORMATTING"
                            sudo dd if=/dev/zero of="$dev" bs=512 count=1 conv=notrunc &> /dev/null
                            sudo mkdosfs -F 32 -n "$(echo "$name" | tr '[:lower:]' '[:upper:]')" -I "$dev"

                        ) | zenity --progress --title="$MSG_FORMATTING_STARTED" --width=300 --no-cancel --pulsate --auto-close

                        zenity --warning --title="$MSG_TITLE" --text="$MSG_FORMATTING_SUCCESS"
                    fi
                ;;
                # 1)
                #     CLOSED
                # ;;
                esac
            ;;
            # 1)
            #    NOT CONFIRMED
            # ;;
            esac
        fi
    ;;
    1)
        exit
    ;;
    esac

    IFS=$oldifs
done
