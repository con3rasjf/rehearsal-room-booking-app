

#Instalar mongo shell
brew install mongosh

#Crear statefulset y servicio para la base de datos
kubectl apply -f mongodb-stateful.yaml 
kubectl apply -f mongodb-service.yaml

#Nombre del host para la conexión a la base de datos
mongodb-0.mongodb.default.svc.cluster.local

#Crear un pod temporal para conectarse a la base de datos
kubectl run -it mongo-shell --image=mongo:4.0.17 --rm -- /bin/bash

#Conectar a la base de datos
mongo --host mongodb-0.mongodb:27017

#Crear un port-forward para acceder a la base de datos desde la terminal
kubectl port-forward svc/mongodb 27017

#Conectar a la base de datos desde la terminal
mongosh --host localhost --port 27017

#Crear base de datos
use reservas_ensayos
#Mostrar bases de datos
show dbs
#Eliminar base de datos reservas_ensayos
db.dropDatabase()

#Mostrar colecciones
show collections
#Crear coleccion
db.createCollection("reservas")
#Insertar datos
db.reservas.insertOne({ sala: "1", fecha: "2025-01-28", duracion: 2, usuario: "jcont15" })
#Mostrar documentos en una colección:
db.reservas.find()
#Buscar documentos que coincidan con un criterio:
db.reservas.find({ nombre: "Juan Pérez" })
#Buscar un único documento:
db.reservas.findOne({ horario: "10:00 AM" })
#mayor que
db.reservas.find({ duracion_horas: { $gt: 2 } })
#menor que
db.reservas.find({ duracion_horas: { $lt: 2 } })
#or
db.reservas.find({ $or: [{ nombre: "Juan Pérez" }, { duracion_horas: 2 }] })
#Eliminar un documento
db.reservas.deleteOne({"usuario":"jcont15"})