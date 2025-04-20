#Start project
npx create-react-app frontend-reservaciones
cd frontend-reservaciones
#Install dependencies
npm install react-big-calendar axios moment

#Build image
docker build -t frontend .
#Tag image
docker tag frontend:latest con3rasjf/frontend:v3
#Push image to Docker Hub
docker push con3rasjf/frontend:v3

#Create deployment and service
kubectl apply -f deployment.yaml

#Reiniciar el deployment
kubectl rollout restart deployment dpl-frontend

#Obtener pods del deployment
kubectl get pods -l app=frontend

#Conectar al pod a traves del servicio
minikube service svc-frontend


##############
#Ejecutar frontend en local
docker run -p 3000:3000 frontend