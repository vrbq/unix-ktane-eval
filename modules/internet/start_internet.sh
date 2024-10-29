#!/bin/bash

# # Vérifier si .can_go existe avant de commencer
# if [ ! -f ".can_go" ]; then
#     echo "La bombe n'a pas été lancée !"
#     exit 1
# fi

# serial=$(cat .serial)
# # Vérifier que le serial n'est pas vide
# if [ -z "$serial" ]; then
#     echo "Erreur : le fichier .serial est vide."
#     exit 1
# fi

# Vérifie si chafa est installé
if ! command -v chafa &> /dev/null; then
    echo "Le module chafa n'est pas installé. Veuillez l'installer pour continuer."
    exit 1
fi

# Remise a zero du jeu
./remise_zero.sh

# Vérifier si le fichier .start_time existe déjà
if [[ ! -f .start_time ]]; then
    start_time=$(date +%s)
    echo $start_time > .start_time
fi


# Décode le fichier GIF pour obtenir le mot
gif_file_base64=$(ls *.gif)
echo "Le fichier GIF est : $gif_file_base64"
gif_sans_extension=$(basename "$gif_file_base64" .gif)
gif_file=$(echo "$gif_sans_extension" | base64 --decode)
echo "Le fichier GIF décodé est : $gif_file"
mot=$(echo "$gif_file" | grep -o -E '\w+')
echo "Le mot est : $mot"

# Fonction pour encoder en base64 le contenu d'un fichier et l'ajouter à .encoded
encode_and_store() {
    local content="$1"
    echo "$content" | base64 >> .encoded
}

# Exécution de l'action en fonction du mot
if [ "$mot" == "vitre" ]; then
    address=$(ping -c 1 telecom.insa-lyon.fr | grep -oP '(\d+\.\d+\.\d+)\.\d+' | head -n 1)
    address="${address%.*}"
    encode_and_store "$address"

elif [ "$mot" == "ville" ]; then
    wget -q https://people.sc.fsu.edu/~jburkardt/data/csv/hw_25000.csv
    size=$(stat -c %s hw_25000.csv)
    rm hw_25000.csv
    encode_and_store "$size"

elif [ "$mot" == "chose" ]; then
    ping -c 3 x.com > .result
    domain_name="x.com"
    packets_transmitted=$(grep -oP '\d+(?= packets transmitted)' .result)
    encode_and_store "$domain_name"
    encode_and_store "$packets_transmitted"
    rm .result

elif [ "$mot" == "signe" ]; then
    wget -q https://people.sc.fsu.edu/~jburkardt/data/csv/hw_25000.csv
    filetype=$(file -b hw_25000.csv)
    rm hw_25000.csv
    encode_and_store "$filetype"

elif [ "$mot" == "linge" ]; then
    wget -q https://people.sc.fsu.edu/~jburkardt/data/svg/lines02.svg
    size=$(du -h lines02.svg | awk '{print $1}' | sed 's/K//')
    echo "La taille du fichier est : $size"
    rm lines02.svg
    encode_and_store "$size"

elif [ "$mot" == "ligne" ]; then
    wget -q https://people.sc.fsu.edu/~jburkardt/data/hdf/jet2.hdf
    filetype=$(file -b jet2.hdf)
    rm jet2.hdf
    encode_and_store "$filetype"

elif [ "$mot" == "champ" ]; then
    ping -c 3 google.fr > .result
    domain_name="google.fr"
    packets_transmitted=$(grep -oP '\d+(?= packets transmitted)' .result)
    encode_and_store "$domain_name"
    encode_and_store "$packets_transmitted"
    rm .result

elif [ "$mot" == "litre" ]; then
    address=$(ping -c 1 cpe.fr | grep -oP '(\d+\.\d+\.\d+)\.\d+' | head -n 1)
    # Ne conserver que les trois premiers octets
    address="${address%.*}"
    encode_and_store "$address"

elif [ "$mot" == "chaud" ]; then
    interface_count=$(ip link show | grep -c '^[0-9]')
    encode_and_store "$interface_count"

elif [ "$mot" == "bille" ]; then
    wget -q https://people.sc.fsu.edu/~jburkardt/data/obj/lamp.obj
    size=$(du -h lamp.obj | awk '{print $1}' | sed 's/K//')
    echo "La taille du fichier est : $size"
    rm lamp.obj
    encode_and_store "$size"

elif [ "$mot" == "balle" ]; then
    mtu=$(ip link show lo | grep -oP 'mtu \d+' | awk '{print $2}')
    encode_and_store "$mtu"

else
    echo "Mot non reconnu. Aucune action n'a été effectuée."
fi
