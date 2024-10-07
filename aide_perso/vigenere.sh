#!/bin/bash

# Fonction pour déchiffrer une ligne avec le chiffre de Vigenère
decrypt_vigenere_line() {
    local ligne="$1"
    local cle="$2"
    local decrypted=""
    key_length=${#cle}
    cle_index=0  # Réinitialiser l'index de la clé

    # Déchiffrer la ligne
    for ((i = 0; i < ${#ligne}; i++)); do
        c="${ligne:i:1}"
        if [[ "$c" =~ [A-Za-z] ]]; then
            # Obtenir le code ASCII de la lettre
            if [[ "$c" == [A-Z] ]]; then
                c_num=$(( $(printf "%d" "'$c") - $(printf "%d" "'A") ))
            else
                c_num=$(( $(printf "%d" "'$c") - $(printf "%d" "'a") ))
            fi
            
            # Obtenir la clé correspondante
            k="${cle:$cle_index:1}"
            if [[ "$k" == [A-Z] ]]; then
                k_num=$(( $(printf "%d" "'$k") - $(printf "%d" "'A") ))
            else
                k_num=$(( $(printf "%d" "'$k") - $(printf "%d" "'a") ))
            fi
            
            # Déchiffrement : P = (C - K + 26) mod 26
            p_num=$(( (c_num - k_num + 26) % 26 ))
            if [[ "$c" == [A-Z] ]]; then
                decrypted+=$(printf "\\$(printf "%03o" $((p_num + $(printf "%d" "'A"))))")
            else
                decrypted+=$(printf "\\$(printf "%03o" $((p_num + $(printf "%d" "'a"))))")
            fi

            # Incrémenter l'index de la clé uniquement pour les lettres
            ((cle_index++))
            cle_index=$((cle_index % key_length))  # Réinitialiser si nécessaire
        else
            decrypted+="$c"  # Conserver les caractères non alphabétiques
        fi
    done

    # Afficher la ligne déchiffrée
    echo "$decrypted"
}

# Vérification des arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <fichier_chiffre> <cle>"
    exit 1
fi

# Lire le fichier ligne par ligne
fichier="$1"
cle="$2"

while IFS= read -r ligne; do
    # Appeler la fonction de déchiffrement pour chaque ligne
    decrypt_vigenere_line "$ligne" "$cle"
done < "$fichier"
