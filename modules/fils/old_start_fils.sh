#!/bin/bash

# Vérifier si .can_go existe avant de commencer
if [ ! -f ".can_go" ]; then
    echo "La bombe n'a pas été lancé !"
    exit 1
fi

# Supprimer tous les fichiers de couleur existants
rm -f *.txt
rm -f .encoded_1  # Supprimer le fichier temporaire s'il existe
rm -f .encoded_2  # Supprimer le fichier de liste des fichiers initiaux s'il existe

# Tableau de couleurs
couleurs=("rouge" "jaune" "noir" "bleu" "vert" "blanc")

# Créer exactement 3 fichiers texte avec des couleurs aléatoires
fichiers=()
for i in {1..3}; do
    if [[ $i -eq 3 ]]; then
        # Dernier fil : 40% blanc, 20% rouge, 20% bleu, 20% autre couleur
        random_num=$((RANDOM % 100))
        if [[ $random_num -lt 40 ]]; then
            couleur="blanc"  # 40% de chance d'être blanc
        elif [[ $random_num -lt 60 ]]; then
            couleur="rouge"  # 20% de chance d'être rouge
        elif [[ $random_num -lt 80 ]]; then
            couleur="bleu"   # 20% de chance d'être bleu
        else
            couleur=${couleurs[RANDOM % ${#couleurs[@]}]}
            # Exclure "rouge" pour les autres couleurs
            while [[ "$couleur" == "rouge" ]]; do
                couleur=${couleurs[RANDOM % ${#couleurs[@]}]}
            done
        fi
    elif [[ $i -eq 1 ]]; then
        # Premier fil : 60% bleu, 30% rouge, 10% autre couleur
        random_num=$((RANDOM % 100))
        if [[ $random_num -lt 60 ]]; then
            couleur="bleu"  # 60% de chance d'être bleu
        elif [[ $random_num -lt 90 ]]; then
            couleur="rouge"  # 30% de chance d'être rouge
        else
            couleur=${couleurs[RANDOM % ${#couleurs[@]}]}
            # Exclure "rouge" pour les autres couleurs
            while [[ "$couleur" == "rouge" ]]; do
                couleur=${couleurs[RANDOM % ${#couleurs[@]}]}
            done
        fi
    elif [[ $i -eq 2 ]]; then
        # Deuxième fil : 50% rouge, 40% bleu, 10% autre couleur
        random_num=$((RANDOM % 100))
        if [[ $random_num -lt 50 ]]; then
            couleur="rouge"  # 50% de chance d'être rouge
        elif [[ $random_num -lt 90 ]]; then
            couleur="bleu"  # 40% de chance d'être bleu
        else
            couleur=${couleurs[RANDOM % ${#couleurs[@]}]}
            # Exclure "rouge" pour les autres couleurs
            while [[ "$couleur" == "rouge" ]]; do
                couleur=${couleurs[RANDOM % ${#couleurs[@]}]}
            done
        fi
    fi

    nom_fichier="${i}_${couleur}.txt"
    
    # Créer le fichier
    touch "$nom_fichier"
    fichiers+=("$nom_fichier")
done

# echo "Fichiers générés :"
# ls *.txt
echo "Le mini-jeu a été lancé ! Veuillez suivre les instructions pour supprimer des fichiers selon les règles du jeu."

# Analyser les conditions de victoire
condition_a_verifier=""
fichier_a_supprimer=""

# Vérifier la présence d'un fil rouge
has_red=false
for fichier in "${fichiers[@]}"; do
    if [[ "$fichier" =~ "_rouge.txt" ]]; then
        has_red=true
        break
    fi
done

# Vérifier les conditions de victoire
if [[ ! " ${fichiers[*]} " =~ "1_rouge.txt" ]] && [[ ! " ${fichiers[*]} " =~ "2_rouge.txt" ]] && [[ ! " ${fichiers[*]} " =~ "3_rouge.txt" ]]; then
    # S'il n'y a pas de fil rouge, supprimer le deuxième fichier
    condition_a_verifier="Il n'y a pas de fil rouge. Vous devez supprimer le deuxième fichier."
    fichier_a_supprimer="${fichiers[1]}"  # Deuxième fichier
else
    # Compter le nombre de fichiers bleus
    count_bleu=0
    for fichier in "${fichiers[@]}"; do
        if [[ "$fichier" =~ "_bleu.txt" ]]; then
            ((count_bleu++))
        fi
    done

    if [[ $count_bleu -gt 1 ]]; then
        # Si plus d'un fil bleu, il faut supprimer le dernier fichier bleu
        condition_a_verifier="Plus d'un fil bleu. Vous devez supprimer le dernier fichier bleu."
        
        # Trouver le dernier fichier bleu
        for ((j=${#fichiers[@]}-1; j>=0; j--)); do
            if [[ "${fichiers[j]}" =~ "_bleu.txt" ]]; then
                fichier_a_supprimer="${fichiers[j]}"  # Récupérer le nom du dernier fichier bleu
                break
            fi
        done
    elif [[ "${fichiers[-1]}" =~ "_blanc.txt" ]]; then
        # Si le dernier fichier est blanc, supprimer le dernier fichier
        condition_a_verifier="Le dernier fil est blanc. Vous devez supprimer le dernier fichier."
        fichier_a_supprimer="${fichiers[-1]}"  # Dernier fichier
    else
        # Par défaut, supprimer le premier fichier
        condition_a_verifier="Aucune autre condition remplie. Vous devez supprimer le premier fichier."
        fichier_a_supprimer="${fichiers[0]}"  # Premier fichier
    fi
fi

# Afficher la condition à vérifier pour le joueur
if [[ -n "$fichier_a_supprimer" ]]; then
    # echo "$condition_a_verifier (Fichier à supprimer : $fichier_a_supprimer)"
    
    # Encoder et écrire dans .encoded_1
    echo "$fichier_a_supprimer" | base64 > .encoded_1

    # Encoder et écrire dans .encoded_2
    printf "%s\n" "${fichiers[@]}" | base64 > .encoded_2
else
    echo "Aucun fichier à supprimer n'a été déterminé."
fi
