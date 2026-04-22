#!/bin/bash

mode="$1" # может быть пустым или "--refresh"

# --- Проверяем подключение мониторов ---
connected_dp2=$(xrandr | grep 'DP-2 connected')

# --- Получаем текущую ориентацию HDMI-0 ---
orientation=$(xrandr --query | awk '/HDMI-0 connected/ {print $6}')

prev_orientation=$(cat /tmp/hdmi0_orientation 2>/dev/null)

if [ "$mode" = "--refresh" ]; then
    if [ "$prev_orientation" = "$orientation" ]; then
        exit 0
    fi

    # обнуляется состояние экранов, чтобы они заново позционировались, но все открытые окна останутся
#     for mon in HDMI-0 DP-2; do
#         for d in $(bspc query -D -m "$mon"); do
#             bspc query -N -d "$d" -n .window >> ~/.config/bspwm/test.txt
#             bspc query -N -d "$d" -n .window | xargs -r -I{} bspc node {} -c
#         done
#     done

#     for mon in HDMI-0 DP-2; do
#         for d in $(bspc query -D -m "$mon"); do
#             bspc query -N -d "$d" -n .window | while read -r wid; do
#                 pid=$(xprop -id "$wid" _NET_WM_PID | awk '{print $3}')
#                 [ -n "$pid" ] && kill -9 "$pid"
#             done
#         done
#     done

    for mon in HDMI-0 DP-2; do
        for d in $(bspc query -D -m "$mon"); do
            bspc query -N -d "$d" -n .window | while read -r wid; do
                [ -z "$wid" ] && continue
                pid=$(xprop -id "$wid" _NET_WM_PID | awk '{print $3}')
                if [ -n "$pid" ]; then
                    kill -9 "$pid"
                else
                    xkill -id "$wid"
                fi
            done
        done
    done

    bspc monitor HDMI-0 -r
    bspc monitor DP-2   -r
    bspc monitor DP-4   -r
fi

# --- Определяем ширину и высоту HDMI-0 ---
if [ "$orientation" = "left" ]; then
    hdmi_w=1080
    hdmi_h=1920
else
    # По умолчанию горизонтальная
    hdmi_w=1920
    hdmi_h=1080
    orientation="normal"
fi

echo "$orientation" > /tmp/hdmi0_orientation

# --- Настройка xrandr ---
if [ "$connected_dp2" ]; then
    # DP-2 и DP-4 подключены
    # HDMI-0 слева, DP-2 и DP-4 справа
    dp2_x=$hdmi_w
    dp4_x=$((dp2_x + 1920))

    dp_w=1920
    dp_h=1080
    offset_y=$((hdmi_h - dp_h))

    # Применяем конфигурацию
    xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate "$orientation" \
           --output DP-2   --mode 1920x1080 --pos "${dp2_x}x${offset_y}" --rotate normal \
           --output DP-4   --primary --mode 1920x1080 --pos "${dp4_x}x${offset_y}" --rotate normal


    # --- Настройка bspwm ---
    bspc monitor DP-4   -d I II III IV V
    bspc monitor DP-2   -d VI VII VIII
    bspc monitor HDMI-0 -d IX X

    # Перемещаем десктопы HDMI-0 на DP-4, чтобы отображались правильно
    bspc monitor DP-4 -s HDMI-0

    nitrogen --restore
    # после смены ориентации

else
    # Если DP-2 не подключен, всё на DP-4
    xrandr --output HDMI-0 --off \
           --output DP-4 --primary --mode 1920x1080 --pos 0x0 --rotate normal

    bspc monitor DP-4 -d I II III IV V VI VII VIII IX
fi
