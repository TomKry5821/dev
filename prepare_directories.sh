#!/bin/bash

# Definicja użytkowników i grup
APP_USER=1001
POSTGRES_USER=999
DOCKER_GROUP=$(getent group docker | cut -d: -f3) # Pobiera GID grupy docker, jeśli istnieje

# Lista katalogów i przypisanych właścicieli
declare -A DIRS=(
  ["./logs/reservation"]=$APP_USER
  ["./logs/notification"]=$APP_USER
  ["./logs/keycloak"]=$APP_USER
  ["./logs/rabbit"]=$APP_USER
  ["./logs/traefik"]=$APP_USER
  ["./logs/cadvisor"]=$APP_USER
  ["./db-data"]=$POSTGRES_USER
)

# Tworzenie katalogów i nadawanie uprawnień
for dir in "${!DIRS[@]}"; do
  mkdir -p "$dir"
done

# Lista plików .env do utworzenia
ENV_FILES=(
  "./env/reservation/.env"
  "./env/notification/.env"
  "./env/keycloak/.env"
  "./env/rabbit/.env"
  "./env/database/.env"
)
mkdir -p ./env/reservation
mkdir -p ./env/notification
mkdir -p ./env/keycloak
mkdir -p ./env/rabbit
mkdir -p ./env/database

# Tworzenie plików .env, jeśli nie istnieją
for file in "${ENV_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    touch "$file"
    echo "Plik $file został utworzony."
  fi
done

echo "Katalogi, pliki .env i uprawnienia zostały poprawnie skonfigurowane."
