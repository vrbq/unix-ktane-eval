#!/bin/bash

#Vérifier que la bombe a bien été lancée
# Vérifier si .can_go existe avant de commencer
if [ ! -f ".can_go" ]; then
    echo "La bombe n'a pas été lancée !"
    exit 1
fi

# Vérifier si le fichier temporaire existe
if [[ ! -f .encoded_1 || ! -f .encoded_2 ]]; then
    echo "Veuillez d'abord lancé le module fils !"
    exit 1
fi

# Décoder et lire le fichier à supprimer
fichier_a_verifier=$(base64 --decode .encoded_1)

# Décoder et lire les fichiers initiaux
fichiers_initiaux=($(base64 --decode .encoded_2))


# Gestion des erreurs
error_file=".error"

if [[ -z "$fichier_a_supprimer" ]]; then
    # Condition non bonne, incrémenter le compteur d'erreurs
    if [ -f "$error_file" ]; then
        error_count=$(cat "$error_file")
        ((error_count++))
    else
        error_count=1
    fi
    echo "$error_count" > "$error_file"
fi

# Vérifier si le fichier a été supprimé
if [[ ! -e "$fichier_a_verifier" ]]; then

    # Si tous les autres fichiers sont intacts
    echo "Bravo ! Vous avez supprimé le bon fichier ($fichier_a_verifier) ! "
    echo "Module fils désamorcé" > ./.module_OK  # Crée un fichier de flag pour arrêter le compteur
    [ -f "$error_file" ] && rm -f "$error_file"
else
    echo "FAILED ! Le fichier requis n'a pas été supprimé : $fichier_a_verifier."
    echo "Relancez un nouveau module fils."
    echo "Sur le module Fils, vous avez fait $(cat $error_file) erreur(s)."
fi

# Optionnel : supprimer les fichiers temporaires après vérification
rm -f .encoded_1 .encoded_2
rm -f *.txt