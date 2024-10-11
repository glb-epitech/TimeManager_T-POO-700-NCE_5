docker build -t ./client/vuejs-app:latest .
docker build -t ./time_manager/elixir-app:latest .

kubectl apply -f kubernetes-deployment.yaml
