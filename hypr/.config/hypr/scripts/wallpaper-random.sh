#!/usr/bin/env bash


sleep 1

# ---- CONFIGURATION ----
# Chemin absolu vers ton répertoire d'images
WALLPAPER_DIR="$HOME/.config/backgrounds/"  # Change this to your wallpaper directory

# Récupère le nom de ton écran actif via hyprctl
# (Pratique si tu changes d'écran ou si tu as un PC portable)
MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# Si aucun écran n'est trouvé "focused", on prend le premier disponible
if [ -z "$MONITOR" ]; then
    MONITOR=$(hyprctl monitors -j | jq -r '.[0].name')
fi
# -----------------------

#Vérification si le dossier existe
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Erreur : Le dossier $WALLPAPER_DIR n'existe pas."
    exit 1
fi

# Sélection d'une image aléatoire (gère les espaces dans les noms)
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.webp" -o -name "*.avif" \) | shuf -n 1)

if [ -z "$RANDOM_WALLPAPER" ]; then
    echo "Aucune image trouvée dans $WALLPAPER_DIR"
    exit 1
fi

hyprctl hyprpaper wallpaper "$MONITOR,$RANDOM_WALLPAPER, cover"
sleep 1
