#!/bin/bash

# Fonction de log avec ajout d'un timestamp
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> log
}