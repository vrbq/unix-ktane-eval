#!/bin/bash

# Vérifier si .can_go existe avant de commencer
if [ ! -f ".can_go" ]; then
    echo "La bombe n'a pas été lancée !"
    exit 1
fi

# Remise a zero du jeu
source remise_zero.sh


# Vérifier si le fichier .start_time existe déjà
if [[ ! -f .start_time ]]; then
    start_time=$(date +%s)
    echo $start_time > .start_time
fi


create_directory_structure() {
    # Configuration
    sous_dossiers_par_dossier=3   # Nombre de sous-dossiers dans chaque dossier
    profondeur_max=4             # Profondeur maximale des dossiers
    dossier_racine="."       # Nom du dossier racine

    # Liste de villes pour nommer les dossiers
    villes=("Philadelphia" "Tokyo" "Calgary" "Lima" "Yaoundé" "Mumbai" 
            "Brisbane" "Chicago" "Sendai" "Lagos" "Chennai" "Sydney" 
            "Madrid" "Morelia" "Casablanca" "London" "Darwin" 
            "Singapore" "Johannesburg" "Athens" "Berlin" "Bangkok" 
            "Istanbul" "Vienna" "Moscow" "Manila" "Accra" "Tunis"
            "Helsinki" "Cairo" "Dakar" "Seoul" "Osaka" "Quito" "Budapest" )

    # Liste de secours pour nommer les dossiers si la première liste est épuisée
    villes_backup=(
                   "Beijing" "Dublin" "Havana" "Warsaw" "Lisbon" "Tehran" "Amman" 
                   "Jakarta" "Kigali" "Bucharest" "Prague" "Lusaka" "Tirana" 
                   "Kampala" "Geneva" "Banjul" "Sofia" "Tripoli" "Ottawa" 
                   "Caracas" "Bamako" "Luanda" "Stockholm")

    # Liste des villes et leurs coordonnées GPS
    declare -A villes_gps
    villes_gps=(
        ["Philadelphia"]="39° 57' 9.2988'' N - 75° 9' 54.7992'' W"
        ["Tokyo"]="35° 39' 10.1952'' N - 139° 50' 22.1208'' E"
        ["Calgary"]="51° 2' 59.9964'' N - 114° 3' 59.9976'' W"
        ["Lima"]="12° 2' 46.9464'' S - 77° 2' 34.0548'' W"
        ["Yaoundé"]="3° 50' 38.8284'' N - 11° 30' 4.8456'' E"
        ["Mumbai"]="19° 4' 33.9240'' N - 72° 52' 38.7336'' E"
        ["Brisbane"]="27° 28' 12.4500'' S - 153° 1' 15.8592'' E"
    )


    # Mélanger les noms des villes pour éviter les répétitions
    shuf_villes=($(shuf -e "${villes[@]}"))
    shuf_villes_backup=($(shuf -e "${villes_backup[@]}"))
    index=0            # Index pour parcourir les noms des villes
    backup_index=0     # Index pour parcourir les noms de villes_backup

    # Créer le dossier racine et démarrer la boucle de création de structure
    mkdir -p "$dossier_racine"
    dossiers_a_traiter=("$dossier_racine")  # Liste des dossiers à traiter

    # Boucle de création des dossiers en suivant les niveaux
    for niveau in $(seq 1 "$profondeur_max"); do
        next_dossiers=()  # Liste des dossiers pour le niveau suivant

        for dossier in "${dossiers_a_traiter[@]}"; do
            # Arrêter de créer des sous-dossiers au niveau de profondeur max
            if [ "$niveau" -eq "$profondeur_max" ]; then
                break
            fi

            # Créer le nombre spécifié de sous-dossiers dans chaque dossier actuel
            for ((i=0; i<sous_dossiers_par_dossier; i++)); do
                # Sélectionner une ville dans la liste principale ou de secours
                if [ "$index" -lt "${#shuf_villes[@]}" ]; then
                    local ville="${shuf_villes[index]}"
                    index=$((index + 1))
                elif [ "$backup_index" -lt "${#shuf_villes_backup[@]}" ]; then
                    local ville="${shuf_villes_backup[backup_index]}"
                    backup_index=$((backup_index + 1))
                else
                    local ville="Lyon"  # Utiliser "Lyon" si plus de villes disponibles
                fi

                # Créer le sous-dossier et l'ajouter à la liste du prochain niveau
                local sous_dossier="$dossier/$ville"
                mkdir -p "$sous_dossier"
                next_dossiers+=("$sous_dossier")
            done
        done

        # Mise à jour de la liste des dossiers à traiter pour le prochain niveau
        dossiers_a_traiter=("${next_dossiers[@]}")
    done

    # Sélectionner une ville au hasard parmi les clés du tableau villes_gps
    random_city=$(shuf -e "${!villes_gps[@]}" -n 1)
    gps_coordinates="${villes_gps[$random_city]}"  # Obtenir les coordonnées GPS de la ville sélectionnée

    # Trouver le chemin vers le répertoire de la ville sélectionnée
    # city_path=$(find "$dossier_racine" -type d -name "$random_city" 2>/dev/null)
    city_path=$(find "$dossier_racine" -type d -name "$random_city" 2>/dev/null | sed 's|^\./||')
    root_path=$(pwd)
    root_plus_city_path="$root_path/$city_path"
    echo "$root_plus_city_path" | base64 > .encoded_1

    # Sauvegarder la variable PATH initiale, encodée en base64 dans .encoded_2
    echo "$PATH" | base64 > .encoded_2


    echo "$gps_coordinates" > gps_coordinates.txt

}

create_directory_structure

