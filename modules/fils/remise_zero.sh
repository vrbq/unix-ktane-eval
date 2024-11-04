#!/bin/bash

# Pour tous les modules
rm -f .final_time      # Supprimer le fichier d'erreurs s'il existe
rm -f .module_OK   # Supprimer le fichier de succès s'il existe

# Supprimer tous les fichiers de couleur existants
rm -f *.txt
rm -f .encoded_1  # Supprimer le fichier temporaire s'il existe
rm -f .encoded_2  # Supprimer le fichier de liste des fichiers initiaux s'il existe

# Vérifier si l'option --hard a été fournie
if [[ "$1" == "--hard" ]]; then
    rm -f .start_time
    rm -f .serial
    rm -f .error      # Supprimer le fichier d'erreurs s'il existe
fi