#!/bin/bash

# Décoder le fichier "encoded" pour obtenir les instructions
decode_instructions() {
    decoded_data=$(base64 --decode .encoded)
    animal=$(echo "$decoded_data" | sed -n '1p')
    directory=$(echo "$decoded_data" | sed -n '2p')
    modifications=$(echo "$decoded_data" | sed -n '3,$p')
}

# Vérifier le nom et l'emplacement du fichier
check_file_location() {
    original_file="citations.txt"
    copied_file="$directory/$animal"
    # echo "Le fichier copié est : $copied_file"

    if [[ ! -f "$original_file" ]]; then
        echo "Erreur : le fichier original a été supprimé."
        ((errors++))
    fi

    if [[ ! -f "$copied_file" ]]; then
        echo "Erreur : le fichier renommé n'a pas été trouvé dans le bon répertoire."
        ((errors++))
    fi
}

# Vérifier les modifications sur le fichier
check_modifications() {
    for mod in $modifications; do
        # Ajouter ici la logique pour vérifier chaque modification
        echo "Vérification de $mod" # Remplacer par le code de vérification
    done
}

# Initialisation
errors=0
decode_instructions

# Vérifications
check_file_location
check_modifications

# Mise à jour de l'état des erreurs
update_error_status "$errors"

if [[ $errors -eq 0 ]]; then
    echo "Toutes les vérifications ont été passées avec succès !"
else
    echo "Des erreurs ont été détectées : $errors"
fi