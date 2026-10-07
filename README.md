<h1 align="center">MongoDB 9.0 en Debian Trixie</h1>

<p align="center">
  <b>Instalación automatizada y limpia de MongoDB 9.0 en Debian 13 (Trixie)</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/MongoDB-9.0-10aa50?style=for-the-badge&logo=mongodb&logoColor=white" alt="MongoDB 9.0" />
  <img src="https://img.shields.io/badge/Debian-13%20(Trixie)-a80030?style=for-the-badge&logo=debian&logoColor=white" alt="Debian 13 (Trixie)" />
  <img src="https://img.shields.io/badge/Systemd-enabled-444?style=for-the-badge" alt="systemd enabled" />
</p>

---

## Qué es esto

Este repositorio contiene un **script Bash** para instalar **MongoDB 9.0 Community Edition** en **Debian 13 (Trixie)** utilizando el **repositorio oficial de MongoDB**.

El script automatiza la configuración del repositorio, la importación de la clave GPG, la instalación de MongoDB y la configuración del servicio `mongod` mediante `systemd`.

---

## Características

- Instalación de **MongoDB 9.0 Community Edition**
- Uso del **repositorio oficial de MongoDB**
- Repositorio específico para **Debian 13 (Trixie)**
- Importación segura de la **clave GPG**
- Configuración automática del servicio `mongod`
- Inicio automático de MongoDB mediante **systemd**
- Comprobación de que el servicio está funcionando correctamente
- Comprobación de que el sistema es **Debian 13 (Trixie)**
- Comprobación de la arquitectura **amd64**
- Script robusto mediante `set -euo pipefail`
- Diseño **idempotente**, permitiendo volver a ejecutarlo sin recrear innecesariamente la clave GPG
- Pensado para instalaciones limpias de Debian

---

## Requisitos

- **Debian 13 (Trixie)**
- Arquitectura **amd64 (x86_64)**
- Usuario con privilegios `sudo`
- Conexión a Internet

---

## Instalación

Clona el repositorio o copia el script `install-mongodb.sh` en tu sistema.

Dale permisos de ejecución:

```bash
chmod +x install-mongodb.sh
```

Ejecuta el script:

```bash
./install-mongodb.sh
```

El script solicitará privilegios `sudo` cuando sean necesarios.

---

## Qué hace el script

El proceso de instalación se realiza en los siguientes pasos:

1. Comprueba que el sistema operativo sea **Debian 13 (Trixie)**.
2. Comprueba que la arquitectura sea **amd64**.
3. Actualiza los repositorios de APT.
4. Instala las dependencias necesarias (`curl` y `gnupg`).
5. Importa la clave GPG oficial de MongoDB.
6. Configura el repositorio oficial de MongoDB 9.0 para Debian Trixie.
7. Actualiza nuevamente los repositorios.
8. Instala el paquete `mongodb-org`.
9. Inicia el servicio `mongod`.
10. Habilita `mongod` para que se inicie automáticamente con el sistema.
11. Comprueba que el servicio esté activo.
12. Muestra la versión de MongoDB instalada.

---

## Comprobar el servicio

Después de la instalación puedes comprobar el estado de MongoDB con:

```bash
sudo systemctl status mongod
```

También puedes comprobar rápidamente si el servicio está activo:

```bash
sudo systemctl is-active mongod
```

Si todo funciona correctamente, debería devolver:

```text
active
```

---

## Comprobar la versión

Para comprobar la versión instalada:

```bash
mongod --version
```

Debería aparecer MongoDB 9.0.x.

---

## Detener, iniciar o reiniciar MongoDB

Detener el servicio:

```bash
sudo systemctl stop mongod
```

Iniciar el servicio:

```bash
sudo systemctl start mongod
```

Reiniciar el servicio:

```bash
sudo systemctl restart mongod
```

---

## Desinstalación

Para eliminar MongoDB instalado mediante `mongodb-org`:

```bash
sudo apt remove mongodb-org
```

Para eliminar también los archivos de configuración:

```bash
sudo apt purge mongodb-org
```

> **Nota:** desinstalar los paquetes de MongoDB no implica necesariamente que se eliminen automáticamente todos los datos almacenados en `/var/lib/mongodb`. Antes de borrar manualmente los datos, asegúrate de tener una copia de seguridad si son importantes.

---

## Estructura

```text
.
├── install-mongodb.sh
└── README.md
```

---

## Licencia

Este proyecto se distribuye bajo la licencia **MIT**.

---

## Autor

**ElLucaMx**
