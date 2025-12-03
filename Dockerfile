FROM n8nio/n8n:latest

# Exponer el puerto de n8n
EXPOSE 5678

# Comando para iniciar n8n
CMD ["n8n", "start"]
