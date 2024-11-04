#!/bin/bash

# Vérifier que la bombe a bien été lancée
if [ ! -f ".can_go" ]; then
    echo "La bombe n'a pas été lancée !"
    exit 1
fi

# Fonction pour vérifier le temps écoulé
function verifier_temps_ecoule() {
    # Lire l'heure de début enregistrée
    if [[ -f .start_time ]]; then
        start_time=$(cat .start_time)
        end_time=$(date +%s)
        elapsed_time=$((end_time - start_time))
        
        # Convertir le temps écoulé en minutes et secondes
        minutes=$((elapsed_time / 60))
        seconds=$((elapsed_time % 60))

        # Afficher le temps écoulé
        echo "Le mini-jeu a été résolu en $minutes minutes et $seconds secondes."

        # Enregistrer le temps total dans le fichier .final_time
        echo "$minutes minutes et $seconds secondes" > .final_time
        
        # Supprimer le fichier de l'heure de début pour éviter les conflits
        rm .start_time
        
        # Rajouter le temps dans le .module_OK
        echo "$minutes minutes et $seconds secondes" >> .module_OK
    else
        echo "L'heure de début n'a pas été enregistrée."
    fi
}

# Gestion des erreurs
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
    echo "Sur le module Cities, vous avez fait $(cat "$error_file") erreur(s)."
}

# Vérifier si le fichier temporaire existe
if [[ ! -f .encoded_1 ]]; then
    echo "Veuillez d'abord lancé le module !"
    exit 1
fi

if $tous_les_autres_fichiers_intacts; then
        verifier_temps_ecoule
        [ -f "$error_file" ] && rm -f "$error_file"
else
        echo "FAILED !"
fi


# Lire le PATH initial encodé dans .encoded_2 et le décoder
if [ -f .encoded_2 ]; then
    encoded_initial_path=$(cat .encoded_2)
    initial_path=$(echo "$encoded_initial_path" | base64 --decode)
else
    echo "Erreur : le fichier .encoded_2 n'existe pas."
    exit 1
fi

# Extraire le chemin `city_path` depuis .encoded_1
if [ -f .encoded_1 ]; then
    encoded_city_path=$(cat .encoded_1)
    city_path=$(echo "$encoded_city_path" | base64 --decode)
else
    echo "Erreur : le fichier .encoded_1 n'existe pas."
    exit 1
fi

# # Afficher la variable PATH actuelle
# echo "La variable PATH actuelle : $PATH"

# Vérifier que le PATH actuel contient tous les éléments de `initial_path` et de `city_path`
all_paths_present=true
IFS=':' read -ra initial_paths <<< "$initial_path"

# Vérifier chaque chemin du PATH initial
for path in "${initial_paths[@]}"; do
    if [[ ":$PATH:" != *":$path:"* ]]; then
        all_paths_present=false
        increment_error
        exit 1
    fi
done

# Vérifier si le chemin de la ville est présent
if [[ ":$PATH:" != *"$city_path"* ]]; then
    echo "Le chemin de la ville '$city_path' n'est pas présent dans PATH."
    increment_error
    all_paths_present=false
    exit 1
fi

# Afficher le résultat final
if [ "$all_paths_present" = true ]; then
    echo "La variable PATH contient bien l'ancien PATH et le nouveau chemin."
    echo "Module désamorcé" > ./.module_OK  # Crée un fichier de flag pour arrêter le compteur
    verifier_temps_ecoule
    [ -f "$error_file" ] && rm -f "$error_file"
else
    echo "La variable PATH ne contient pas toutes les informations nécessaires."
    echo "Veuillez remettre a zéro le module."
    increment_error
    exit 1
fi
