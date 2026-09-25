#!/usr/bin/env bash

OPTIONS=" Lock\n Poweroff\n Reboot\n Logout"

CHOICE=$(echo -e "$OPTIONS" \
  | rofi -dmenu \
         -i \
         -p "Power" \
         -font "IosevkaTerm Nerd 11" \
         -no-fixed-num-lines \
         -theme-str 'window {width: 260px;}')

case "$CHOICE" in
  " Poweroff")   loginctl poweroff ;;
  " Reboot")  loginctl reboot;;
  " Lock")
    WALLPAPER=$(awww query | awk -F'image: ' '{print $2}' | head -1)
    swaylock -i "$WALLPAPER"
    ;;
  " Logout") hyprctl dispatch 'hl.dsp.exit()' ;;
esac
