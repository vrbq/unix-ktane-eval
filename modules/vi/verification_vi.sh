#!/bin/bash

# Chemin vers le fichier "encoded" contenant le chemin du fichier joueur
encoded_path=".encoded"

# Chemin vers le fichier encodé en base64 contenant le contenu attendu
encoded_file=".encoded_2"

# Fichier de comptabilisation des erreurs
error_file=".error"

# Initialiser le compteur d'erreurs s'il n'existe pas
if [ ! -f "$error_file" ]; then
    echo 0 > "$error_file"
fi

# Fonction pour incrémenter le compteur d'erreurs
increment_error() {
    current_errors=$(cat "$error_file")
    new_errors=$((current_errors + 1))
    echo "$new_errors" > "$error_file"
}

# Décoder le fichier "encoded" pour obtenir le chemin
decoded_path=$(base64 -d "$encoded_path")

# Lire le répertoire et le fichier depuis le contenu décodé
directory=$(echo "$decoded_path" | sed -n '2p')
filename=$(echo "$decoded_path" | sed -n '1p')

# Chemin complet du fichier joueur
joueur_file="${directory}/${filename}"

# Vérifier que le fichier joueur existe
if [ ! -f "$joueur_file" ]; then
    echo "Le fichier $filename n'existe pas dans le répertoire $directory."
    increment_error
    exit 1
fi

# Vérifier que le fichier est bien dans le bon répertoire
if [ "$(dirname "$joueur_file")" != "$directory" ]; then
    echo "Le fichier $filename n'est pas dans le répertoire correct."
    increment_error
    exit 1
fi

# Décoder le fichier .encoded_2 pour obtenir le contenu attendu
decoded_content=$(base64 -d "$encoded_file")

# Comparer le contenu décodé avec le contenu du fichier du joueur
if [ "$decoded_content" != "$(cat "$joueur_file")" ]; then
    echo "Le contenu du fichier modifié ne correspond pas à l'original."
    increment_error
    exit 1
fi

echo "Le fichier modifié est correct."
exit 0