
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pymongo import MongoClient
from pydantic import BaseModel
from bson.objectid import ObjectId
from datetime import datetime
from typing import List

# Configuración de la base de datos
client = MongoClient("mongodb-0.mongodb") # Cambia esto por la URL de tu base de datos MongoDB
db = client["reservas_ensayos"]
coleccion_reservas = db["reservas"]

# Inicialización de FastAPI
app = FastAPI()

#CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://frontend.local"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Modelos de datos
class Reserva(BaseModel):
    sala: str
    fecha: str
    duracion: int
    usuario: str

class ReservaResponse(BaseModel):
    id: str
    sala: str
    fecha: datetime
    duracion: int
    usuario: str

@app.post("/reservas/", response_model=ReservaResponse)
def reservar_ensayo(reserva: Reserva):
    # Verificar si la sala ya está reservada para la fecha y hora especificada
    conflicto = coleccion_reservas.find_one({
        "sala": reserva.sala,
        "fecha": reserva.fecha
    })
    if conflicto:
        raise HTTPException(status_code=400, detail="La sala ya está reservada para la fecha y hora seleccionada.")

    # Insertar la reserva en la base de datos
    nueva_reserva = {
        "sala": reserva.sala,
        "fecha": datetime.fromisoformat(reserva.fecha),
        "duracion": reserva.duracion,
        "usuario": reserva.usuario
    }
    resultado = coleccion_reservas.insert_one(nueva_reserva)
    return ReservaResponse(id=str(resultado.inserted_id), **nueva_reserva)

@app.get("/reservas/", response_model=List[ReservaResponse])
def obtener_reservas():
    reservas = coleccion_reservas.find()
    print(reservas)
    return [
        ReservaResponse(
            id=str(reserva["_id"]),
            sala=reserva["sala"],
            fecha=datetime.fromisoformat(str(reserva["fecha"])),
            duracion=reserva["duracion"],
            usuario=reserva["usuario"]
        ) for reserva in reservas
    ]

# @app.delete("/reservas/{reserva_id}")
# def cancelar_reserva(reserva_id: str):
#     resultado = coleccion_reservas.delete_one({"_id": ObjectId(reserva_id)})
#     if resultado.deleted_count == 0:
#         raise HTTPException(status_code=404, detail="Reserva no encontrada.")
#     return {"mensaje": "Reserva cancelada exitosamente."}

# @app.put("/reservas/{reserva_id}", response_model=ReservaResponse)
# def reprogramar_reserva(reserva_id: str, nueva_reserva: Reserva):
#     # Verificar si la nueva fecha ya está reservada
#     conflicto = coleccion_reservas.find_one({
#         "sala": nueva_reserva.sala,
#         "fecha": nueva_reserva.fecha.isoformat()
#     })
#     if conflicto:
#         raise HTTPException(status_code=400, detail="La sala ya está reservada para la nueva fecha y hora.")

#     # Actualizar la reserva en la base de datos
#     resultado = coleccion_reservas.find_one_and_update(
#         {"_id": ObjectId(reserva_id)},
#         {"$set": {
#             "sala": nueva_reserva.sala,
#             "fecha": nueva_reserva.fecha.isoformat(),
#             "duracion": nueva_reserva.duracion,
#             "usuario": nueva_reserva.usuario
#         }},
#         return_document=True
#     )
#     if not resultado:
#         raise HTTPException(status_code=404, detail="Reserva no encontrada.")

#     return ReservaResponse(
#         id=str(resultado["_id"]),
#         sala=resultado["sala"],
#         fecha=datetime.fromisoformat(resultado["fecha"]),
#         duracion=resultado["duracion"],
#         usuario=resultado["usuario"]
#     )