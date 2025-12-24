#!/usr/bin/env bash
#
# Descripción: Instalación de MongoDB 7.0 en Debian 13 (Trixie) usando el repositorio oficial (bookworm).
# Autor: ElLucaMx
# Versión del script: 1.0.0
# Fecha: 2025-12-24
# Licencia: MIT
#
# Notas:
# - MongoDB todavía no publica repositorio específico para Debian Trixie.
#   Se utiliza el repositorio de bookworm por compatibilidad oficial.
#
# Requisitos:
# - Usuario con privilegios sudo
# - Conexión a Internet
#

set -euo pipefail

# 1. Actualizar apt y preparar dependencias
echo "Actualizando lista de paquetes..."
sudo apt update

echo "Instalando dependencias necesarias (curl, gnupg)..."
sudo apt install -y curl gnupg

# 2. Importar clave GPG de MongoDB 7.0
echo "Importando clave GPG de MongoDB 7.0..."
curl -fsSL https://pgp.mongodb.com/server-7.0.asc \
  | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg

# 3. Añadir repositorio oficial de MongoDB 7.0 (bookworm, compatible con trixie)
echo "Configurando repositorio MongoDB 7.0 para Debian Trixie (usando bookworm)..."
echo "deb [signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" \
  | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list > /dev/null

# 4. Actualizar e instalar MongoDB
echo "Actualizando lista de paquetes con el nuevo repositorio..."
sudo apt update

echo "Instalando mongodb-org (versión 7.0)..."
sudo apt install -y mongodb-org

# 5. Iniciar y habilitar el servicio mongod
echo "Iniciando y habilitando mongod como servicio systemd..."
sudo systemctl start mongod
sudo systemctl enable mongod

# 6. Mostrar estado del servicio
echo "Estado de mongod:"
sudo systemctl status mongod --no-pager

echo "MongoDB 7.0 se ha instalado correctamente en Debian 13 (Trixie)."
