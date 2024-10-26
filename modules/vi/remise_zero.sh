#!/bin/bash

# Supprimer le fichier de citations, les instructions cachées, et le sous-répertoire
rm -f citations 
rm -f .encoded .encoded_2 .encoded_3 .encoded_3.b64 .encoded_4 .encoded_5
rm -f modifications
rm -rf burger orange pizza
rm -rf .final_time

# Vérifier si l'option --hard a été fournie
if [[ "$1" == "--hard" ]]; then
    rm -f .start_time 
    rm -f .error      # Supprimer le fichier d'erreurs s'il existe
fi