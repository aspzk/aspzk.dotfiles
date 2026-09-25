#!/usr/bin/env bash

# Diretório onde ficam os scripts de menu
SCRIPTS_DIR="$HOME/.config/rofi/scripts"

OPTIONS=" Apps\n Clipboard\n Wallpaper\n Screenshot\n Áudio\n Energia"

CHOICE=$(echo -e "$OPTIONS" \
  | rofi -dmenu \
         -i \
         -p "Menu" \
         -font "IosevkaTerm Nerd 11" \
         -no-fixed-num-lines \
         -theme-str 'window {width: 260px;}')

case "$CHOICE" in
  " Energia")    bash "$SCRIPTS_DIR/power.sh" ;;
  " Screenshot") bash "$SCRIPTS_DIR/screenshot.sh" ;;
  " Wallpaper") bash "$SCRIPTS_DIR/wallpaper.sh" ;;
  " Áudio") bash "$SCRIPTS_DIR/audio.sh" ;;
  " Apps") rofi -show drun ;;
  " Clipboard") bash "$SCRIPTS_DIR/clipboard.sh" ;;
  # Adicione novos menus aqui:
  # " Novo menu")  bash "$SCRIPTS_DIR/novo.sh" ;;
esac
