#Instalar minikube
brew install minikube
#Instalar kubectl
brew install kubectl
#Obtener información de los contextos de kubernetes
kubectl config current-context
#Activar el contexto minikube
kubectl config use-context minikube
#Iniciar minikube
minikube start
#Explorar cluster
kubectl get nodes

#Activar addons de minikube para ingress con nginx
minikube addons enable ingress
#Crear ingress
kubectl apply -f ingress.yaml
#Instalar Helm
brew install helm
#Crear repositorio de Helm
helm create rehearsal
#Configurar chart, templates, values y environments
...
#Desplegar cambios
...
#Create namespace argocd
kubectl create namespace argocd
#Install argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#Exponer el servicio de argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443
#Obtener la contraseña
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
#Ingresar a la consola de ArgoCD
...
#Configurar aplicación de ArgoCD con el repositorio de Helm
...
#Configurar dominios en el archivo /etc/hosts
#Esto lo que hace es añadir una nueva entrada al archivo /etc/hosts para mapear los dominios frontend.local y api.local a la IP 127.0.0.1.
sudo nano /etc/hosts
127.0.0.1  frontend.local api.local
#Abrir tunnel para permitir el acceso al cluster desde el navegador
minikube tunnel
#Mostrar ip externa del ingress
kubectl get svc -n ingress-nginx
#Modificar el tipo de servicio del ingress-nginx-controller a LoadBalancer
kubectl patch svc ingress-nginx-controller -n ingress-nginx \
  -p '{"spec": {"type": "LoadBalancer"}}'
#Crear aplicación de argoCD
kubectl apply -f rehearsal-dev-application.yaml
#Crear nueva versión del frontend
...
#Desplegar cambios en el repositorio de Helm
...

