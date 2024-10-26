#!/bin/bash

#Remise a zero du jeu
./remise_zero.sh

# Lancer le script de génération de serial
./generate_seed.sh

# Fichier contenant la liste des modules
mini_games_list="modules_list"

# Vérifier si le fichier modules_list existe
if [ -f modules_list ]; then
    # Parcourir chaque ligne du fichier
    while IFS= read -r module || [[ -n "$module" ]]; do
        # Vérifier si la ligne n'est pas vide
        if [[ -n "$module" ]]; then
        # Extraire uniquement les lettres (caractères alphabétiques)
        filtered_module=$(echo "$module" | tr -d -c '[:alpha:]')
            # Vérifier si le répertoire du module existe
            if [ -d "./modules/$filtered_module" ]; then
                # Créer le fichier .can_go dans le répertoire du module
                touch "./modules/$filtered_module/.can_go"
                cp -r serial "./modules/$filtered_module/.serial"
                # echo "Fichier .can_go créé dans le module : $module_name"
            fi
        fi
    done < modules_list
else
    echo "Le fichier modules_list n'existe pas."
fi

# Créer un nouveau fichier log vide
touch .log

# Liste des mini-jeux à résoudre
mini_games=("fils")  # Exemple d'autres mini-jeux

# Sauvegarder la liste dans un fichier caché
for game in "${mini_games[@]}"; do
    # echo "Lancement du mini-jeu : $game"
    echo "$game" >> mini_games_list
done

# Lancer le script de compte à rebours en arrière-plan
if [ -f countdown.sh ]; then
    rm -f ./.countdown_expired
    ./countdown.sh &
    echo "in progress" > ./.countdown_in_progress
else
    echo "Le script countdown.sh n'existe pas."
fi

# Lancer le check du status de la bombe
./check_bomb_status.sh &

# Boucle tant que le processus check_bomb_status.sh n'est pas trouvé
check_status_pid=$(ps aux | grep '[c]heck_bomb_status.sh' | awk '{print $2}')
attempt_count=0
max_attempts=3

while [ -z "$check_status_pid" ] && [ $attempt_count -lt $max_attempts ]; do
    # Utiliser ps aux pour trouver le processus check_bomb_status.sh
    check_status_pid=$(ps aux | grep '[c]heck_bomb_status.sh' | awk '{print $2}')

    if [ -z "$check_status_pid" ]; then
        # Relancer le processus si non trouvé
        ./check_bomb_status.sh &
        sleep 1  # Attendre une seconde avant de réessayer
        ((attempt_count++))  # Incrémenter le compteur de tentatives
    fi
done

# Si le processus est trouvé, sauvegarder le PID
if [ -z "$check_status_pid" ]; then
     echo "Impossible de lancer correctement la bombe"
else
    echo "$check_status_pid" > .check_status_pid
fi

# Afficher le temps restant
if [ -f .countdown_in_progress ]; then
    echo "La bombe est lancée, le compte à rebours tourne !"
    if [ -f time ]; then
        echo "Il vous $(cat time) pour désamorcer la bombe."
    fi
else
    echo "La bombe n'est pas lancée !"
fi