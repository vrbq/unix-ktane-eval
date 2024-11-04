#!/bin/bash

# Définition des caractères pour les voyelles, consonnes et chiffres
voyelles=("A" "E" "I" "U")
consonnes=("B" "C" "D" "F" "G" "H" "J" "K" "L" "M" "N" "P" "Q" "R" "S" "T" "V" "W" "W" "Z")
chiffres=("0" "1" "2" "3" "4" "5" "6" "7" "8" "9")


serial_file="serial"
category_file="category"

# Inclure le fichier contenant la fonction log_message
source log_utils.sh  # Utilise le chemin correct vers log_utils.sh

log_message "generate_seed.sh"

# Générer une chaîne de caractères respectant les contraintes
generate_serial() {
    local serial=""
    local voyelle_count=$((RANDOM % 3))  # Entre 0 et 2 voyelles
    local consonne_count=$((RANDOM % 3)) # Entre 0 et 2 consonnes
    local total_voyelle=0
    local total_consonne=0

    # Calculer le nombre restant de caractères pour les chiffres
    local remaining_characters=$((7 - voyelle_count - consonne_count))

    # Générer les voyelles
    while [[ $total_voyelle -lt $voyelle_count ]]; do
        serial+="${voyelles[RANDOM % ${#voyelles[@]}]}"
        ((total_voyelle++))
    done

    # Générer les consonnes
    while [[ $total_consonne -lt $consonne_count ]]; do
        serial+="${consonnes[RANDOM % ${#consonnes[@]}]}"
        ((total_consonne++))
    done

    # Compléter le reste avec des chiffres
    for ((i = 0; i < remaining_characters; i++)); do
        serial+="${chiffres[RANDOM % ${#chiffres[@]}]}"
    done

    # Mélanger les caractères (hors dernier chiffre)
    serial=$(echo "$serial" | fold -w1 | shuf | tr -d '\n')

    # Ajouter un chiffre à la fin
    serial+="${chiffres[RANDOM % ${#chiffres[@]}]}"
    echo "$serial"
}

# Calcul de la catégorie
get_category() {
    local serial="$1"
    local voyelle_count=0
    local consonne_count=0
    local dernier_chiffre="${serial: -1}"
    local parite
    local category_num

    # Compter voyelles et consonnes
    for ((i=0; i<7; i++)); do
        char="${serial:$i:1}"
        if [[ " ${voyelles[*]} " =~ " $char " ]]; then
            ((voyelle_count++))
        elif [[ " ${consonnes[*]} " =~ " $char " ]]; then
            ((consonne_count++))
        fi
    done

    # Déterminer la parité du dernier chiffre
    if (( dernier_chiffre % 2 == 0 )); then
        parite="pair"
    else
        parite="impair"
    fi

    # Calcul du numéro de la catégorie
    if [[ "$parite" == "pair" ]]; then
        category_num=$((voyelle_count * 3 + consonne_count + 1))
    else
        category_num=$((voyelle_count * 3 + consonne_count + 10))
    fi

    echo "$category_num"
    echo "(Voyelles: $voyelle_count, Consonnes: $consonne_count, Chiffre $parite)"
    return $category_num
}

# Écrire dans le fichier serial (supprimer puis réécrire)
write_serial_file() {
    local serial="$1"

    # Supprimer l'ancien fichier et écrire le nouveau serial
    rm -f "$serial_file"
    echo "$serial" > "$serial_file"
    log_message "Fichier $serial_file réécrit avec le nouveau serial."
}

# Écrire dans le fichier category (supprimer puis réécrire)
write_category_file() {
    local category="$1"

    # Supprimer l'ancien fichier et écrire le nouveau serial
    rm -f "$category_file"
    echo "$category" > "$category_file"
    log_message "Fichier $category_file réécrit avec la catégorie."
}


# Main - Générer le serial, afficher et écrire dans le fichier
serial=$(generate_serial)
log_message "Serial généré : $serial"
category=$(get_category "$serial")
write_serial_file "$serial"
write_category_file "$category"