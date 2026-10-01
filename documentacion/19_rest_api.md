# Diseño de la REST API

Responsable: Juan

Este documento define los endpoints de la API: qué rutas existen, qué recibe y qué devuelve cada una, y qué errores puede dar. Funciona como **contrato** entre el back-end y el front-end. La versión formal es la especificación OpenAPI de `tickets-openapi/openapi/main.yaml`; si hay diferencias, se corrigen ambos.

## 1. Objetivo

La API permite:

- Que el **cliente** registre un ticket, consulte sus tickets por DNI y confirme cuando su problema fue resuelto.
- Que el **sistema** asigne automáticamente un agente a cada ticket nuevo.
- Que el **agente** consulte los tickets que tiene asignados y actualice su estado.
- Obtener **reportes**: frecuencia por categoría, tiempo promedio de resolución y top de categorías.

## 2. Supuestos

| Supuesto | Detalle |
|---|---|
| Sin autenticación | No hay login ni tokens. La identificación es por DNI. |
| Clientes | No se registran: su DNI viaja dentro del ticket. |
| Agentes | Están precargados. La API no los crea, modifica ni elimina. |
| Asignación | Automática y al azar al crear el ticket. Cada ticket tiene exactamente un agente; no hay reasignación. |
| Tickets | No se eliminan. |
| Validaciones | Mínimas: campos obligatorios y valores de las listas fijas. No se validan transiciones de estado. |

## 3. Convenciones

| Tema | Definición |
|---|---|
| URL base | `http://localhost:3000` (desarrollo) |
| Formato | JSON (`application/json`) en peticiones y respuestas |
| DNI | Texto de 7 u 8 dígitos (ej.: `"30123456"`) |
| Fechas | ISO 8601 (ej.: `"2026-09-20T10:15:00Z"`). Las pone el servidor. |
| Categorías | `conexion`, `facturacion`, `consulta_general`, `otro` |
| Estados | `asignado`, `en_proceso`, `en_revision`, `cerrado` |
| Errores | `{ "message": "texto del error" }` |

### Códigos de respuesta

| Código | Significado | Cuándo se usa |
|---|---|---|
| 200 | OK | Consulta o actualización correcta |
| 201 | Creado | Se creó un ticket |
| 400 | Datos inválidos | Falta un campo, DNI mal formado, categoría o estado fuera de la lista |
| 404 | No encontrado | El ticket o el agente no existen |
| 409 | Conflicto | No hay agentes cargados para asignar |

## 4. Resumen de endpoints

| # | Verbo | Ruta | Quién | Qué hace |
|---|---|---|---|---|
| 1 | `POST` | `/tickets` | Cliente | Crea un ticket y le asigna un agente |
| 2 | `GET` | `/tickets/{id}` | Cliente / Agente | Muestra un ticket |
| 3 | `PATCH` | `/tickets/{id}/estado` | Cliente / Agente | Cambia el estado de un ticket |
| 4 | `GET` | `/clientes/{dni}/tickets` | Cliente | Tickets de un cliente |
| 5 | `GET` | `/agentes/{dni}/tickets` | Agente | Tickets asignados a un agente |
| 6 | `GET` | `/reportes/frecuencia-categorias` | Agente | Cantidad de tickets por categoría |
| 7 | `GET` | `/reportes/tiempo-promedio-resolucion` | Agente | Tiempo promedio de resolución |
| 8 | `GET` | `/reportes/top-categorias` | Agente | Categorías con más tickets |

## 5. Objeto Ticket

Todos los endpoints que devuelven tickets usan esta forma:

```json
{
  "id": 1,
  "dni_cliente": "30123456",
  "categoria": "conexion",
  "descripcion": "No tengo internet desde ayer a la noche.",
  "estado": "asignado",
  "fecha_inicio": "2026-09-20T10:15:00Z",
  "fecha_finalizacion": null,
  "agente": { "dni": "25987654", "nombre": "María Gómez" }
}
```

## 6. Detalle de endpoints

### 1. `POST /tickets` — Crear ticket

El cliente reporta un problema. El servidor genera `id` y `fecha_inicio`, asigna un agente al azar y deja el estado en `asignado`.

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `dni_cliente` | texto (7-8 dígitos) | Sí | DNI del cliente |
| `categoria` | texto (lista fija) | Sí | Tipo de problema |
| `descripcion` | texto | Sí | Qué ocurrió |

```json
{
  "dni_cliente": "30123456",
  "categoria": "conexion",
  "descripcion": "No tengo internet desde ayer a la noche."
}
```

| Código | Respuesta |
|---|---|
| 201 | El ticket creado (objeto Ticket) |
| 400 | `{ "message": "Datos Invalidos" }` |
| 409 | `{ "message": "No Hay Agentes Disponibles" }` |

### 2. `GET /tickets/{id}` — Ver un ticket

| Código | Respuesta |
|---|---|
| 200 | Objeto Ticket |
| 404 | `{ "message": "Ticket No Encontrado" }` |

### 3. `PATCH /tickets/{id}/estado` — Cambiar estado

Lo usan los dos actores:

- El **agente** pasa el ticket a `en_proceso` y, cuando termina, a `en_revision`.
- El **cliente**, con el ticket en `en_revision`, lo pasa a `cerrado` si el problema fue resuelto, o lo devuelve a `en_proceso` si sigue.

Cuando el nuevo estado es `cerrado`, el servidor registra `fecha_finalizacion`.

```json
{ "estado": "cerrado" }
```

| Código | Respuesta |
|---|---|
| 200 | Objeto Ticket actualizado |
| 400 | `{ "message": "Datos Invalidos" }` (estado fuera de la lista) |
| 404 | `{ "message": "Ticket No Encontrado" }` |

Ejemplo de respuesta 200 al cerrar:

```json
{
  "id": 1,
  "dni_cliente": "30123456",
  "categoria": "conexion",
  "descripcion": "No tengo internet desde ayer a la noche.",
  "estado": "cerrado",
  "fecha_inicio": "2026-09-20T10:15:00Z",
  "fecha_finalizacion": "2026-09-20T13:15:00Z",
  "agente": { "dni": "25987654", "nombre": "María Gómez" }
}
```

### 4. `GET /clientes/{dni}/tickets` — Tickets del cliente

Devuelve los tickets del cliente, del más reciente al más antiguo. Como no hay tabla de clientes, un DNI sin tickets devuelve una lista vacía (no un 404).

| Código | Respuesta |
|---|---|
| 200 | Lista de objetos Ticket (puede estar vacía) |
| 400 | `{ "message": "Datos Invalidos" }` (DNI mal formado) |

### 5. `GET /agentes/{dni}/tickets` — Tickets asignados

Devuelve la bandeja de trabajo del agente, del ticket más antiguo al más reciente.

| Parámetro | Ubicación | Obligatorio | Descripción |
|---|---|---|---|
| `dni` | ruta | Sí | DNI del agente |
| `estado` | consulta | No | Filtra por estado (ej.: `?estado=en_proceso`) |

| Código | Respuesta |
|---|---|
| 200 | Lista de objetos Ticket (puede estar vacía) |
| 400 | `{ "message": "Datos Invalidos" }` |
| 404 | `{ "message": "Agente No Encontrado" }` |

### 6. `GET /reportes/frecuencia-categorias` — Frecuencia por categoría

Cantidad de tickets de cada categoría, incluidas las que tienen 0.

```json
[
  { "categoria": "conexion", "cantidad": 12 },
  { "categoria": "facturacion", "cantidad": 7 },
  { "categoria": "consulta_general", "cantidad": 4 },
  { "categoria": "otro", "cantidad": 0 }
]
```

### 7. `GET /reportes/tiempo-promedio-resolucion` — Tiempo promedio de resolución

Promedio, en horas, entre `fecha_inicio` y `fecha_finalizacion` de los tickets cerrados.

| Parámetro | Ubicación | Obligatorio | Descripción |
|---|---|---|---|
| `categoria` | consulta | No | Calcula el promedio solo para esa categoría |

```json
{ "categoria": null, "tickets_cerrados": 15, "promedio_horas": 6.4 }
```

Si no hay tickets cerrados, `tickets_cerrados` es `0` y `promedio_horas` es `null`.

| Código | Respuesta |
|---|---|
| 200 | Objeto con el promedio |
| 400 | `{ "message": "Datos Invalidos" }` (categoría fuera de la lista) |

### 8. `GET /reportes/top-categorias` — Top de categorías

Las N categorías con más tickets, de mayor a menor.

| Parámetro | Ubicación | Obligatorio | Descripción |
|---|---|---|---|
| `limite` | consulta | No | Cantidad de categorías (1 a 4). Por defecto 3. |

```json
[
  { "categoria": "conexion", "cantidad": 12 },
  { "categoria": "facturacion", "cantidad": 7 },
  { "categoria": "consulta_general", "cantidad": 4 }
]
```

| Código | Respuesta |
|---|---|
| 200 | Lista ordenada |
| 400 | `{ "message": "Datos Invalidos" }` (límite fuera de rango) |

## 7. Flujo típico de uso

| Paso | Quién | Llamada | Resultado |
|---|---|---|---|
| 1 | Cliente | `POST /tickets` | Ticket 1 creado, estado `asignado`, agente 25987654 |
| 2 | Agente | `GET /agentes/25987654/tickets` | Ve el ticket 1 en su bandeja |
| 3 | Agente | `PATCH /tickets/1/estado` `{ "estado": "en_proceso" }` | Empieza a trabajarlo |
| 4 | Agente | `PATCH /tickets/1/estado` `{ "estado": "en_revision" }` | Terminó; espera confirmación |
| 5 | Cliente | `GET /clientes/30123456/tickets` | Ve el ticket 1 en revisión |
| 6 | Cliente | `PATCH /tickets/1/estado` `{ "estado": "cerrado" }` | Ticket cerrado, se guarda `fecha_finalizacion` |
| 7 | Agente | `GET /reportes/tiempo-promedio-resolucion` | El ticket 1 entra en el promedio |

## 8. Relación con el enunciado

| Requisito del enunciado | Cómo lo cubre la API |
|---|---|
| Registrar qué ocurrió, a quién afecta y cuándo | `POST /tickets` guarda categoría, descripción, DNI del cliente y fecha de inicio |
| Que ninguna solicitud quede sin atender | Asignación automática de agente en `POST /tickets` |
| Actualizaciones de estado que reflejen el avance | `PATCH /tickets/{id}/estado` |
| Confirmación de que el problema fue resuelto | El cliente cierra el ticket; se guarda `fecha_finalizacion` |
| Estado visible en todo momento | `GET /clientes/{dni}/tickets` y `GET /agentes/{dni}/tickets` |
| Analizar frecuencia, tiempos y problemas más comunes | Los tres endpoints de `/reportes` |
