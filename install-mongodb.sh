#!/usr/bin/env bash
#
# Descripción: Instalación y configuración de MongoDB 9.0 Community Edition
#              en Debian 13 (Trixie) usando el repositorio oficial de MongoDB.
#
# Modos de ejecución:
#   --server  Configura el repositorio e instala el servidor MongoDB.
#   --client  Configura el repositorio e instala MongoDB Shell (mongosh).
#   Sin parámetros: Equivale a --server.
#
# Autor: ElLucaMx
# Versión: 4.1.0
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

# Colores
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Funciones de salida
info() {
    echo -e "${BLUE}$1${NC}"
}

success() {
    echo -e "${GREEN}$1${NC}"
}

error() {
    echo -e "${RED}$1${NC}"
}

# Variables
MONGODB_VERSION="9.0"
MONGODB_KEY_VERSION="9"

MONGODB_KEYRING="/usr/share/keyrings/mongodb-server-${MONGODB_KEY_VERSION}.gpg"
MONGODB_LIST="/etc/apt/sources.list.d/mongodb-org-${MONGODB_VERSION}.list"

MONGODB_REPOSITORY="https://repo.mongodb.org/apt/debian"
MONGODB_DISTRIBUTION="trixie"

MONGODB_KEY_URL="https://pgp.mongodb.com/server-${MONGODB_KEY_VERSION}.asc"

MONGODB_SERVER_PACKAGE="mongodb-org-server"
MONGODB_SHELL_PACKAGE="mongodb-mongosh"

# Comprobar si un paquete ya está instalado
is_package_installed() {
    local package="$1"

    dpkg-query -W -f='${Status}' "${package}" 2>/dev/null \
        | grep -q "install ok installed"
}

check_system() {
    info "Comprobando el sistema operativo..."

    if [[ ! -f /etc/os-release ]]; then
        error "ERROR: No se ha podido determinar el sistema operativo."
        exit 1
    fi

    source /etc/os-release

    if [[ "${ID}" != "debian" ]]; then
        error "ERROR: Este script está diseñado para Debian."
        error "Sistema detectado: ${ID}"
        exit 1
    fi

    if [[ "${VERSION_ID}" != "13" ]]; then
        error "ERROR: Este script requiere Debian 13 (Trixie)."
        error "Versión detectada: Debian ${VERSION_ID}"
        exit 1
    fi

    ARCHITECTURE="$(dpkg --print-architecture)"

    if [[ "${ARCHITECTURE}" != "amd64" ]]; then
        error "ERROR: MongoDB ${MONGODB_VERSION} requiere arquitectura x86_64."
        error "Arquitectura detectada: ${ARCHITECTURE}"
        exit 1
    fi

    success "Sistema operativo: Debian ${VERSION_ID} (${VERSION_CODENAME})"
    success "Arquitectura: ${ARCHITECTURE}"

    echo
}

check_server_installed() {
    if is_package_installed "${MONGODB_SERVER_PACKAGE}"; then
        success "MongoDB Server ya está instalado."
        success "No es necesario realizar ninguna acción."

        echo

        info "Paquete: ${MONGODB_SERVER_PACKAGE}"
        info "Servicio: mongod"

        if sudo systemctl is-active --quiet mongod; then
            success "Estado: active"
        else
            info "Estado: inactive"
        fi

        echo

        return 0
    fi

    return 1
}

check_client_installed() {
    if is_package_installed "${MONGODB_SHELL_PACKAGE}"; then
        success "MongoDB Shell (mongosh) ya está instalado."
        success "No es necesario realizar ninguna acción."

        echo

        info "Paquete: ${MONGODB_SHELL_PACKAGE}"
        info "Comando: mongosh"

        echo

        return 0
    fi

    return 1
}

install_dependencies() {
    info "Instalando dependencias necesarias..."

    sudo apt-get install -y curl gnupg

    success "Dependencias instaladas correctamente."

    echo
}

configure_repository() {
    info "Configurando la clave GPG de MongoDB..."

    if [[ ! -f "${MONGODB_KEYRING}" ]]; then
        curl -fsSL "${MONGODB_KEY_URL}" \
            | sudo gpg --dearmor -o "${MONGODB_KEYRING}"

        success "Clave GPG instalada correctamente."
    else
        info "La clave GPG ya existe."
        info "No es necesario volver a importarla."
    fi

    sudo chmod 644 "${MONGODB_KEYRING}"

    echo

    info "Configurando el repositorio oficial de MongoDB..."

    echo "deb [ signed-by=${MONGODB_KEYRING} ] ${MONGODB_REPOSITORY} ${MONGODB_DISTRIBUTION}/mongodb-org/${MONGODB_VERSION} main" \
        | sudo tee "${MONGODB_LIST}" > /dev/null

    success "Repositorio configurado correctamente."

    echo

    info "Actualizando la lista de paquetes..."

    sudo apt-get update

    success "Lista de paquetes actualizada correctamente."

    echo
}

install_server() {
    info "Instalando el servidor MongoDB..."

    sudo apt-get install -y "${MONGODB_SERVER_PACKAGE}"

    success "Servidor MongoDB instalado correctamente."

    echo
}

start_server() {
    info "Iniciando el servicio mongod..."

    sudo systemctl start mongod

    success "Servicio mongod iniciado correctamente."

    echo
}

enable_server() {
    info "Habilitando MongoDB al arrancar..."

    sudo systemctl enable mongod

    success "MongoDB se iniciará automáticamente con el sistema."

    echo
}

check_server() {
    echo

    info "=============================================="
    info " Estado del servicio MongoDB"
    info "=============================================="

    echo

    if sudo systemctl is-active --quiet mongod; then
        success "MongoDB está funcionando correctamente."
    else
        error "ERROR: MongoDB no está funcionando."

        echo

        sudo systemctl status mongod --no-pager

        exit 1
    fi

    echo
}

show_server_version() {
    info "=============================================="
    info " Versión instalada"
    info "=============================================="

    echo

    mongod --version

    echo
}

install_client() {
    info "Instalando MongoDB Shell (mongosh)..."

    sudo apt-get install -y "${MONGODB_SHELL_PACKAGE}"

    success "MongoDB Shell (mongosh) instalado correctamente."

    echo
}

show_client_version() {
    info "=============================================="
    info " Versión de MongoDB Shell"
    info "=============================================="

    echo

    mongosh --version

    echo
}

server_installation() {
    info "=============================================="
    info " Instalación de MongoDB Server ${MONGODB_VERSION}"
    info "=============================================="

    echo

    # Si ya está instalado, no hacemos nada más
    if check_server_installed; then
        return 0
    fi

    install_dependencies
    configure_repository
    install_server
    start_server
    enable_server
    check_server
    show_server_version

    echo

    success "=============================================="
    success " Instalación del servidor completada"
    success "=============================================="

    echo

    success "MongoDB Server ${MONGODB_VERSION} ha sido instalado"
    success "en Debian 13 (Trixie)."

    echo

    info "Paquete: ${MONGODB_SERVER_PACKAGE}"
    info "Servicio: mongod"
    success "Estado: $(sudo systemctl is-active mongod)"

    echo
}

client_installation() {
    info "=============================================="
    info " Instalación de MongoDB Shell"
    info "=============================================="

    echo

    # Si ya está instalado, no hacemos nada más
    if check_client_installed; then
        return 0
    fi

    install_dependencies
    configure_repository
    install_client
    show_client_version

    echo

    success "=============================================="
    success " Instalación del cliente completada"
    success "=============================================="

    echo

    success "MongoDB Shell (mongosh) ha sido instalado"
    success "en Debian 13 (Trixie)."

    echo

    info "Paquete: ${MONGODB_SHELL_PACKAGE}"
    info "Comando: mongosh"

    echo
}

show_help() {
    info "Uso: $0 [OPCIÓN]"

    echo

    info "Opciones:"
    echo

    info "  --server"
    info "      Configura el repositorio e instala MongoDB Server."

    echo

    info "  --client"
    info "      Configura el repositorio e instala MongoDB Shell (mongosh)."

    echo

    info "  --help"
    info "      Muestra esta ayuda."

    echo

    info "Sin parámetros:"
    info "      Equivale a --server."

    echo
}

MODE="server"

case "${1:-}" in
    --server)
        MODE="server"
        ;;

    --client)
        MODE="client"
        ;;

    --help|-h)
        show_help
        exit 0
        ;;

    "")
        MODE="server"
        ;;

    *)
        error "ERROR: Parámetro no reconocido: $1"

        echo

        show_help

        exit 1
        ;;
esac

echo

info "=============================================="
info " MongoDB ${MONGODB_VERSION}"
info " Debian 13 (Trixie)"
info "=============================================="

echo

check_system

case "${MODE}" in
    server)
        server_installation
        ;;

    client)
        client_installation
        ;;
esac
