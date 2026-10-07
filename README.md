<h1 align="center">MongoDB 9.0 en Debian Trixie</h1>

<p align="center">
  <b>Instalación automatizada de MongoDB 9.0 Community Edition en Debian 13 (Trixie)</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/MongoDB-9.0-10aa50?style=for-the-badge&logo=mongodb&logoColor=white" alt="MongoDB 9.0" />
  <img src="https://img.shields.io/badge/Debian-13%20(Trixie)-a80030?style=for-the-badge&logo=debian&logoColor=white" alt="Debian 13" />
</p>

---

## Descripción

Script Bash para instalar **MongoDB 9.0 Community Edition** en **Debian 13 (Trixie)** mediante el **repositorio oficial de MongoDB**.

Comprueba el sistema, configura la clave GPG y el repositorio, instala el componente solicitado y, en el caso del servidor, configura `mongod` con `systemd`.

## Requisitos

- Debian 13 (Trixie)
- Arquitectura `amd64` (`x86_64`)
- Privilegios `sudo`
- Conexión a Internet

## Uso

Dar permisos de ejecución:

```bash
chmod +x install-mongodb.sh
```

### Instalar el servidor

```bash
./install-mongodb.sh --server
```
### Instalar MongoDB Shell

```bash
./install-mongodb.sh --client
```
### Sin parámetros

```bash
./install-mongodb.sh
```
### Ayuda

```bash
./install-mongodb.sh --help
```

## Comportamiento

El script comprueba automáticamente que el sistema sea Debian 13 `amd64`.

También detecta si el componente solicitado ya está instalado. En ese caso, muestra un mensaje indicando que ya está configurado y evita repetir la instalación.

## Comprobar MongoDB

Estado del servicio:

```bash
sudo systemctl status mongod
```

Comprobación rápida:

```bash
sudo systemctl is-active mongod
```

Versión del servidor:

```bash
mongod --version
```

Versión de `mongosh`:

```bash
mongosh --version
```

## Control del servicio

```bash
sudo systemctl start mongod
sudo systemctl stop mongod
sudo systemctl restart mongod
```

## Desinstalación

Para eliminar el servidor:

```bash
sudo apt remove mongodb-org-server
```

Para eliminar también los archivos de configuración:

```bash
sudo apt purge mongodb-org-server
```

Para eliminar MongoDB Shell:

```bash
sudo apt remove mongodb-mongosh
```

Los datos almacenados en `/var/lib/mongodb` pueden requerir eliminación manual.

## Estructura

```text
.
├── install-mongodb.sh
└── README.md
```

## Licencia

MIT

## Autor

**ElLucaMx**
