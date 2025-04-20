#Crear ambiente de Python para el backend
python3 -m venv env
source env/bin/activate
#Instalar dependencias
pip install -r requirements.txt
#Crear carpeta de la aplicación
mkdir app
cd app
touch main.py

#Crear imagen de Docker para el backend
docker build -t backend-python .
#Etiquetar la imagen
docker tag backend-python:latest con3rasjf/backend-python:v1
#Iniciar sesión en Docker Hub
docker login
#Subir la imagen
docker push con3rasjf/backend-python:v1

#correr contenedor en local
docker run -p 8000:8000 backend-python uvicorn main:app --host 0.0.0.0 --port 8000

#Validar que el puerto de la BD este libre
lsof -i :27017

#Crear deployment y servicio
kubectl apply -f deployment.yaml

#Reiniciar el deployment
kubectl rollout restart deployment dpl-backend-python

#Buscar pods asociados al deployment
kubectl get pods -l app=backend-python

#Enviar peticiones al servicio de backend
#Obtener ip de minikube
minikube ip

curl -X GET "http://$(minikube ip):8000/reservas/"

curl -X GET "http://192.168.49.2:32761/reservas/"

#Enviar peticiones al servicio de backend dentro del cluster
#Crear un pod temporal para conectarse al backend
kubectl run curl --rm -it --image=busybox --command -- sh

#Enviar peticiones al servicio de backend dentro del cluster
curl -X GET "http://svc-frontend:3000
