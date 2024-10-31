#!/bin/bash

# Récupérer le numéro de l'album à partir de l'argument
album_number=$1

# Vérifier si le numéro d'album est valide
if [[ $album_number -lt 1 || $album_number -gt 5 ]]; then
    echo "L'argument doit être un nombre entre 1 et 5."
    exit 1
fi

# Définir les personnages pour chaque album
album_1=("Tintin" "Milou" "Dupond et Dupont" "Professeur Tournesol")
album_2=("Tintin" "Milou" "Capitaine Haddock" "Nestor")
album_3=("Tintin" "Milou" "Capitaine Haddock" "Dupond et Dupont" "Professeur Tournesol" "Nestor")
album_4=("Tintin" "Milou" "Capitaine Haddock" "Dupond et Dupont" "Professeur Tournesol" "Nestor" "Général Alcazar")
album_5=("Tintin" "Milou" "Professeur Tournesol" "Nestor")


# Effacer le contenu du fichier "personnages" avant de commencer
> personnages

# Obtenir les personnages de l'album sélectionné
array=()

case $album_number in
    1) array=("${album_1[@]}") ;;
    2) array=("${album_2[@]}") ;;
    3) array=("${album_3[@]}") ;;
    4) array=("${album_4[@]}") ;;
    5) array=("${album_5[@]}") ;;
esac

# Mélanger le tableau de personnages
for (( i=${#array[@]}-1; i>0; i-- )); do
    j=$(( RANDOM % (i + 1) ))
    # Échange
    temp=${array[i]}
    array[i]=${array[j]}
    array[j]=$temp
done

# Ajouter les personnages au fichier une ligne à la fois
for personnage in "${array[@]}"; do
    echo "$personnage" >> personnages
    sleep 5
done
