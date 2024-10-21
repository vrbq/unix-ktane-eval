#!/bin/bash

# Supprimer les fichiers temporaires précédents
rm -f mini_games_list .verifications log .stop_counter .countdown_expired .countdown_in_progress error_status

# Supprimer les fichiers .module_OK et .can_go de tous les modules
        if [ -f modules_list ]; then
            # Stocker le contenu du fichier modules_list dans une variable
            modules=$(cat modules_list)

            # Boucle à travers chaque module
            for module in $modules; do
                module_ok_file="./modules/$module/.module_OK"
                can_go_file="./modules/$module/.can_go"
                error_file="./modules/$module/.error"
                remise_zero="./modules/$module/remise_zero.sh"
                
                if [ -f "$module_ok_file" ]; then
                    # Suppression de .module_OK
                    rm "$module_ok_file"
                fi
                
                if [ -f "$can_go_file" ]; then
                    # Suppression de .can_go
                    rm "$can_go_file"
                fi

                if [ -f "$error_file" ]; then
                    # Suppression de .can_go
                    rm "$error_file"
                fi

                if [ -f "$error_file" ]; then
                    # Lancer la remise a zero
                    ./"$remise_zero"
                fi
            done
        fi

# Vérifier s'il y a un processus countdown en cours et l'arrêter
if [ -f .countdown_pid ]; then
    old_pid=$(cat .countdown_pid)
    
    # Vérifier si le PID correspond toujours à un processus actif
    if ps -p $old_pid > /dev/null; then
        # echo "Arrêt du processus countdown en cours (PID: $old_pid)"
        kill $old_pid
        rm .countdown_pid
    else
        # echo "Le processus countdown avec PID $old_pid n'est plus actif."
        rm .countdown_pid
    fi
else
    # Si le fichier .countdown_pid n'existe pas, utiliser ps aux pour rechercher countdown.sh
    # echo "Le fichier .countdown_pid est introuvable, recherche du processus countdown..."

    # Utiliser ps aux pour trouver le processus countdown.sh
    countdown_pid=$(ps aux | grep '[c]ountdown.sh' | awk '{print $2}')

    if [ -n "$countdown_pid" ]; then
        # echo "Arrêt du processus countdown trouvé (PID: $countdown_pid)"
        kill $countdown_pid
    fi
fi

# Vérifier s'il y a un processus check_bomb_status en cours et l'arrêter
if [ -f .check_status_pid ]; then
    old_pid_check=$(cat .check_status_pid)
    
    # Vérifier si le PID correspond toujours à un processus actif
    if ps -p $old_pid_check > /dev/null; then
        # echo "Arrêt du processus check_bomb_status en cours (PID: $old_pid)"
        kill $old_pid_check
        rm .check_status_pid
    else
        # echo "Le processus check_bomb_status avec PID $old_pid_check n'est plus actif."
        rm .check_status_pid
    fi
else
    # Si le fichier .check_status_pid n'existe pas, utiliser ps aux pour rechercher check_bomb_status.sh
    # echo "Le fichier .check_status_pid est introuvable, recherche du processus check_bomb_status..."

    # Utiliser ps aux pour trouver le processus countdown.sh
    check_status_pid=$(ps aux | grep '[c]heck_bomb_status.sh' | awk '{print $2}')

    if [ -n "$check_status_pid" ]; then
        # echo "Arrêt du processus check_bomb_status trouvé (PID: $check_status_pid)"
        kill $check_status_pid
    fi
fi

# Fichier contenant la liste des modules
mini_games_list="modules_list"

# Vérifier si le fichier modules_list existe
if [ -f "$mini_games_list" ]; then
    # Stocker le contenu du fichier modules_list dans une variable
    modules=$(cat "$mini_games_list")

    # Boucle à travers chaque module
    for module_name in $modules; do
        # Vérifier si le répertoire du module existe
        if [ -d "./modules/$module_name" ]; then
            # Créer le fichier .can_go dans le répertoire du module
            touch "./modules/$module_name/.can_go"
            cp -r serial "./modules/$module_name/.serial"
            # echo "Fichier .can_go créé dans le module : $module_name"
        fi
    done
else
    echo "Le fichier $mini_games_list n'existe pas."
fi


# Créer un nouveau fichier log vide
touch .log

# Lancer le script de génération de serial
./generate_seed.sh &


# Liste des mini-jeux à résoudre
mini_games=("fils")  # Exemple d'autres mini-jeux

# Sauvegarder la liste dans un fichier caché
for game in "${mini_games[@]}"; do
    echo "$game" >> mini_games_list
done

# Lancer le script de compte à rebours en arrière-plan
if [ -f countdown.sh ]; then
    ./countdown.sh &
    rm -f ./.countdown_expired
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
fi