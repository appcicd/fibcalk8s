docker build -t appcicd/fibcal-client:latest -t appcicd/fibcal-client:$SHA -f ./client/Dockerfile ./client
docker build -t appcicd/fibcal-server:latest -t appcicd/fibcal-server:$SHA -f ./server/Dockerfile ./server
docker build -t appcicd/fibcal-worker:latest -t appcicd/fibcal-worker:$SHA -f ./worker/Dockerfile ./worker

docker push appcicd/fibcal-client:latest
docker push appcicd/fibcal-server:latest
docker push appcicd/fibcal-worker:latest

docker push appcicd/fibcal-client:$SHA
docker push appcicd/fibcal-server:$SHA
docker push appcicd/fibcal-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=appcicd/fibcal-server:$SHA
kubectl set image deployments/client-deployment client=appcicd/fibcal-client:$SHA
kubectl set image deployments/worker-deployment worker=appcicd/fibcal-worker:$SHA