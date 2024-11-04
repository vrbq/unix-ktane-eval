#!/bin/bash



function clean_up_after_error() {

    rm -f .encoded_0 .encoded_1 .encoded_2 .encoded_3 .encoded_4 .encoded_5 > /dev/null 2>&1
    rm -f .verif_0 .verif_1 .verif_2 .verif_3 .verif_4 > /dev/null 2>&1
    rm -rf basket football handball baseball rugby > /dev/null 2>&1

    rm -f Mw== NA== Mg== NQ== MQ== image > /dev/null 2>&1

    rm -rf basket football handball baseball rugby > /dev/null 2>&1

    rm -rf rugby.tar.gz baseball.tar.gz handball.tar.gz football.tar.gz basket.tar.gz > /dev/null 2>&1
    rm -rf rugby.tar baseball.tar handball.tar football.tar basket.tar > /dev/null 2>&1

    # Supprimer les groupes et utilisateurs créés
    if id "geronimo" &>/dev/null; then
        sudo deluser geronimo > /dev/null 2>&1
    fi

    if getent group "bedonkohe" &>/dev/null; then
        sudo delgroup bedonkohe > /dev/null 2>&1
    fi

    # Supprimer les dossiers et les fichiers générés
    for i in {1..10}; do
        rm -rf "$i" "archive_$i.tar" "archive_$i.tar.gz"
    done


}

function clean_up_after_step_OK(){

    rm -f Mw== NA== Mg== NQ== MQ== image > /dev/null 2>&1

    rm -rf basket football handball baseball rugby > /dev/null 2>&1

    rm -rf rugby.tar.gz baseball.tar.gz handball.tar.gz football.tar.gz basket.tar.gz > /dev/null 2>&1
    rm -rf rugby.tar baseball.tar handball.tar football.tar basket.tar > /dev/null 2>&1

    # Supprimer les groupes et utilisateurs créés
    if id "geronimo" &>/dev/null; then
        sudo deluser geronimo > /dev/null 2>&1
    fi

    if getent group "bedonkohe" &>/dev/null; then
        sudo delgroup bedonkohe > /dev/null 2>&1
    fi

    # Supprimer les dossiers et les fichiers générés
    for i in {1..10}; do
        rm -rf "$i" "archive_$i.tar" "archive_$i.tar.gz"
    done

}


# Vérifier si l'option --hard a été fournie
if [[ "$1" == "--after-error" ]]; then
    # echo "Nettoyage des fichiers et répertoires générés après la résolution"
    clean_up_after_error
elif [[ "$1" == "--clean-up-step-OK" ]]; then
    # echo "Nettoyage des fichiers et répertoires générés après la résolution"
    clean_up_after_step_OK
else

    # Pour tous les modules
    rm -f .final_time      # Supprimer le fichier d'erreurs s'il existe
    rm -f .module_OK   # Supprimer le fichier de succès s'il existe

    rm -f Mw== NA== Mg== NQ== MQ== image > /dev/null 2>&1

    rm -rf basket football handball baseball rugby > /dev/null 2>&1

    rm -rf rugby.tar.gz baseball.tar.gz handball.tar.gz football.tar.gz basket.tar.gz > /dev/null 2>&1
    rm -rf rugby.tar baseball.tar handball.tar football.tar basket.tar > /dev/null 2>&1

    rm -f .encoded_0 .encoded_1 .encoded_2 .encoded_3 .encoded_4 .encoded_5 > /dev/null 2>&1
    rm -f .verif_0 .verif_1 .verif_2 .verif_3 .verif_4 .verif_5 > /dev/null 2>&1

    pkill -f .monitor.sh > /dev/null 2>&1

    # Supprimer les groupes et utilisateurs créés
    if id "geronimo" &>/dev/null; then
        sudo deluser geronimo
    fi

    if getent group "bedonkohe" &>/dev/null; then
        sudo delgroup bedonkohe
    fi

    # Supprimer les dossiers et les fichiers générés
    for i in {1..10}; do
        rm -rf "$i" "archive_$i.tar" "archive_$i.tar.gz"
    done


    # Vérifier si l'option --hard a été fournie
    if [[ "$1" == "--hard" ]]; then
        rm -f .start_time
        rm -f .serial
        rm -f .error      # Supprimer le fichier d'erreurs s'il existe
    fi

fi