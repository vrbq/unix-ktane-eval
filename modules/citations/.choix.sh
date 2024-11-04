#!/bin/bash

# Fonction pour décoder le fichier base64
decode_file() {
    local encoded_file="$1"
    local decoded_file="$2"
    base64 --decode "$encoded_file" > "$decoded_file"
}

# Fonction pour formater le numéro avec un zéro devant si nécessaire
format_number() {
    local number="$1"
    if [ "$number" -lt 10 ]; then
        printf "0%d" "$number"
    else
        echo "$number"
    fi
}

# Fonction pour sélectionner les lignes correspondant au numéro donné
filter_lines_by_number() {
    local decoded_file="$1"
    local number="$2"
    grep "^$number -" "$decoded_file"
}

# Fonction pour choisir une ligne au hasard parmi les résultats
select_random_line() {
    local lines="$1"
    echo "$lines" | shuf -n 1
}

# Fonction pour extraire le texte après le tiret
extract_text_after_dash() {
    local line="$1"
    echo "$line" | cut -d'-' -f2- | sed 's/^ *//'
}

# Fonction principale
choose_random_event() {
    local encoded_file="$1"
    local number="$2"
    local decoded_file="decoded.txt"

    # Décodage du fichier
    decode_file "$encoded_file" "$decoded_file"

    # Formatage du numéro
    local formatted_number
    formatted_number=$(format_number "$number")

    # Filtrage des lignes correspondant au numéro donné
    local filtered_lines
    filtered_lines=$(filter_lines_by_number "$decoded_file" "$formatted_number")

    # Si aucune ligne ne correspond, afficher un message d'erreur
    if [ -z "$filtered_lines" ]; then
        echo "Aucune ligne trouvée pour le numéro $number."
        return 1
    fi

    # Sélection d'une ligne au hasard
    local random_line
    random_line=$(select_random_line "$filtered_lines")

    # Extraction du texte après le tiret
    local result
    result=$(extract_text_after_dash "$random_line")

    # Affichage du résultat
    echo "$result"

    # Nettoyage du fichier temporaire
    rm -f "$decoded_file"
}

# Exemple d'utilisation
# ./script.sh fichier_base64.txt 8
choose_random_event "$1" "$2"
