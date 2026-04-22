#!/bin/bash

chosen=$(printf "Power Off\nReboot" | rofi -dmenu)

if [ "${chosen}" == "Power Off" ]; then
    systemctl poweroff
elif [ "${chosen}" == "Reboot" ]; then
    systemctl reboot
fi
