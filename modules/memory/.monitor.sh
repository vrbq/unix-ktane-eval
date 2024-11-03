#!/bin/bash

# Initialiser une variable pour stocker la valeur la plus élevée
max_value=0

# Parcourir tous les fichiers correspondant au motif .verif_
for file in .verif_*; do
    # Vérifier si le fichier existe pour éviter les erreurs
    if [[ -e $file ]]; then
        # Extraire la valeur à partir du nom du fichier
        # Supposons que la valeur est la partie après ".verif_"
        value="${file#.verif_}"

        # Vérifier si la valeur est un nombre
        if [[ $value =~ ^[0-9]+$ ]]; then
            # Mettre à jour max_value si la valeur actuelle est plus élevée
            if (( value > max_value )); then
                max_value=$value
            fi
        fi
    fi
done

current_step=$((max_value + 1))

function creation_dossiers() {
    # Crée 10 dossiers et fichiers encodés en base64
    for i in {1..10}; do
        mkdir -p "$i"
        echo "$i" | base64 > "$i/.encoded_$i"
    done

    etape=$1
    
    # Crée 10 archives (tar ou tar.gz) contenant un fichier encodé
    for i in {1..10}; do
        mkdir -p "archive_$i"
        echo "$i" | base64 > "archive_$i/.encoded_$i"
        
        if (( RANDOM % 2 == 0 )); then
            tar -cf "archive_$i.tar" "archive_$i"
        else
            tar -czf "archive_$i.tar.gz" "archive_$i"
        fi
        rm -rf "archive_$i" # Supprime le dossier temporaire
    done
    
    # Copie un fichier aléatoire depuis un répertoire distant
    repertoire_distant="../../utils/symbols"
    fichier_distant=$(ls $repertoire_distant | shuf -n 1)
    cp "$repertoire_distant/$fichier_distant" ./
    
    # Encode le nom de ce fichier dans .encoded_X (X = numéro de l'étape actuelle)
    echo "$fichier_distant" > ".encoded_$etape"

    mv $fichier_distant image
}

echo "L'etape actuelle est $current_step"

# Boucle pour gérer chaque étape jusqu'à la dernière
while [ $current_step -le 5 ]; do
    # echo "Démarrage de l'étape $current_step..."

    # Actions spécifiques à chaque étape
    case $current_step in
        1)
            # Actions de l'étape 1
            # echo "Création des dossiers et fichiers pour l'étape 1..."
            creation_dossiers $current_step
            ;;
        2)
            # Actions de l'étape 2
            # echo "Création des dossiers et fichiers pour l'étape 2..."
            creation_dossiers $current_step
            ;;
        3)
            # Actions de l'étape 3
            # echo "Création des dossiers et fichiers pour l'étape 3..."
            creation_dossiers $current_step
            ;;
        4)
            # Actions de l'étape 4
            # echo "Création des dossiers et fichiers pour l'étape 4..."
            creation_dossiers $current_step
            ;;
        5)
            # Actions de l'étape 4
            # echo "Création des dossiers et fichiers pour l'étape 4..."
            creation_dossiers $current_step
            ;;
    esac

    # Attendre que le fichier de vérification soit créé
    verif_file=".verif_$current_step"
    # echo "Attente de la validation pour l'étape $current_step (fichier $verif_file)..."
    echo "Appuyez sur Entrée pour continuer..."
    
    # Boucle d'attente pour le fichier de validation
    while [ ! -f "$verif_file" ]; do
        sleep 1  # Attendre une seconde avant de vérifier à nouveau
    done

    ./remise_zero.sh --clean-up-step-OK

    echo "Étape $current_step validée !"

    # Passer à l'étape suivante
    ((current_step++))
done

# echo "Toutes les étapes ont été validées ! Mini-jeu terminé avec succès."
