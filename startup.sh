#!/bin/bash
# startup.sh - Script principal con auto-reparación

echo "=== INICIANDO N8N CON AUTO-REPARACIÓN ==="
echo "Fecha: $(date)"

# 1. VERIFICAR E INSTALAR DEPENDENCIAS FALTANTES
echo "Verificando dependencias..."
for dep in tedious xml2js; do
    if ! npm list -g $dep > /dev/null 2>&1; then
        echo "Instalando $dep..."
        npm install -g $dep
    else
        echo "✅ $dep ya está instalado"
    fi
done

# 2. VERIFICAR VARIABLES DE ENTORNO CRÍTICAS
echo "Verificando variables de entorno..."
if [ -z "$N8N_DB_TYPE" ]; then
    echo "⚠️  ADVERTENCIA: N8N_DB_TYPE no está definida"
fi

if [ -z "$WEBHOOK_URL" ]; then
    echo "⚠️  ADVERTENCIA: WEBHOOK_URL no está definida"
fi

# 3. INICIAR HEALTHCHECK EN SEGUNDO PLANO
echo "Iniciando healthcheck..."
node /healthcheck.js &
HEALTHCHECK_PID=$!

# 4. INICIAR N8N
echo "Iniciando n8n..."
n8n start

# 5. SI N8N FALLA, MATAR HEALTHCHECK
kill $HEALTHCHECK_PID 2>/dev/null
echo "n8n se ha detenido"
