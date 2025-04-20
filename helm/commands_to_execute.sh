#Obtener información de los contextos de kubernetes
kubectl config get-contexts
#Iniciar cluster de minikube
minikube start --driver=docker

#Activar addons de minikube para ingress con nginx
minikube addons enable ingress

#Obtener información del ingress
kubectl get svc -n ingress-nginx

#Configurar dominios en el archivo /etc/hosts
sudo nano /etc/hosts
127.0.0.1  frontend.local api.local

#Abrir tunnel
minikube tunnel

#Instalar argoCD
#Ir a la carpeta de argoCD

