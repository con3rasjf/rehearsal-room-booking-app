#Install helm
brew install helm
#Initialize helm
helm create rehearsal
#Install chart
helm install rehearsal ./rehearsal
#Connect to minikube
minikube tunnel
#Upgrade chart
helm upgrade rehearsal ./rehearsal
#Delete chart
helm delete rehearsal
