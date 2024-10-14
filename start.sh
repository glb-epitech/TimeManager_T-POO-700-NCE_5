#!/bin/bash

# Utiliser le daemon Docker de Minikube
eval $(minikube docker-env)

# Chemins vers les Dockerfiles
FRONTEND_PATH=".//client"
BACKEND_PATH=".//time_manager"
K8S_CONFIG_PATH=".//kubernetes_deployment.yaml"

# Afficher le répertoire courant et les fichiers
echo "Répertoire courant : $(pwd)"
echo "Fichiers dans le répertoire :"
ls -l

# Construire les images Docker
echo "Construction de l'image Vue.js..."
docker build -t vuejs-app:latest $FRONTEND_PATH

echo "Construction de l'image Elixir..."
docker build -t elixir-app:latest $BACKEND_PATH

# Creation d'un namespace
kubectl create namespace time-manager

# Initiation des secrets
kubectl apply -f postgres_secret.yaml

# Appliquer la configuration Kubernetes
echo "Application de la configuration Kubernetes..."
kubectl apply -f $K8S_CONFIG_PATH -n time-manager

# Attendre que les déploiements soient prêts
echo "Attente de la disponibilité de PostgreSQL..."
kubectl wait --for=condition=ready pod -l app=postgres -n my-namespace

echo "Attente de la disponibilité du backend Elixir..."
kubectl wait --for=condition=ready pod -l app=elixir-backend -n my-namespace

echo "Attente de la disponibilité du frontend Vue.js..."
kubectl wait --for=condition=ready pod -l app=vuejs-frontend -n my-namespace

# Démarrer le tunnel Minikube
minikube tunnel &

echo "Déploiement terminé !"