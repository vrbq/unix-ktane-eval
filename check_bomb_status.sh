#!/bin/bash

# Fichier contenant la liste des mini-jeux
mini_games_list="mini_games_list"

# Fichier qui contient le temps restant
time_file="time"

# Vérifier si la bombe est désamorcée
check_bomb_disarmed() {
    all_modules_ok=true
    while IFS= read -r module_name; do
        module_ok="./modules/$module_name/.module_OK"
        if [ ! -f "$module_ok" ]; then
            all_modules_ok=false
            break
        fi
    done < "$mini_games_list"

    echo "$all_modules_ok"
}

# Boucle pour vérifier le statut toutes les secondes
while true; do
    if [ ! -f ".countdown_in_progress" ] && [ ! -f ".countdown_expired" ]; then
        # echo "La bombe n'a pas encore été lancée."
        exit 1
        break
    fi

    # Vérifier si le compte à rebours a expiré
    if [ -f ".countdown_expired" ]; then
        echo "Le compte à rebours est terminé, mais la bombe n'a pas été désamorcée." &
        rm -f mini_games_list 
        exit 0
        break
    fi

    # Vérifier si tous les modules sont désamorcés
    if [ "$(check_bomb_disarmed)" = "true" ]; then
        # Lire le temps restant
        if [ -f "$time_file" ]; then
            time_remaining=$(cat "$time_file")
        else
            time_remaining="Temps non disponible"
        fi
        echo "Bravo, vous avez désamorcé la bombe avec $time_remaining restant !" &
        echo "PAS BOOM, BRAVO !" > .stop_counter
        # Supprimer les fichiers temporaires précédents
        rm -f mini_games_list

        # Supprimer les fichiers .module_OK de tous les modules
        if [ -f modules_list ]; then
            # Stocker le contenu du fichier modules_list dans une variable
            modules=$(cat modules_list)

            # Boucle à travers chaque module
            for module in $modules; do
                module_ok_file="./modules/$module/.module_OK"
                can_go_file="./modules/$module/.can_go"
                
                if [ -f "$module_ok_file" ]; then
                    # Suppression de .module_OK
                    rm "$module_ok_file"
                fi
                
                if [ -f "$can_go_file" ]; then
                    # Suppression de .can_go
                    rm "$can_go_file"
                fi
            done
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

        exit 0
        break
    fi

    # Afficher le temps restant
    if [ -f "$time_file" ]; then
        time_remaining=$(cat "$time_file")
        # echo "Temps restant : $time_remaining"
    fi

    # Attendre une seconde avant la prochaine vérification
    sleep 1
done
