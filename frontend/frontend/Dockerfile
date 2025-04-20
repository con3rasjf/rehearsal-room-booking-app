# Etapa de construcción
FROM node:18-alpine AS builder

WORKDIR /app

# Instalar dependencias
COPY package.json package-lock.json ./
RUN npm install

# Copiar el resto del código y construir
COPY . .
RUN npm run build

# Etapa final para servir el contenido
FROM node:18-alpine

WORKDIR /app

# Instalar 'serve' para servir el contenido estático
RUN npm install -g serve

# Copiar los archivos construidos desde el contenedor anterior
COPY --from=builder /app/dist ./dist

# Exponer el puerto donde se servirá la aplicación
EXPOSE 3000

# Comando para servir
CMD ["serve", "-s", "dist", "-l", "3000"]
