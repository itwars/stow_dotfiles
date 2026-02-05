#!/usr/bin/env bash

set -euo pipefail
clip_content=$(cat)

# Extraire la première zone: botname
bot=$(echo "$clip_content" | sed -n 's|/msg \(.*\) xdcc send.*|\1|p')
# Extraire la deuxième zone: numéro slot
slot=$(echo "$clip_content" | sed -n 's|/msg .* xdcc send #\?\([0-9]\+\).*|\1|p')

if [ -n "$bot" ] && [ -n "$slot" ]; then
  if [[ $bot == "BEAST"* ]]; then 
    notify-send "XDCC démarre su Beast" -i  /usr/share/icons/breeze/places/22/network-server.svg
    xdccJS --host irc.eu.abjects.net --port 6697 --tls --wait 2 --nickname slave --path ~/Downloads/weechat/ --channel beast-xdcc beast-chat --bot "$bot" --download "$slot" &
  fi
  if [[ $bot == "Zombie"* ]]; then 
    notify-send "XDCC démarre sur Zombie" -i  /usr/share/icons/breeze/places/22/network-server.svg 
    xdccJS --host irc.abandoned-irc.net --port 6697 --tls --wait 2 --nickname slave --path ~/Downloads/weechat/ --channel zombie-warez zw-chat --bot "$bot" --download "$slot" &
  fi
  if [[ $bot == "[EWG]"* ]]; then 
    notify-send "XDCC démarre sur Elite" -i  /usr/share/icons/breeze/places/22/network-server.svg 
     xdccJS --host irc.rizon.net --port 6697 --tls --wait 2 --nickname slave --path ~/Downloads/weechat/ --channel ELITEWAREZ ELITE-CHAT --bot "$bot" --download "$slot" &
  fi
fi

