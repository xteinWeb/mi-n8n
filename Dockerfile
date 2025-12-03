FROM n8nio/n8n:latest

# Crear usuario node si no existe
USER root

# Instalar Node.js para el healthcheck (si no está)
RUN which node || (apt-get update && apt-get install -y nodejs)

# Copiar healthcheck
COPY healthcheck.js /healthcheck.js

# Exponer puertos
EXPOSE 5678 8080

# Comando para iniciar n8n Y healthcheck
CMD sh -c 'node /healthcheck.js & n8n start'
