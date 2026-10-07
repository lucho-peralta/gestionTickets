# Back-end — Gestión de Tickets

REST API del sistema de tickets, hecha con **Node.js + Express 5** y una base **SQLite** (`better-sqlite3`). Implementa los endpoints definidos en `documentacion/19_rest_api.md` y `documentacion/openapi/`.

Queda escuchando en `http://localhost:3000`.

## Requisitos

| Herramienta | Versión | Para qué |
|---|---|---|
| [Node.js](https://nodejs.org) | **22 o superior** | Correr el servidor (`better-sqlite3` v13 no funciona con versiones anteriores) |
| npm | la que viene con Node | Instalar las dependencias |
| [Hurl](https://hurl.dev) | opcional | Correr los tests de `hurl/` |

No hace falta instalar SQLite aparte: viene dentro de `better-sqlite3`. Tampoco hace falta Python ni compilador, porque el paquete ya trae los binarios para Windows y Linux.

## Windows

### 1. Instalar Node.js

Descargar el instalador **LTS** (22 o superior) de [nodejs.org](https://nodejs.org), o bien:

```powershell
winget install OpenJS.NodeJS.LTS
```

Cerrar y volver a abrir la terminal, y verificar:

```powershell
node -v
npm -v
```

### 2. Instalar dependencias

Desde la carpeta `backend/`:

```powershell
npm install --ignore-scripts
```

### 3. Levantar el servidor

```powershell
npm start
```

Tiene que aparecer `Servidor escuchando en http://localhost:3000`. Para apagarlo: `Ctrl + C`.

## Linux (Debian / Ubuntu)

### 1. Instalar Node.js 22

El `nodejs` que trae `apt` en Debian es más viejo que la versión 22, así que se instala desde NodeSource:

```bash
sudo apt update
sudo apt install -y curl ca-certificates
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt install -y nodejs
```

Verificar:

```bash
node -v   # tiene que mostrar v22.x o más
npm -v
```

Si antes estaba instalado el `nodejs` de Debian y `node -v` sigue mostrando una versión vieja, desinstalarlo con `sudo apt remove nodejs` y repetir los pasos.

### 2. Instalar dependencias

Desde la carpeta `backend/`:

```bash
npm install --ignore-scripts
```

### 3. Levantar el servidor

```bash
npm start
```

Tiene que aparecer `Servidor escuchando en http://localhost:3000`. Para apagarlo: `Ctrl + C`.

## Por qué `--ignore-scripts`

Con un `npm install` común, npm intenta **compilar** `better-sqlite3` con `node-gyp`, y eso falla si la máquina no tiene Python y un compilador de C++. No hace falta compilar: el paquete ya trae los binarios listos para Windows y Linux, así que `--ignore-scripts` evita ese paso.

## Base de datos

- El archivo es `data/tickets.db`.
- Si no existe, al arrancar el servidor se crea solo con el esquema de `sql/init.sql`, que ya trae los 3 agentes precargados.
- Para **empezar con la base limpia**, apagar el servidor, borrar `data/tickets.db` y volver a levantarlo.

## Puerto

Por defecto usa el `3000`. Para cambiarlo, crear un archivo `.env` en `backend/` con:

```
PORT=3001
```

Si se cambia el puerto, también hay que cambiarlo en `hurl/env.dev` para que los tests apunten al lugar correcto.

## Correr los tests de Hurl

Con el servidor levantado, en **otra terminal**, desde la carpeta `hurl/`:

```bash
hurl --jobs 1 --test --variables-file env.dev --glob "*.hurl"
```

Para correr uno solo, se pasa el nombre del archivo en lugar de `--glob`:

```bash
hurl --jobs 1 --test --variables-file env.dev 005_tickets_agente.hurl
```

Cómo instalar Hurl en Windows y en Linux está explicado en `hurl/README.md`.

## Estructura

```
backend/
├── data/tickets.db            Base SQLite (se crea sola)
├── sql/init.sql               Esquema + agentes precargados
└── src/
    ├── app.js                 Servidor Express y rutas
    ├── configuracion/db.js    Conexión a SQLite
    ├── utils/constantes.js    Categorías, estados y formato de DNI
    └── features/              Un archivo por endpoint
```

## Endpoints

| Método | Ruta | Archivo |
|---|---|---|
| `POST` | `/tickets` | `crearTicket.js` |
| `GET` | `/tickets/:id` | `obtenerTicket.js` |
| `PATCH` | `/tickets/:id/estado` | `actualizarEstado.js` |
| `GET` | `/clientes/:dni/tickets` | `ticketsCliente.js` |
| `GET` | `/agentes/:dni/tickets` | `ticketsAgente.js` |
| `GET` | `/reportes/frecuencia-categorias` | `frecuenciaCategorias.js` |
| `GET` | `/reportes/tiempo-promedio-resolucion` | `tiempoPromedioResolucion.js` |
| `GET` | `/reportes/top-categorias` | `topCategorias.js` |

## Problemas comunes

| Síntoma | Causa | Solución |
|---|---|---|
| `gyp ERR! find Python` al hacer `npm install` | npm intenta compilar `better-sqlite3` | Usar `npm install --ignore-scripts` |
| `Cannot find package 'dotenv'` (u otro paquete) | No se instalaron las dependencias | Correr `npm install --ignore-scripts` dentro de `backend/` |
| `EBADENGINE` o error al cargar `better-sqlite3` | Node.js es más viejo que la 22 | Actualizar Node (ver los pasos de instalación) |
| `EADDRINUSE: address already in use :::3000` | Ya hay otro servidor en ese puerto | Cerrar la otra terminal o cambiar `PORT` en `.env` |
