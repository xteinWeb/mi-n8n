FROM n8nio/n8n:latest

# Solo copiar scripts, NO instalar dependencias aquí
COPY healthcheck.js /healthcheck.js
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

EXPOSE 5678

# Usar script de inicio que maneja auto-reparación
CMD ["/startup.sh"]
