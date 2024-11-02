#!/bin/bash

# Pour tous les modules
rm -f .final_time      # Supprimer le fichier d'erreurs s'il existe
rm -f .module_OK   # Supprimer le fichier de succès s'il existe

rm -f .encoded .temp .history   > /dev/null 2>&1


# Supprime les dossiers correspondant aux noms de capitales
delete_capital_dirs() {
    local villes=(
    "Philadelphia" "Tokyo" "Calgary" "Lima" "Yaoundé" "Mumbai" "Brisbane" "Chicago" 
    "Sendai" "Lagos" "Chennai" "Sydney" "Madrid" "Morelia" 
    "Casablanca" "London" "Darwin" "Singapore" "Johannesburg"
    "Athens" "Berlin" "Bangkok" "Istanbul" "Vienna" "Moscow" "Manila" 
    "Helsinki" "Cairo" "Dakar" "Seoul" "Osaka" "Quito" "Budapest" 
    "Beijing" "Dublin" "Havana" "Warsaw" "Lisbon" "Tehran" "Amman" 
    "Jakarta" "Kigali" "Bucharest" "Prague" "Lusaka" "Tirana" 
    "Kampala" "Geneva" "Banjul" "Sofia" "Tripoli" "Ottawa" 
    "Caracas" "Bamako" "Luanda" "Stockholm" "Accra" "Tunis"
    )
    
    # Parcourt chaque capitale pour rechercher et supprimer les dossiers correspondants
    for ville in "${villes[@]}"; do
        find . -type d -name "$ville" -exec rm -rf {} +
    done
}

# Exemple d'utilisation
delete_capital_dirs

# Vérifier si le fichier .encoded_2 existe
if [ -f .encoded_2 ]; then
    # Lire le PATH initial depuis .encoded_2 et le décoder
    encoded_initial_path=$(cat .encoded_2)
    initial_path=$(echo "$encoded_initial_path" | base64 --decode)

    # Afficher le PATH décodé pour vérification
    # echo "Le PATH décodé est : $initial_path"

    # Restaurer PATH avec sa valeur initiale
    export PATH="$initial_path"
    # echo "La variable PATH a été restaurée."

    # Afficher la nouvelle valeur de PATH
fi

rm -f gps_coordinates.txt .encoded_1 .encoded_2 > /dev/null 2>&1


# Supprimer tous les fichiers propre au module

# Vérifier si l'option --hard a été fournie
if [[ "$1" == "--hard" ]]; then
    rm -f .start_time 
    rm -f .error      # Supprimer le fichier d'erreurs s'il existe
fi