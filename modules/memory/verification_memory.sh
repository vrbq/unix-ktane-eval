#!/bin/bash

#Vérifier que la bombe a bien été lancée
# Vérifier si .can_go existe avant de commencer
if [ ! -f ".can_go" ]; then
    echo "La bombe n'a pas été lancée !"
    exit 1
fi

# Fonction pour vérifier le temps écoulé
function verifier_temps_ecoule() {
    # Lire l'heure de début enregistrée
    if [[ -f .start_time ]]; then
        start_time=$(cat .start_time)
        end_time=$(date +%s)
        elapsed_time=$((end_time - start_time))
        
        # Convertir le temps écoulé en minutes et secondes
        minutes=$((elapsed_time / 60))
        seconds=$((elapsed_time % 60))

        # Afficher le temps écoulé
        echo "Le mini-jeu a été résolu en $minutes minutes et $seconds secondes."

        # Enregistrer le temps total dans le fichier .final_time
        echo "$minutes minutes et $seconds secondes" > .final_time
        
        # Supprimer le fichier de l'heure de début pour éviter les conflits
        rm .start_time
        
        # Rajouter le temps dans le .module_OK
        echo "$minutes minutes et $seconds secondes" >> .module_OK
    else
        echo "L'heure de début n'a pas été enregistrée."
    fi
}

# Gestion des erreurs
error_file=".error"

# Initialiser le compteur d'erreurs s'il n'existe pas
if [ ! -f "$error_file" ]; then
    echo 0 > "$error_file"
fi

# Fonction pour incrémenter le compteur d'erreurs
increment_error() {
    current_errors=$(cat "$error_file")
    new_errors=$((current_errors + 1))
    echo "$new_errors" > "$error_file"
    echo "Sur le module Memory, vous avez fait $(cat "$error_file") erreur(s)."
}

function error_remise_zero() {
    echo "Vous avez commis une erreur. Il vous faut relancer le module avec le script start_memory.sh."
    increment_error
    ./remise_zero.sh --after-error
}

# Vérifier si le fichier temporaire existe
if [[ ! -f .encoded_1  ]]; then
    echo "Veuillez d'abord lancé le module !"
    exit 1
fi


# Récupérer le numéro de l'étape actuelle à partir de .encoded_1
if [ ! -f ".encoded_1" ]; then
    echo "Erreur : fichier .encoded_1 manquant. Assurez-vous que le tour 1 est terminé."
    exit 1
fi

# Initialiser une variable pour stocker la valeur la plus élevée
max_value=0

# Parcourir tous les fichiers correspondant au motif .encoded_X
for file in .encoded_*; do
    # Vérifier si le fichier existe pour éviter les erreurs
    if [[ -e $file ]]; then
        # Extraire la valeur à partir du nom du fichier
        # Supposons que la valeur est la partie après ".encoded_"
        value="${file#.encoded_}"

        # Vérifier si la valeur est un nombre
        if [[ $value =~ ^[0-9]+$ ]]; then
            # Mettre à jour max_value si la valeur actuelle est plus élevée
            if (( value > max_value )); then
                max_value=$value
            fi
        fi
    fi
done

current_step=$max_value


# Décoder le fichier .encoded_1 pour obtenir le numéro de l'étape
symbol_num=$(base64 -d .encoded_$max_value)


# Vérifications pour chaque étape
case $current_step in
    1)

    case $symbol_num in
        1) 
            {
                if [ -d "basket" ] && find "basket" -type f -name ".encoded_7" | grep -q .; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                    touch .verif_1
                    
                else
                    error_remise_zero
                fi
                
            }
            ;;
        2) 
            {
                if [ -d "football" ] && find "football" -type f -name ".encoded_2" | grep -q .; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                    touch .verif_1
                    
                else
                    error_remise_zero
                fi
            }
            ;;
        3) 
            {
                if [ -d "handball" ] && find "handball" -type f -name ".encoded_9" | grep -q .; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                    touch .verif_1
                    
                else
                    error_remise_zero
                fi
            }
            ;;
        4) 
            {
                if [ -d "baseball" ] && find "baseball" -type f -name ".encoded_2" | grep -q .; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                    touch .verif_1
                    
                else
                    error_remise_zero
                fi
            }
            ;;
        *) 
            echo "Étape 1 : numéro invalide." 
            ;;
    esac

        ;;

    2)

    case "$symbol_num" in
        1)
            {
                # Étape 1 : vérifier que le dossier numéro 6 est bien archivé sous le nom "basket.tar"
                if [ -f "basket.tar" ]; then
                    tar -tf basket.tar | grep -q "6/.encoded_6"
                    if [ $? -eq 0 ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_2
                        
                    else
                        error_remise_zero
                    fi
                else
                    error_remise_zero
                fi
            }
            ;;
            
        2)
            {
                # Étape 2 : vérifier que l'utilisateur "geronimo" existe
                if id -u geronimo &>/dev/null; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                    touch .verif_2
                    
                else
                    error_remise_zero
                fi
            }
            ;;
            
        3)
            {
                # Étape 3 : vérifier que le dossier numéro 8 est bien archivé sous le nom "handball.tar"
                if [ -f "handball.tar.gz" ]; then
                    tar -tf handball.tar.gz | grep -q "8/.encoded_8"
                    if [ $? -eq 0 ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_2
                        
                    else
                        error_remise_zero
                    fi
                else
                    error_remise_zero
                fi
            }
            ;;
            
        4)
            {
                # Étape 4 : vérifier que le dossier correspondant au dernier chiffre du numéro de série est bien archivé sous le nom "rugby.tar"
                if [ -f "rugby.tar.gz" ]; then
                    # Lire le contenu du fichier .serial
                    if [ -f ".serial" ]; then
                        serial=$(cat .serial)
                        last_digit=${serial: -1}  # Récupérer le dernier chiffre
                    else
                        echo "Erreur : fichier .serial introuvable."
                        exit 1
                    fi

                    expected_file="$last_digit/.encoded_$last_digit"
                    
                    # Vérifie si le bon dossier est dans l'archive
                    tar -tf rugby.tar.gz | grep -q "$expected_file"
                    if [ $? -eq 0 ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_2
                        
                    else
                        error_remise_zero
                    fi
                else
                    error_remise_zero
                fi
            }
            ;;
            
        *)
            echo "Erreur : Étape $symbol_num non valide."
            ;;
    esac

        ;;
        
    3)
        
        case $symbol_num in
            1)
                 # Vérification pour archive_1
                if [ -e "archive_1.tar" ]; then
                    permissions=$(stat -c "%a" "archive_1.tar")
                    if [ "$permissions" -eq 751 ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_3
                    
                    else
                        error_remise_zero
                    fi
                elif [ -e "archive_1.tar.gz" ]; then
                    permissions=$(stat -c "%a" "archive_1.tar.gz")
                    if [ "$permissions" -eq 751 ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_3
                    
                    else
                        error_remise_zero
                    fi
                else
                    error_remise_zero
                fi
                ;;
            2)
                # Vérification pour archive_3
                if [ -e "archive_3.tar" ]; then
                    permissions=$(stat -c "%a" "archive_3.tar")
                    if [ "$permissions" -eq 666  ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_3
                    else
                        error_remise_zero
                    fi
                elif [ -e "archive_3.tar.gz" ]; then
                    permissions=$(stat -c "%a" "archive_3.tar.gz")
                    if [ "$permissions" -eq 666  ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_3
                    
                    else
                        error_remise_zero
                    fi
                else
                    error_remise_zero
                fi
                ;;
            3)
                # Vérification pour archive_5
                if [ -e "archive_5.tar" ]; then
                    permissions=$(stat -c "%a" "archive_5.tar")
                    if [ "$permissions" -eq 711 ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_3
                    
                    else
                        error_remise_zero
                    fi
                elif [ -e "archive_5.tar.gz" ]; then
                    permissions=$(stat -c "%a" "archive_5.tar.gz")
                    if [ "$permissions" -eq 711 ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_3
                    
                    else
                        error_remise_zero
                    fi
                else
                    error_remise_zero
                fi
                ;;
            4)
                # Vérification pour archive_4
                if [ -e "archive_4.tar" ]; then
                    permissions=$(stat -c "%a" "archive_4.tar")
                    if [ "$permissions" -eq 644 ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_3
                    
                    else
                        error_remise_zero
                    fi
                elif [ -e "archive_4.tar.gz" ]; then
                    permissions=$(stat -c "%a" "archive_4.tar.gz")
                    if [ "$permissions" -eq 644 ]; then
                        echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_3
                    
                    else
                        error_remise_zero
                    fi
                else
                    error_remise_zero
                fi
                ;;
            *)
                echo "Étape 3 : numéro invalide."
                ;;
        esac

        ;;
    4)
        case $symbol_num in
            1)
                if [ -f "archive_3.tar.gz" ] && [ "$(stat -c "%U" archive_3.tar.gz 2>/dev/null)" = "geronimo" ]; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_4
                        
                elif [ -f "archive_3.tar" ] && [ "$(stat -c "%U" archive_3.tar 2>/dev/null)" = "geronimo" ]; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                        touch .verif_4
                        
                else
                    error_remise_zero
                fi
                ;;
            2)
                if grep -q "^bedonkohe:" /etc/group; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                    touch .verif_4
                    
                else
                    error_remise_zero
                fi
                ;;
            3)
                if id -nG geronimo | grep -q "\<bedonkohe\>"; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                    touch .verif_4
                    
                else
                    error_remise_zero
                fi
                ;;
            4)
                if [ -f ".serial" ]; then
                    serial=$(cat .serial)
                    last_digit=${serial: -1}  # Récupérer le dernier chiffre
                else
                    echo "Erreur : fichier .serial introuvable."
                    exit 1
                fi
                
                nom_dossier="rugby"
                archive_name="archive_$last_digit"

                if [ -d $nom_dossier ] && find $nom_dossier -type f -name ".encoded_$last_digit" | grep -q .; then
                    echo "Bravo ! Vous passez à la prochaine étape !"
                    touch .verif_4
                    
                else
                    error_remise_zero
                fi
                ;;
            *)
                echo "Erreur : numéro invalide dans .encoded_1."
                ;;
        esac
        ;;
    5)

    echo "symbol_num : $symbol_num"

        # Vérifier le numéro et afficher les messages appropriés
        if [ "$symbol_num" -eq 1 ]; then
            symbol_num_etape5=$(base64 -d .encoded_1)
            echo "symbol_num_etape5 : $symbol_num_etape5"

                case $symbol_num_etape5 in
                    1) 
                        {
                            if [ -d "basket" ] && find "basket" -type f -name ".encoded_7" | grep -q .; then
                                verifier_temps_ecoule
                            else
                                error_remise_zero
                            fi
                            
                        }
                        ;;
                    2) 
                        {
                            if [ -d "football" ] && find "football" -type f -name ".encoded_2" | grep -q .; then
                                verifier_temps_ecoule
                            else
                                error_remise_zero
                            fi
                        }
                        ;;
                    3) 
                        {
                            if [ -d "handball" ] && find "handball" -type f -name ".encoded_9" | grep -q .; then
                                verifier_temps_ecoule
                            else
                                error_remise_zero
                            fi
                        }
                        ;;
                    4) 
                        {
                            if [ -d "baseball" ] && find "baseball" -type f -name ".encoded_2" | grep -q .; then
                                verifier_temps_ecoule
                            else
                                error_remise_zero
                            fi
                        }
                        ;;
                    *) 
                        echo "Étape 1 : numéro invalide." 
                        ;;
                esac
        
        
        elif [ "$symbol_num" -eq 2 ]; then

        symbol_num_etape5=$(base64 -d .encoded_2)
         echo "symbol_num_etape5 : $symbol_num_etape5"

        case "$symbol_num_etape5" in
            1)
                {
                    # Étape 1 : vérifier que le dossier numéro 6 est bien archivé sous le nom "basket.tar"
                    if [ -f "basket.tar" ]; then
                        tar -tf basket.tar | grep -q "6/.encoded_6"
                        if [ $? -eq 0 ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    else
                        error_remise_zero
                    fi
                }
                ;;
                
            2)
                {
                    # Étape 2 : vérifier que l'utilisateur "geronimo" existe
                    if id -u geronimo &>/dev/null; then
                        verifier_temps_ecoule
                    else
                        error_remise_zero
                    fi
                }
                ;;
                
            3)
                {
                    # Étape 3 : vérifier que le dossier numéro 8 est bien archivé sous le nom "handball.tar"
                    if [ -f "handball.tar.gz" ]; then
                        tar -tf handball.tar.gz | grep -q "8/.encoded_8"
                        if [ $? -eq 0 ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    else
                        error_remise_zero
                    fi
                }
                ;;
                
            4)
                {
                    # Étape 4 : vérifier que le dossier correspondant au dernier chiffre du numéro de série est bien archivé sous le nom "rugby.tar"
                    if [ -f "rugby.tar.gz" ]; then
                        # Lire le contenu du fichier .serial
                        if [ -f ".serial" ]; then
                            serial=$(cat .serial)
                            last_digit=${serial: -1}  # Récupérer le dernier chiffre
                        else
                            echo "Erreur : fichier .serial introuvable."
                            exit 1
                        fi

                        expected_file="$last_digit/.encoded_$last_digit"
                        
                        # Vérifie si le bon dossier est dans l'archive
                        tar -tf rugby.tar.gz | grep -q "$expected_file"
                        if [ $? -eq 0 ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    else
                        error_remise_zero
                    fi
                }

        esac
        
        
        
        elif [ "$symbol_num" -eq 4 ]; then
            symbol_num_etape5=$(base64 -d .encoded_3)
             echo "symbol_num_etape5 : $symbol_num_etape5"

            case $symbol_num_etape5 in
                1)
                    # Vérification pour archive_1
                    if [ -e "archive_1.tar" ]; then
                        permissions=$(stat -c "%a" "archive_1.tar")
                        if [ "$permissions" -eq 751 ]; then
                            verifier_temps_ecoule
                        else
                           error_remise_zero
                        fi
                    elif [ -e "archive_1.tar.gz" ]; then
                        permissions=$(stat -c "%a" "archive_1.tar.gz")
                        if [ "$permissions" -eq 751 ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    else
                        error_remise_zero
                    fi
                    ;;
                2)
                    # Vérification pour archive_3
                    if [ -e "archive_3.tar" ]; then
                        permissions=$(stat -c "%a" "archive_3.tar")
                        if [ "$permissions" -eq 666  ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    elif [ -e "archive_3.tar.gz" ]; then
                        permissions=$(stat -c "%a" "archive_3.tar.gz")
                        if [ "$permissions" -eq 666  ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    else
                        error_remise_zero
                    fi
                    ;;
                3)
                    # Vérification pour archive_5
                    if [ -e "archive_5.tar" ]; then
                        permissions=$(stat -c "%a" "archive_5.tar")
                        if [ "$permissions" -eq 711 ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    elif [ -e "archive_5.tar.gz" ]; then
                        permissions=$(stat -c "%a" "archive_5.tar.gz")
                        if [ "$permissions" -eq 711 ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    else
                        error_remise_zero
                    fi
                    ;;
                4)
                    # Vérification pour archive_4
                    if [ -e "archive_4.tar" ]; then
                        permissions=$(stat -c "%a" "archive_4.tar")
                        if [ "$permissions" -eq 644 ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    elif [ -e "archive_4.tar.gz" ]; then
                        permissions=$(stat -c "%a" "archive_4.tar.gz")
                        if [ "$permissions" -eq 644 ]; then
                            verifier_temps_ecoule
                        else
                            error_remise_zero
                        fi
                    else
                        error_remise_zero
                    fi
                    ;;
                *)

        esac
        
        elif [ "$symbol_num" -eq 3 ]; then
            symbol_num_etape5=$(base64 -d .encoded_4)
             echo "symbol_num_etape5 : $symbol_num_etape5"

            case $symbol_num_etape5 in
                1)
                    if [ -f "archive_3.tar.gz" ] && [ "$(stat -c "%U" archive_3.tar.gz 2>/dev/null)" = "geronimo" ]; then
                        verifier_temps_ecoule
                    elif [ -f "archive_3.tar" ] && [ "$(stat -c "%U" archive_3.tar 2>/dev/null)" = "geronimo" ]; then
                        verifier_temps_ecoule
                    else
                        error_remise_zero
                    fi
                    ;;
                2)
                    if grep -q "^bedonkohe:" /etc/group; then
                        verifier_temps_ecoule
                    else
                        error_remise_zero
                    fi
                    ;;
                3)
                    if id -nG geronimo | grep -q "\<bedonkohe\>"; then
                        verifier_temps_ecoule
                    else
                        error_remise_zero
                    fi
                    ;;
                4)
                    if [ -f ".serial" ]; then
                        serial=$(cat .serial)
                        last_digit=${serial: -1}  # Récupérer le dernier chiffre
                    else
                        echo "Erreur : fichier .serial introuvable."
                        exit 1
                    fi
                    
                    if [ -f ".serial" ]; then
                    serial=$(cat .serial)
                    last_digit=${serial: -1}  # Récupérer le dernier chiffre
                    else
                        echo "Erreur : fichier .serial introuvable."
                        exit 1
                    fi
                    
                    nom_dossier="rugby"
                    archive_name="archive_$last_digit"

                    if [ -d $nom_dossier ] && find $nom_dossier -type f -name ".encoded_$last_digit" | grep -q .; then
                        verifier_temps_ecoule
                    else
                        error_remise_zero
                    fi
                    ;;
                *)
                    echo "Erreur : numéro d'étape invalide."
                    ;;
            esac
        else
            echo "Étape 5 : numéro invalide."
        fi

        ;;
    *)
        echo "Erreur : Étape inconnue."
        exit 1
        ;;
esac

# verifier_temps_ecoule