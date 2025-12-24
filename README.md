<h1 align="center">MongoDB 7.0 en Debian Trixie</h1>

<p align="center">
  <b>Instalación automatizada y limpia de MongoDB 7.0 en Debian 13 (Trixie)</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/MongoDB-7.0-10aa50?style=for-the-badge&logo=mongodb&logoColor=white" alt="MongoDB 7.0" />
  <img src="https://img.shields.io/badge/Debian-13%20(Trixie)-a80030?style=for-the-badge&logo=debian&logoColor=white" alt="Debian 13 (Trixie)" />
  <img src="https://img.shields.io/badge/Systemd-enabled-444?style=for-the-badge" alt="systemd enabled" />
</p>

---

## Qué es esto

Este repositorio contiene un **script Bash** para instalar **MongoDB 7.0** en **Debian 13 (Trixie)** usando el **repositorio oficial de MongoDB**.

> MongoDB aún no publica repositorios específicos para Trixie. Se utiliza el repo de **Bookworm**, que es oficialmente compatible.

---

## Características

- Instalación desde **repositorio oficial**  
- Importación segura de **clave GPG**  
- Servicio `mongod` habilitado en **systemd**  
- Script robusto (`set -euo pipefail`)  
- Pensado para **servidores limpios y producción**

---

## Requisitos

- Debian 13 (Trixie)  
- Acceso `sudo`  
- Conexión a Internet

---

## Instalación

```bash
chmod +x install-mongodb.sh
./install-mongodb.sh
