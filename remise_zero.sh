# Supprimer les fichiers temporaires précédents

rm -f mini_games_list .verifications log .stop_counter .countdown_expired .countdown_in_progress error_status time

stop_the_bomb() {

        echo "BOOM, DOMMAGE !" > .stop_counter
    
        # Stocker le contenu du fichier modules_list dans une variable
        modules=$(cat modules_list)

        
        # Boucle à travers chaque module
        for module in $modules; do
            module_ok_file="./modules/$module/.module_OK"
            can_go_file="./modules/$module/.can_go"
            error_file="./modules/$module/.error"
            
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
        done

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
            countdown_pid=$(ps aux | grep '[c]ountdown.sh' | awk '{print $2}')

            if [ -n "$check_status_pid" ]; then
                # echo "Arrêt du processus check_bomb_status trouvé (PID: $check_status_pid)"
                kill $check_status_pid
                kil  $countdown_pid	
            fi
        fi

        exit 0
        break
}

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
                serial="./modules/$module/.serial"
                
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
                if [ -f "$serial" ]; then
                    # Lancer la remise a zero
                    rm "$serial"
                fi
                if [ -f "$remise_zero" ]; then
                    # Lancer la remise a zero
                    ./"$remise_zero"
                fi
            done
        fi


stop_the_bomb

rm -f .stop_counter

