@echo off

REM Use Minikube's Docker daemon
& minikube -p minikube docker-env --shell powershell | Invoke-Expression


REM Paths to Dockerfiles
SET FRONTEND_PATH=.\client
SET BACKEND_PATH=.\time_manager
SET K8S_CONFIG_PATH=.\kubernetes_deployment.yaml

REM Display current directory and files
echo Current directory: %CD%
dir

REM Build Docker images
echo Building Elixir image...
docker build -t elixir-app:latest %BACKEND_PATH%

echo Building Vue.js image...
docker build -t vuejs-app:latest %FRONTEND_PATH%

REM Create a namespace
kubectl create namespace time-manager

REM Set namespace for the deployments
kubectl config set-context --current --namespace=time-manager

REM Initiate Secret
kubectl apply -f secret.yaml -n time-manager

REM Initiate ConfigMap
kubectl apply -f config-map.yaml -n time-manager

REM Apply Kubernetes configuration
echo Applying Kubernetes configuration...
kubectl apply -f %K8S_CONFIG_PATH% -n time-manager

REM Wait for deployments to be ready
echo Waiting for PostgreSQL to be ready...
kubectl wait --for=condition=ready pod -l app=postgres -n time-manager

echo Waiting for Elixir backend to be ready...
kubectl wait --for=condition=ready pod -l app=elixir-backend -n time-manager

echo Waiting for Vue.js frontend to be ready...
kubectl wait --for=condition=ready pod -l app=vuejs-frontend -n time-manager

REM Open front service to external address/port
minikube service vuejs-frontend

REM Start Minikube tunnel
@REM start /B minikube tunnel

echo Deployment complete!
pause
