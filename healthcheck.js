// healthcheck.js - Con monitoreo y auto-diagnóstico
const http = require('http');
const fs = require('fs');
const { execSync } = require('child_process');

// Configuración
const PORT = process.env.N8N_PORT || 5678;
const HOST = 'localhost';
const CHECK_INTERVAL = 30000; // 30 segundos

// Función para verificar salud
function checkHealth() {
    return new Promise((resolve) => {
        const options = {
            hostname: HOST,
            port: PORT,
            path: '/healthz',
            method: 'GET',
            timeout: 5000
        };

        const req = http.request(options, (res) => {
            let data = '';
            res.on('data', (chunk) => data += chunk);
            res.on('end', () => {
                resolve({
                    healthy: res.statusCode === 200,
                    statusCode: res.statusCode,
                    data: data
                });
            });
        });

        req.on('error', (error) => {
            resolve({
                healthy: false,
                error: error.message
            });
        });

        req.on('timeout', () => {
            req.destroy();
            resolve({
                healthy: false,
                error: 'Timeout'
            });
        });

        req.end();
    });
}

// Función de auto-reparación básica
async function autoRepair() {
    console.log('Ejecutando auto-diagnóstico...');
    
    // Verificar si n8n está respondiendo
    const health = await checkHealth();
    
    if (!health.healthy) {
        console.log('Problema detectado:', health.error || health.statusCode);
        
        // Podrías agregar acciones de reparación aquí
        // Ej: Reiniciar servicio, limpiar cache, etc.
    } else {
        console.log('✅ Salud verificada correctamente');
    }
}

// Ejecutar chequeo inicial
console.log(`🚀 Healthcheck iniciado para n8n en ${HOST}:${PORT}`);
console.log(`⏱  Intervalo de chequeo: ${CHECK_INTERVAL/1000} segundos`);

// Chequear cada intervalo
setInterval(autoRepair, CHECK_INTERVAL);

// Chequeo inmediato
autoRepair();

// Mantener el proceso corriendo
process.stdin.resume();
