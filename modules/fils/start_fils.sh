#!/bin/bash

# Vérifier si .can_go existe avant de commencer
if [ ! -f ".can_go" ]; then
    echo "La bombe n'a pas été lancée !"
    exit 1
fi

# Supprimer tous les fichiers de couleur existants
rm -f *.txt
rm -f .encoded_1  # Supprimer le fichier temporaire s'il existe
rm -f .encoded_2  # Supprimer le fichier de liste des fichiers initiaux s'il existe

# Tableau de couleurs
couleurs=("rouge" "jaune" "noir" "bleu" "vert" "blanc")

# Fonction pour sélectionner une couleur avec des probabilités spécifiques
select_color() {
    local index=$1
    local random_num=$((RANDOM % 100))

    if [[ $index -eq 1 ]]; then
        # Premier fichier : Plus de chances d'avoir du rouge
        if [[ $random_num -lt 60 ]]; then
            echo "rouge"
        else
            echo "${couleurs[RANDOM % ${#couleurs[@]}]}"
        fi
    elif [[ $index -eq 2 ]]; then
        # Deuxième fichier : Chances égales pour toutes les couleurs
        echo "${couleurs[RANDOM % ${#couleurs[@]}]}"
    elif [[ $index -eq 3 ]]; then
        # Troisième fichier : Plus de chances d'avoir du bleu
        if [[ $random_num -lt 50 ]]; then
            echo "bleu"
        else
            echo "${couleurs[RANDOM % ${#couleurs[@]}]}"
        fi
    elif [[ $index -eq 4 ]]; then
        # Quatrième fichier : Plus de chances d'avoir du jaune
        if [[ $random_num -lt 60 ]]; then
            echo "jaune"
        else
            echo "${couleurs[RANDOM % ${#couleurs[@]}]}"
        fi
    fi
}

# Générer les fichiers (3 ou 4) avec des couleurs spécifiques
generate_files() {
    local num_files=$1
    fichiers=()

    for ((i = 1; i <= num_files; i++)); do
        couleur=$(select_color $i)
        nom_fichier="${i}_${couleur}.txt"
        
        # Créer le fichier
        touch "$nom_fichier"
        fichiers+=("$nom_fichier")
    done
}


# 1. Choisir aléatoirement entre 3 et 4 fichiers
# nombre_de_fichiers=$((RANDOM % 2 + 3))  # Génère 3 ou 4 fichiers
nombre_de_fichiers=4

# 2. Initialiser le tableau pour stocker les fichiers générés
fichiers=()

# Générer les fichiers avec des probabilités spécifiques
for i in $(seq 1 $nombre_de_fichiers); do
    if [[ $nombre_de_fichiers -eq 4 ]]; then
        generate_files 4
    else
       generate_files 3
    fi

    nom_fichier="${i}_${couleur}.txt"
    touch "$nom_fichier"
    fichiers+=("$nom_fichier")
done

# Règles pour les conditions de victoire
# 4. Lecture du numéro de série
if [ -f ".serial" ]; then
    serial=$(cat .serial)
    dernier_chiffre_serial=${serial: -1}  # Récupérer le dernier chiffre
else
    echo "Erreur : fichier .serial introuvable."
    exit 1
fi

# Initialiser variables pour analyser la condition de victoire
condition_a_verifier=""
fichier_a_supprimer=""

# 5. Vérification pour 3 fichiers
if [[ $nombre_de_fichiers -eq 3 ]]; then
    has_red=false
    for fichier in "${fichiers[@]}"; do
        if [[ "$fichier" =~ "_rouge.txt" ]]; then
            has_red=true
            break
        fi
    done

    if [[ ! "$has_red" ]]; then
        # S'il n'y a pas de fil rouge
        condition_a_verifier="Il n'y a pas de fil rouge. Vous devez supprimer le deuxième fichier."
        fichier_a_supprimer="${fichiers[1]}"
    else
        # Compter les fils bleus
        count_bleu=0
        for fichier in "${fichiers[@]}"; do
            if [[ "$fichier" =~ "_bleu.txt" ]]; then
                ((count_bleu++))
            fi
        done

        if [[ $count_bleu -gt 1 ]]; then
            # Plus d'un fil bleu
            condition_a_verifier="Plus d'un fil bleu. Vous devez supprimer le dernier fichier bleu."
            for ((j=${#fichiers[@]}-1; j>=0; j--)); do
                if [[ "${fichiers[j]}" =~ "_bleu.txt" ]]; then
                    fichier_a_supprimer="${fichiers[j]}"
                    break
                fi
            done
        elif [[ "${fichiers[-1]}" =~ "_blanc.txt" ]]; then
            # Dernier fichier est blanc
            condition_a_verifier="Le dernier fil est blanc. Vous devez supprimer le dernier fichier."
            fichier_a_supprimer="${fichiers[-1]}"
        else
            # Par défaut, supprimer le premier fichier
            condition_a_verifier="Aucune autre condition remplie. Vous devez supprimer le premier fichier."
            fichier_a_supprimer="${fichiers[0]}"
        fi
    fi
fi

# 6. Vérification pour 4 fichiers
if [[ $nombre_de_fichiers -eq 4 ]]; then
    # Compter les fils rouges
    count_red=0
    for fichier in "${fichiers[@]}"; do
        if [[ "$fichier" =~ "_rouge.txt" ]]; then
            ((count_red++))
        fi
    done

    # Condition 1 : + d'un fil rouge et dernier chiffre impair
    if [[ $count_red -gt 1 && $((dernier_chiffre_serial % 2)) -ne 0 ]]; then
        condition_a_verifier="Il y a plus d'un fil rouge et le dernier chiffre du serial est impair. Couper le dernier fil rouge."
        for ((j=${#fichiers[@]}-1; j>=0; j--)); do
            if [[ "${fichiers[j]}" =~ "_rouge.txt" ]]; then
                fichier_a_supprimer="${fichiers[j]}"
                break
            fi
        done

    # Condition 2 : dernier fil jaune et aucun fil rouge
    elif [[ "${fichiers[-1]}" =~ "_jaune.txt" && $count_red -eq 0 ]]; then
        condition_a_verifier="Le dernier fil est jaune et il n'y a pas de fil rouge. Vous devez supprimer le premier fichier."
        fichier_a_supprimer="${fichiers[0]}"

    # Condition 3 : plus d'un fil jaune
    else
        count_jaune=0
        for fichier in "${fichiers[@]}"; do
            if [[ "$fichier" =~ "_jaune.txt" ]]; then
                ((count_jaune++))
            fi
        done
        if [[ $count_jaune -gt 1 ]]; then
            condition_a_verifier="Il y a plus d'un fil jaune. Vous devez couper le dernier fichier."
            fichier_a_supprimer="${fichiers[-1]}"
        else
            # Condition 4 : couper le deuxième fichier
            condition_a_verifier="Aucune autre condition remplie. Vous devez couper le deuxième fichier."
            fichier_a_supprimer="${fichiers[1]}"
        fi
    fi
fi

# 7. Afficher et encoder le fichier à supprimer
if [[ -n "$fichier_a_supprimer" ]]; then
    echo "$condition_a_verifier (Fichier à supprimer : $fichier_a_supprimer)"
    
    # Encoder et écrire dans .encoded_1
    echo "$fichier_a_supprimer" | base64 > .encoded_1

    # Encoder et écrire dans .encoded_2
    printf "%s\n" "${fichiers[@]}" | base64 > .encoded_2
else
    echo "Aucun fichier à supprimer n'a été déterminé."
fi
