#!/bin/bash

if [[ "$1" == "--afterResolution" ]]; then

    # Trouver le PID du processus .liste_personnage.sh en cours d'exécution
    pid_liste=$(pgrep -f ".liste_personnage.sh")

    # Vérifier si un PID a été trouvé
    if [ -n "$pid_liste" ]; then
        # Arrêter le processus avec le PID trouvé
        kill "$pid_liste" > /dev/null 2>&1
    fi


    # Supprimer l'utilisateur castafiore s'il existe
    if id -u herge >/dev/null 2>&1; then
        sudo userdel -r herge > /dev/null 2>&1
    fi

    # Supprimer les groupes et utilisateurs créés
    if id "castafiore" &>/dev/null; then
        sudo deluser castafiore
    fi

    # Supprimer les fichiers de configuration
    rm -f .encoded .encoded_2
    rm -f personnages
    rm -f .tintin_tibet.sh .tintin_or_noir.sh .tintin_objectif_lune.sh .tintin_picaros.sh .tintin_etudie_en_TC.sh

    # Terminer tous les processus de l'exercice
    for pid in $(pgrep -f tintin); do
        # Vérifier si le processus n'est pas start_tintin
        if ! ps -p $pid -o comm= | grep -q "start_tintin.sh"; then
            kill $pid > /dev/null 2>&1
        fi
    done

    pkill -f "sleep 3600"

else

    # Pour tous les modules
    rm -f .final_time      # Supprimer le fichier d'erreurs s'il existe
    rm -f .module_OK   # Supprimer le fichier de succès s'il existe

    # Trouver le PID du processus .liste_personnage.sh en cours d'exécution
    pid_liste=$(pgrep -f ".liste_personnage.sh")

    # Vérifier si un PID a été trouvé
    if [ -n "$pid_liste" ]; then
        # Arrêter le processus avec le PID trouvé
        kill "$pid_liste" > /dev/null 2>&1
    fi


    # Supprimer l'utilisateur castafiore s'il existe
    if id -u herge >/dev/null 2>&1; then
        sudo userdel -r herge > /dev/null 2>&1
    fi

    # Supprimer les groupes et utilisateurs créés
    if id "castafiore" &>/dev/null; then
        sudo deluser castafiore
    fi

    # Supprimer les fichiers de configuration
    rm -f .encoded .encoded_2
    rm -f personnages
    rm -f .tintin_tibet.sh .tintin_or_noir.sh .tintin_objectif_lune.sh .tintin_picaros.sh .tintin_etudie_en_TC.sh

    # Terminer tous les processus de l'exercice
    for pid in $(pgrep -f tintin); do
        # Vérifier si le processus n'est pas start_tintin
        if ! ps -p $pid -o comm= | grep -q "start_tintin.sh"; then
            kill $pid > /dev/null 2>&1
        fi
    done

    pkill -f "sleep 3600"

    # Vérifier si l'option --hard a été fournie
    if [[ "$1" == "--hard" ]]; then
        rm -f .start_time 
        rm -f .error      # Supprimer le fichier d'erreurs s'il existe
    fi

fi