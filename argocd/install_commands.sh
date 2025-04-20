#!/bin/bash
#Create namespace argocd
kubectl create namespace argocd
#Install argocd 
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#Obtener pods de argocd
kubectl get pods -n argocd
#Exponer el servicio de argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443
#Obtener la contraseña
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

#Crear aplicaciones
kubectl apply -f rehearsal-dev-application.yaml

#Eliminar aplicaciones
kubectl delete -f rehearsal-dev-application.yaml