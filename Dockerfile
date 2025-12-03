FROM n8nio/n8n:latest

# Crear usuario node si no existe
USER root

# Instalar Node.js para el healthcheck (si no está)
RUN which node || (apt-get update && apt-get install -y nodejs)

# VARIABLES DE ENTORNO OBLIGATORIAS - FORZAR CONFIGURACIÓN
ENV N8N_HOST=0.0.0.0
ENV N8N_PROTOCOL=https
ENV N8N_PORT=5678
# WEBHOOK_URL se configura en Railway Variables (más flexible)

# Copiar healthcheck
COPY healthcheck.js /healthcheck.js

# Exponer puertos
EXPOSE 5678 8080

# Comando para iniciar n8n Y healthcheck
CMD sh -c 'node /healthcheck.js & n8n start'
