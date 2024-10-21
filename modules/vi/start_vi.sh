#!/bin/bash

# Remise a zero du jeu
./remise_zero.sh

# Générer un fichier texte de citations numérotées
generate_citations() {
citations=(
    "\"Le plus grand risque est de ne prendre aucun risque. Dans un monde qui change rapidement, la seule stratégie garantie de rater est de ne pas prendre de risques.\" - Mark Zuckerberg"
    "\"La vie est un défi, relève-le !\" - Mère Teresa"
    "\"Ce qui ne me tue pas me rend plus fort.\" - Friedrich Nietzsche"
    "\"Le succès n'est pas la clé du bonheur. Le bonheur est la clé du succès. Si vous aimez ce que vous faites, vous réussirez.\" - Albert Schweitzer"
    "\"La seule façon de faire du bon travail est d'aimer ce que vous faites.\" - Steve Jobs"
    "\"Nous ne voyons pas les choses comme elles sont, nous les voyons comme nous sommes.\" - Anaïs Nin"
    "\"La simplicité est la sophistication suprême.\" - Léonard de Vinci"
    "\"Tout ce dont vous avez besoin est déjà en vous, vous devez juste le réaliser.\" - Eckhart Tolle"
    "\"La meilleure façon de prédire l'avenir est de l'inventer.\" - Alan Kay"
    "\"Il n'y a pas d'échec, seulement des retours d'expérience.\" - Robert Allen"
    "\"La vie est un mystère qu'il faut vivre, et non un problème à résoudre.\" - Gandhi"
    "\"Ne soyez pas poussé par vos problèmes, mais guidé par vos rêves.\" - Ralph Waldo Emerson"
    "\"Le bonheur n'est pas quelque chose de prêt à l'emploi. Il vient de vos propres actions.\" - Dalaï Lama"
    "\"Le voyage de mille miles commence par un pas.\" - Lao Tseu"
    "\"Tout ce que nous sommes est le résultat de ce que nous avons pensé.\" - Bouddha"
    "\"Il est impossible de vivre sans échouer à quelque chose, à moins que vous ne viviez si prudemment que vous n'auriez pas vécu du tout, auquel cas vous avez échoué par défaut.\" - J.K. Rowling"
    "\"Vous ne trouvez pas le bonheur, vous le créez.\" - Camilla Eyring Kimball"
    "\"Il ne s'agit pas de savoir si vous êtes capable, il s'agit de savoir si vous êtes prêt.\" - Eric Thomas"
    "\"La seule manière de faire un excellent travail est d'aimer ce que vous faites.\" - Steve Jobs"
    "\"Le meilleur moyen de prédire l'avenir est de l'inventer.\" - Peter Drucker"
    "\"Il n'y a pas de réussite sans échec.\" - L. Ron Hubbard"
    "\"Les opportunités ne se présentent pas, elles se créent.\" - Chris Grosser"
    "\"Le succès est la somme de petits efforts répétés jour après jour.\" - Robert Collier"
    "\"Ne regardez pas l'horloge ; faites ce qu'elle fait. Continuez à avancer.\" - Sam Levenson"
    "\"Vous êtes jamais trop vieux pour vous fixer un nouvel objectif ou rêver un nouveau rêve.\" - C.S. Lewis"
    "\"Ce qui compte, ce n'est pas ce que vous regardez, mais ce que vous voyez.\" - Henry David Thoreau"
    "\"Ne laissez pas le bruit des opinions des autres étouffer votre propre voix.\" - Steve Jobs"
    "\"Le passé ne peut être changé. L'avenir est encore entre vos mains.\" - Anonyme"
    "\"Soyez le changement que vous voulez voir dans le monde.\" - Gandhi"
    "\"La chose la plus difficile est la décision d'agir, le reste n'est que ténacité.\" - Amelia Earhart"
    "\"La seule véritable erreur est celle dont nous ne tirons aucun enseignement.\" - John Powell"
    "\"Visez la lune. Même si vous la ratez, vous atterrirez parmi les étoiles.\" - Les Brown"
    "\"Faites ce que vous pouvez, avec ce que vous avez, où vous êtes.\" - Theodore Roosevelt"
    "\"Les défis sont ce qui rend la vie intéressante, et les surmonter est ce qui lui donne du sens.\" - Joshua J. Marine"
    "\"L'avenir appartient à ceux qui croient à la beauté de leurs rêves.\" - Eleanor Roosevelt"
)



    # Choisir un nombre de citations entre 5 et 20
    nb_citations=$((RANDOM % 16 + 5))
    echo "" > citations

    # Sélectionner les citations aléatoirement et les écrire dans le fichier
    for i in $(seq 1 $nb_citations); do
        citation=${citations[$RANDOM % ${#citations[@]}]}
        echo "$i. $citation" >> citations
    done
}

# Déterminer le nom de l'animal en fonction du numéro de série
# Déterminer le nom de l'animal en fonction du numéro de série
determine_animal_name() {
    serial=$(cat .serial)
    
    # Vérifier que le serial n'est pas vide
    if [ -z "$serial" ]; then
        echo "Erreur : le fichier .serial est vide."
        exit 1
    fi
    
    consonnes=$(echo "$serial" | grep -o '[BCDFGHJKLMNPQRSTVWXYZ]' | wc -l)
    
    # Vérifier que le dernier caractère est un chiffre
    dernier_chiffre=${serial: -1}
    if ! [[ "$dernier_chiffre" =~ ^[0-9]$ ]]; then
        echo "Erreur : le dernier caractère du serial n'est pas un chiffre."
        exit 1
    fi
    
    if [[ $consonnes -eq 0 && $((dernier_chiffre % 2)) -eq 0 ]]; then
        animal="lion"
    elif [[ $consonnes -eq 1 && $((dernier_chiffre % 2)) -eq 0 ]]; then
        animal="elephant"
    elif [[ $consonnes -eq 2 && $((dernier_chiffre % 2)) -eq 0 ]]; then
        animal="koala"
    elif [[ $consonnes -eq 0 && $((dernier_chiffre % 2)) -ne 0 ]]; then
        animal="panda"
    elif [[ $consonnes -eq 1 && $((dernier_chiffre % 2)) -ne 0 ]]; then
        animal="kangourou"
    else
        animal="crocodile"
    fi
    
    echo "$animal"
}


# Déterminer le répertoire en fonction des voyelles
determine_directory_name() {
    serial=$(cat .serial)
    voyelles=$(echo "$serial" | grep -o '[aeiouyAEIOUY]' | wc -l | tr -d ' ')

    # Vérifier si voyelles est bien un nombre
    if ! echo "$voyelles" | grep -qE '^[0-9]+$'; then
        echo "Erreur : le nombre de voyelles n'est pas valide."
        exit 1
    fi

    if [ "$voyelles" -eq 0 ]; then
        directory="burger"
    elif [ "$voyelles" -eq 1 ]; then
        directory="orange"
    else
        directory="pizza"
    fi

    echo "$directory"
}


# Générer les instructions de modifications aléatoires
generate_modifications() {
    nb_modifications=$((RANDOM % 3 + 2))
    modifications=("Supprimer la ligne X" "Renommer la ligne X en ligne Y"
                   "Supprimer les guillemets de la ligne X"
                   "Supprimer le nom d'auteur de la ligne X"
                   "Ne laisser que le nom de l'auteur de la ligne X")
    
    instructions=()
    lines=($(seq 1 $nb_citations))
    for i in $(seq 1 $nb_modifications); do
        mod=${modifications[$RANDOM % ${#modifications[@]}]}
        line=${lines[$RANDOM % ${#lines[@]}]}
        instructions+=("$mod $line")
        lines=(${lines[@]/$line}) # Supprimer la ligne choisie
    done
    echo "${instructions[@]}"
}

# Créer le fichier "encoded" en base64
create_encoded_file() {
    animal=$(determine_animal_name)
    directory=$(determine_directory_name)
    modifications=$(generate_modifications)

    echo -e "$animal\n$directory\n$modifications" | base64 > .encoded
}

# Générer le fichier de citations
generate_citations

# Déterminer l'animal et le répertoire
animal=$(determine_animal_name)
directory=$(determine_directory_name)

# # Créer le fichier de citation et le répertoire
# mkdir -p "$directory"
# mv citations.txt "$directory/$animal.txt"

# Générer les instructions cachées
modifications=()
# Définir le fichier de citations
citation_file="citations"
num_citations=$(wc -l < "$citation_file")

# Vérifiez si le fichier de citations est vide
if [[ $num_citations -eq 0 ]]; then
    echo "Erreur : le fichier de citations est vide."
    exit 1
fi

# Choisir des lignes uniques
declare -A selected_lines

# Fonction pour obtenir une ligne unique
get_unique_line() {
    local line
    while true; do
        line=$((RANDOM % num_citations + 1))
        if [[ -z ${selected_lines[$line]} ]]; then
            selected_lines[$line]=1
            echo $line
            return
        fi
    done
}

# Obtenir les lignes uniques pour les modifications
line_remove=$(get_unique_line)
line_rename=$(get_unique_line)
line_remove_quotes=$(get_unique_line)
line_remove_author=$(get_unique_line)

# Copier le fichier de citations
temp_file="temp_citation.txt"
cp "$citation_file" "$temp_file"


# Enregistrer les modifications à apporter
modifications=()
modifications+=("Supprimer la ligne $line_remove")
modifications+=("Renommer la ligne $line_rename en ligne $((line_rename + 1))")
modifications+=("Supprimer les guillemets de la ligne $line_remove_quotes")
modifications+=("Supprimer le nom d'auteur de la ligne $line_remove_author")

# Créer un fichier pour enregistrer les modifications
modifications_file=".encoded_3"
printf "%s\n" "${modifications[@]}" > "$modifications_file"
base64 "$modifications_file" > "$modifications_file.b64"
rm "$modifications_file"  # Supprimer le fichier brut après encodage


# Appliquer les modifications sur le fichier copié
# 1. Supprimer la ligne
sed -i "${line_remove}d" "$temp_file"

# 2. Renommer la ligne (ajouter un nouveau numéro)
line_content=$(sed -n "${line_rename}p" "$temp_file")
sed -i "${line_rename}d" "$temp_file"
# Insérer la ligne à la nouvelle position
mv "$temp_file" "$temp_file.bak"  # Créer une sauvegarde
awk -v new_line_number=$((line_rename + 1)) -v content="$line_content" 'NR==new_line_number{print content; next} 1' "$temp_file.bak" > "$temp_file"
rm "$temp_file.bak"  # Supprimer la sauvegarde

# 3. Supprimer les guillemets de la ligne
sed -i "${line_remove_quotes}s/\"//g" "$temp_file"

# 4. Supprimer le nom d'auteur de la ligne
sed -i "${line_remove_author}s/ - .*$//" "$temp_file"



# Encoder le fichier modifié et le sauvegarder
encoded_file=".encoded_2"
base64 "$temp_file" > "$encoded_file"

# Nettoyage : Supprimer le fichier temporaire
rm "$temp_file"

echo "Modifications appliquées et encodées dans le fichier $encoded_file."