#!/usr/bin/env bash
#
# Secure clipboard watcher for Hyprland + cliphist
#

set -euo pipefail


clip_content=$(cat)

#notify-send "test" "$clip_content" -i  /usr/share/icons/breeze/places/22/network-server.svg

# Extraire la première zone: [MG]-MISC|EU|S|Chaos
bot=$(echo "$clip_content" | sed -n 's|/msg \(.*\) xdcc send.*|\1|p')
# Extraire la deuxième zone: 99 ou #99 (le numéro après "xdcc send")
slot=$(echo "$clip_content" | sed -n 's|/msg .* xdcc send #\?\([0-9]\+\).*|\1|p')

# Afficher les résultats
if [ -n "$bot" ] && [ -n "$slot" ]; then
  # notify-send "Bot name: $bot" "Slot: $slot" -i  /usr/share/icons/breeze/places/22/network-server.svg
  if [[ $bot == "BEAST"* ]]; then 
    notify-send "irc Beast" -i  /usr/share/icons/breeze/places/22/network-server.svg
    xdccJS --host irc.eu.abjects.net --port 6697 --tls --wait 2 --nickname slave --path ~/Downloads/weechat/ --channel beast-xdcc beast-chat --bot "$bot" --download "$slot" &
  fi
  if [[ $bot == "Zombie"* ]]; then 
    notify-send "irc Zombie" -i  /usr/share/icons/breeze/places/22/network-server.svg 
    xdccJS --host irc.abandoned-irc.net --port 6697 --tls --wait 2 --nickname slave --path ~/Downloads/weechat/ --channel zombie-warez zw-chat --bot "$bot" --download "$slot" &
  fi
  if [[ $bot == "[EWG]"* ]]; then 
    notify-send "irc Elite" -i  /usr/share/icons/breeze/places/22/network-server.svg 
     xdccJS --host irc.rizon.net --port 6697 --tls --wait 2 --nickname slave --path ~/Downloads/weechat/ --channel ELITEWAREZ ELITE-CHAT --bot "$bot" --download "$slot" &
  fi
fi

