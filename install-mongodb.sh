```bash
#!/usr/bin/env bash
#
# Descripción: Instalación de MongoDB 9.0 Community Edition en Debian 13 (Trixie)
#              usando el repositorio oficial de MongoDB.
# Autor: ElLucaMx
# Versión del script: 2.0.0
# Fecha: 2026-10-07
# Licencia: MIT
#
# Requisitos:
# - Debian 13 (Trixie) de 64 bits
# - Arquitectura x86_64
# - Usuario con privilegios sudo
# - Conexión a Internet
#

set -euo pipefail

# ============================================================
# Variables
# ============================================================

MONGODB_MAJOR_VERSION="9.0"
MONGODB_KEYRING="/usr/share/keyrings/mongodb-server-${MONGODB_MAJOR_VERSION}.gpg"
MONGODB_LIST="/etc/apt/sources.list.d/mongodb-org-${MONGODB_MAJOR_VERSION}.list"
MONGODB_REPOSITORY="https://repo.mongodb.org/apt/debian"
MONGODB_DISTRIBUTION="trixie"

# ============================================================
# Comprobaciones iniciales
# ============================================================

echo "=============================================="
echo " Instalación de MongoDB ${MONGODB_MAJOR_VERSION}"
echo " Debian 13 (Trixie)"
echo "=============================================="
echo

echo "Comprobando el sistema operativo..."

if [[ ! -f /etc/os-release ]]; then
    echo "ERROR: No se ha podido determinar el sistema operativo."
    exit 1
fi

source /etc/os-release

if [[ "${ID}" != "debian" ]]; then
    echo "ERROR: Este script está diseñado para Debian."
    echo "Sistema detectado: ${ID}"
    exit 1
fi

if [[ "${VERSION_ID}" != "13" ]]; then
    echo "ERROR: Este script requiere Debian 13 (Trixie)."
    echo "Versión detectada: Debian ${VERSION_ID}"
    exit 1
fi

ARCHITECTURE="$(dpkg --print-architecture)"

if [[ "${ARCHITECTURE}" != "amd64" ]]; then
    echo "ERROR: MongoDB 9.0 para Debian 13 requiere arquitectura x86_64."
    echo "Arquitectura detectada: ${ARCHITECTURE}"
    exit 1
fi

echo "Sistema operativo: Debian ${VERSION_ID} (${VERSION_CODENAME})"
echo "Arquitectura: ${ARCHITECTURE}"
echo

# ============================================================
# 1. Actualizar repositorios
# ============================================================

echo "Actualizando la lista de paquetes..."
sudo apt-get update

# ============================================================
# 2. Instalar dependencias
# ============================================================

echo "Instalando dependencias necesarias..."
sudo apt-get install -y curl gnupg

# ============================================================
# 3. Importar clave GPG de MongoDB
# ============================================================

echo "Configurando la clave GPG de MongoDB..."

if [[ ! -f "${MONGODB_KEYRING}" ]]; then
    curl -fsSL "https://pgp.mongodb.com/server-${MONGODB_MAJOR_VERSION}.asc" \
        | sudo gpg --dearmor -o "${MONGODB_KEYRING}"
else
    echo "La clave GPG ya existe. No es necesario volver a importarla."
fi

sudo chmod 644 "${MONGODB_KEYRING}"

# ============================================================
# 4. Configurar repositorio oficial
# ============================================================

echo "Configurando el repositorio oficial de MongoDB..."

echo "deb [ signed-by=${MONGODB_KEYRING} ] ${MONGODB_REPOSITORY} ${MONGODB_DISTRIBUTION}/mongodb-org/${MONGODB_MAJOR_VERSION} main" \
    | sudo tee "${MONGODB_LIST}" > /dev/null

# ============================================================
# 5. Actualizar repositorios
# ============================================================

echo "Actualizando la lista de paquetes con el repositorio de MongoDB..."
sudo apt-get update

# ============================================================
# 6. Instalar MongoDB
# ============================================================

echo "Instalando MongoDB ${MONGODB_MAJOR_VERSION}..."
sudo apt-get install -y mongodb-org

# ============================================================
# 7. Iniciar MongoDB
# ============================================================

echo "Iniciando el servicio mongod..."

sudo systemctl start mongod

# ============================================================
# 8. Habilitar MongoDB al arrancar
# ============================================================

echo "Habilitando mongod para que se inicie automáticamente..."

sudo systemctl enable mongod

# ============================================================
# 9. Comprobar estado
# ============================================================

echo
echo "=============================================="
echo " Estado del servicio MongoDB"
echo "=============================================="

if sudo systemctl is-active --quiet mongod; then
    echo "MongoDB está funcionando correctamente."
else
    echo "ERROR: MongoDB no está funcionando."
    sudo systemctl status mongod --no-pager
    exit 1
fi

# ============================================================
# 10. Mostrar versión instalada
# ============================================================

echo
echo "=============================================="
echo " Versión instalada"
echo "=============================================="

mongod --version

echo
echo "=============================================="
echo " Instalación completada correctamente"
echo "=============================================="
echo
echo "MongoDB ${MONGODB_MAJOR_VERSION} ha sido instalado"
echo "en Debian 13 (Trixie)."
echo
echo "Servicio: mongod"
echo "Estado: $(sudo systemctl is-active mongod)"
echo
```
