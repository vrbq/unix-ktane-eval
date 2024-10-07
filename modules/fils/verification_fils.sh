#!/bin/bash

# Vérifier si le fichier temporaire existe
if [[ ! -f .encoded_1 || ! -f .encoded_2 ]]; then
    echo "Erreur : un des fichiers de vérification n'existe pas."
    exit 1
fi

# Décoder et lire le fichier à supprimer
fichier_a_verifier=$(base64 --decode .encoded_1)

# Décoder et lire les fichiers initiaux
fichiers_initiaux=($(base64 --decode .encoded_2))

# Vérifier si le fichier a été supprimé
if [[ ! -e "$fichier_a_verifier" ]]; then
    # Si le fichier à vérifier a été supprimé, vérifier que tous les autres fichiers initiaux sont encore là
    fichiers_restants=(*.txt)

    # Vérifier que tous les autres fichiers initiaux sont encore là
    for fichier in "${fichiers_initiaux[@]}"; do
        if [[ "$fichier" != "$fichier_a_verifier" && ! " ${fichiers_restants[*]} " =~ " $fichier " ]]; then
            echo "FAILED ! Vous n'avez pas respecté les règles : le fichier $fichier a été supprimé."
            echo "Relancez un nouveau module fils."
            # Ici, tu peux appeler start_fils.sh pour relancer le module
            # ./start_fils.sh
            exit 1
        fi
    done

    # Si tous les autres fichiers sont intacts
    echo "Bravo ! Vous avez supprimé le fichier requis : $fichier_a_verifier et tous les autres fichiers sont intacts."
    echo "bravo, vous avez désamorcé la bombe !" > ./.module_OK  # Crée un fichier de flag pour arrêter le compteur
else
    echo "FAILED ! Le fichier requis n'a pas été supprimé : $fichier_a_verifier."
    echo "Relancez un nouveau module fils."
fi

# Optionnel : supprimer les fichiers temporaires après vérification
rm -f .encoded_1 .encoded_2
rm -f *.txt