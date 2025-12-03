FROM n8nio/n8n:latest

USER root

# Instalar Node.js para el healthcheck
RUN which node || (apt-get update && apt-get install -y nodejs)

# VARIABLES DE ENTORNO - WEBHOOK_URL IMPORTANTE
ENV N8N_HOST=0.0.0.0
ENV N8N_PROTOCOL=https
ENV N8N_PORT=5678
# ENV WEBHOOK_URL=https://mi-n8n-production-c228.up.railway.app
# NOTA: WEBHOOK_URL mejor en Railway Variables, no aquí

COPY healthcheck.js /healthcheck.js

EXPOSE 5678 8080

CMD sh -c 'node /healthcheck.js & n8n start'
