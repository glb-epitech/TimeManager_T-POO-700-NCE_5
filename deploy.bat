@echo off

REM Use Minikube's Docker daemon
FOR /F "tokens=*" %%i IN ('minikube docker-env') DO %%i

REM Paths to Dockerfiles
SET FRONTEND_PATH=.\client
SET BACKEND_PATH=.\time_manager
SET K8S_CONFIG_PATH=.\kubernetes_deployment.yaml

REM Display current directory and files
echo Current directory: %CD%
dir

REM Build Docker images
echo Building Vue.js image...
docker build -t vuejs-app:latest %FRONTEND_PATH%

echo Building Elixir image...
docker build -t elixir-app:latest %BACKEND_PATH%

REM Create a namespace
kubectl create namespace time-manager

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

REM Start Minikube tunnel
start /B minikube tunnel

echo Deployment complete!
pause
