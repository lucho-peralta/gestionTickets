# 06 - Diseño de la API REST

Sistema de Gestión de Tickets de Soporte

## 1. Objetivo

Este documento define los **endpoints** de la API: qué rutas existen, qué hace cada una, qué datos recibe y qué devuelve. Funciona como **contrato** entre el backend y cualquier cliente (web, mobile, etc.).

La API permite:

- Registrar tickets (reclamos, consultas o pedidos de ayuda) de los clientes.
- Asignar un agente de soporte a cada ticket.
- Actualizar el estado del ticket hasta su resolución.
- Consultar en todo momento el estado de cada caso, para que ninguna solicitud quede sin atender.

## 2. Alcance

| Supuesto | Detalle |
|---|---|
| Situación ideal | No se contemplan casos excepcionales fuera del flujo normal. |
| Clientes | Todo el que registra un ticket es un cliente y se identifica por su DNI. |
| Agentes | Ya están cargados en el sistema. La API solo los consulta, no los crea ni los elimina. |
| Asignación | Cada ticket tiene como máximo **un** agente asignado. |
| Tickets | No se eliminan, para que ninguna solicitud se pierda. |

## 3. Modelo de datos

La API trabaja sobre 3 tablas:

| Tabla | Campos | Descripción |
|---|---|---|
| `tickets` | `id`, `titulo`, `descripcion`, `fecha`, `DNI_cliente` | Cada solicitud reportada por un cliente. |
| `agente_asignado` | `DNI_agente_asignado` | Agentes que pueden resolver tickets. |
| `asignacion` | `id_ticket`, `DNI_agente_asignado`, `estado` | Tabla intermedia: qué agente tiene cada ticket y en qué estado está. |

## 4. Ciclo de vida del ticket

```
sin_asignar  →  asignado  →  en_proceso  →  resuelto
```

| Estado | Significado | Cómo se llega |
|---|---|---|
| `sin_asignar` | El ticket fue registrado pero todavía no tiene agente. | Al crear el ticket. No se guarda en la base: es un ticket **sin fila** en `asignacion`. |
| `asignado` | Tiene un agente, que todavía no empezó a trabajarlo. | Al asignar un agente. |
| `en_proceso` | El agente está trabajando en el caso. | El agente actualiza el estado. |
| `resuelto` | El problema fue resuelto. | El agente actualiza el estado. |

## 5. Convenciones generales

| Tema | Definición |
|---|---|
| URL base | `http://www.tickets.ar` |
| Formato | Todas las peticiones y respuestas usan JSON (`application/json`). |
| Autenticación | No se usa. La API es pública, de acuerdo al alcance (situación ideal). |
| DNI | Texto de 7 u 8 dígitos (ej.: `"30123456"`). Se usa texto porque no se hacen cuentas con él. |
| Fecha | Formato ISO 8601 (ej.: `"2026-09-20T10:15:00Z"`). La pone el servidor al crear el ticket. |
| Errores | Se devuelven como `{ "message": "texto del error" }`. |

### Códigos de respuesta

| Código | Significado | Cuándo se usa |
|---|---|---|
| 200 | OK | La operación salió bien. |
| 201 | Creado | Se creó un recurso (ticket o asignación). |
| 400 | Datos inválidos | Faltan datos obligatorios o tienen un formato incorrecto. |
| 404 | No encontrado | El ticket o el agente no existen. |
| 409 | Conflicto | El ticket ya tiene un agente asignado. |

## 6. Resumen de endpoints

| # | Verbo | Ruta | Qué hace |
|---|---|---|---|
| 1 | GET | `/tickets` | Lista los tickets con su agente y estado. |
| 2 | POST | `/tickets` | Registra un nuevo ticket. |
| 3 | GET | `/tickets/{id}` | Muestra un ticket en particular. |
| 4 | PATCH | `/tickets/{id}` | Corrige el título o la descripción de un ticket. |
| 5 | GET | `/tickets/{id}/asignacion` | Muestra el agente y el estado de un ticket. |
| 6 | POST | `/tickets/{id}/asignacion` | Asigna un agente a un ticket. |
| 7 | PATCH | `/tickets/{id}/asignacion` | Actualiza el estado de un ticket. |
| 8 | GET | `/agentes` | Lista los agentes disponibles. |
| 9 | GET | `/agentes/{dni}/tickets` | Lista los tickets asignados a un agente. |

## 7. Detalle de endpoints

### 7.1 Tickets

#### 1. `GET /tickets` - Listar tickets

Devuelve todos los tickets, cada uno con su agente y su estado actual. Permite al equipo de soporte ver todos los casos y priorizar.

**Parámetros de consulta (opcionales):**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `estado` | texto | Filtra por estado: `sin_asignar`, `asignado`, `en_proceso` o `resuelto`. |
| `dni_cliente` | texto | Filtra los tickets de un cliente. |

> `GET /tickets?estado=sin_asignar` muestra los tickets que todavía nadie está atendiendo.

**Respuestas:**

| Código | Descripción |
|---|---|
| 200 | Lista de tickets (puede estar vacía). |
| 400 | Filtro inválido. |

**Ejemplo de respuesta 200:**

```json
[
  {
    "id": 1,
    "titulo": "No puedo iniciar sesión",
    "descripcion": "Al ingresar mi usuario me dice contraseña incorrecta.",
    "fecha": "2026-09-20T10:15:00Z",
    "dni_cliente": "30123456",
    "dni_agente": "25987654",
    "estado": "en_proceso"
  },
  {
    "id": 2,
    "titulo": "Factura duplicada",
    "descripcion": "Me llegó dos veces la factura de agosto.",
    "fecha": "2026-09-21T14:40:00Z",
    "dni_cliente": "40111222",
    "dni_agente": null,
    "estado": "sin_asignar"
  }
]
```

#### 2. `POST /tickets` - Registrar un ticket

El cliente reporta un problema. El servidor genera el `id` y la `fecha`. El ticket nace **sin agente** y con estado `sin_asignar`.

**Datos que se envían (body):**

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `titulo` | texto (máx. 100) | Sí | Resumen de qué ocurrió. |
| `descripcion` | texto | Sí | Detalle del problema. |
| `dni_cliente` | texto | Sí | DNI del cliente afectado. |

```json
{
  "titulo": "No puedo iniciar sesión",
  "descripcion": "Al ingresar mi usuario me dice contraseña incorrecta.",
  "dni_cliente": "30123456"
}
```

**Respuestas:**

| Código | Descripción |
|---|---|
| 201 | Ticket creado. Devuelve el ticket completo. |
| 400 | Faltan datos o el DNI no es válido. |

**Ejemplo de respuesta 201:**

```json
{
  "id": 1,
  "titulo": "No puedo iniciar sesión",
  "descripcion": "Al ingresar mi usuario me dice contraseña incorrecta.",
  "fecha": "2026-09-20T10:15:00Z",
  "dni_cliente": "30123456",
  "dni_agente": null,
  "estado": "sin_asignar"
}
```

#### 3. `GET /tickets/{id}` - Ver un ticket

Devuelve un ticket con su agente y estado actual. Permite que el cliente o el agente vean en qué situación está el caso.

**Parámetros de ruta:**

| Parámetro | Tipo | Descripción |
|---|---|---|
| `id` | entero | Id del ticket. |

**Respuestas:**

| Código | Descripción |
|---|---|
| 200 | Ticket encontrado (mismo formato que en el endpoint 2). |
| 404 | `{ "message": "Ticket No Encontrado" }` |

#### 4. `PATCH /tickets/{id}` - Corregir un ticket

Permite corregir el título y/o la descripción si se cargaron mal. No cambia la fecha, el cliente ni el estado.

**Datos que se envían (body):** al menos uno de los dos campos.

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `titulo` | texto (máx. 100) | No | Nuevo título. |
| `descripcion` | texto | No | Nueva descripción. |

```json
{ "titulo": "No puedo iniciar sesión en la app" }
```

**Respuestas:**

| Código | Descripción |
|---|---|
| 200 | Ticket actualizado. Devuelve el ticket completo. |
| 400 | No se envió ningún campo o están vacíos. |
| 404 | Ticket no encontrado. |

### 7.2 Asignaciones

#### 5. `GET /tickets/{id}/asignacion` - Ver asignación

Devuelve qué agente tiene el ticket y en qué estado está.

**Respuestas:**

| Código | Descripción |
|---|---|
| 200 | Asignación del ticket. |
| 404 | `Ticket No Encontrado`, o `Ticket Sin Asignar` si todavía no tiene agente. |

**Ejemplo de respuesta 200:**

```json
{
  "id_ticket": 1,
  "dni_agente": "25987654",
  "estado": "en_proceso"
}
```

#### 6. `POST /tickets/{id}/asignacion` - Asignar agente

Asigna un agente al ticket. Crea una fila en `asignacion` con estado inicial `asignado`.

**Datos que se envían (body):**

| Campo | Tipo | Obligatorio | Descripción |
|---|---|---|---|
| `dni_agente` | texto | Sí | DNI del agente que va a resolver el ticket. |

```json
{ "dni_agente": "25987654" }
```

**Respuestas:**

| Código | Descripción |
|---|---|
| 201 | Agente asignado. Devuelve la asignación con estado `asignado`. |
| 400 | DNI inválido. |
| 404 | `Ticket No Encontrado` o `Agente No Encontrado`. |
| 409 | `Ticket Ya Asignado`: el ticket ya tiene un agente. |

#### 7. `PATCH /tickets/{id}/asignacion` - Actualizar estado

El agente informa el avance del caso o confirma que fue resuelto.

**Datos que se envían (body):**

| Campo | Tipo | Obligatorio | Valores posibles |
|---|---|---|---|
| `estado` | texto | Sí | `asignado`, `en_proceso`, `resuelto` |

```json
{ "estado": "resuelto" }
```

**Respuestas:**

| Código | Descripción |
|---|---|
| 200 | Estado actualizado. Devuelve la asignación. |
| 400 | Estado inválido. |
| 404 | `Ticket No Encontrado` o `Ticket Sin Asignar`. |

### 7.3 Agentes

#### 8. `GET /agentes` - Listar agentes

Devuelve los agentes cargados en el sistema, para saber a quién se le puede asignar un ticket.

**Respuestas:**

| Código | Descripción |
|---|---|
| 200 | Lista de agentes. |

**Ejemplo de respuesta 200:**

```json
[
  { "dni_agente": "25987654" },
  { "dni_agente": "28555111" }
]
```

#### 9. `GET /agentes/{dni}/tickets` - Tickets de un agente

Devuelve los tickets asignados a un agente: su "bandeja de trabajo".

**Parámetros:**

| Parámetro | Ubicación | Tipo | Obligatorio | Descripción |
|---|---|---|---|---|
| `dni` | ruta | texto | Sí | DNI del agente. |
| `estado` | consulta | texto | No | Filtra por `asignado`, `en_proceso` o `resuelto`. |

**Respuestas:**

| Código | Descripción |
|---|---|
| 200 | Lista de tickets del agente (mismo formato que en el endpoint 1). |
| 404 | Agente no encontrado. |

## 8. Flujo típico de uso

| Paso | Quién | Llamada | Resultado |
|---|---|---|---|
| 1 | Cliente | `POST /tickets` | Se registra el ticket, estado `sin_asignar`. |
| 2 | Soporte | `GET /tickets?estado=sin_asignar` | Ve los casos pendientes de atender. |
| 3 | Soporte | `GET /agentes` | Elige un agente. |
| 4 | Soporte | `POST /tickets/1/asignacion` | El ticket pasa a `asignado`. |
| 5 | Agente | `GET /agentes/25987654/tickets` | Ve su bandeja de trabajo. |
| 6 | Agente | `PATCH /tickets/1/asignacion` | Estado `en_proceso`. |
| 7 | Agente | `PATCH /tickets/1/asignacion` | Estado `resuelto`. |
| 8 | Cliente | `GET /tickets/1` | Ve que su caso fue resuelto. |

## 9. Relación con el enunciado

| Requisito del enunciado | Cómo lo cubre la API |
|---|---|
| Registrar qué ocurrió, a quién afecta y cuándo | `POST /tickets` guarda título, descripción, DNI del cliente y fecha. |
| Seguir el ticket desde que se reporta hasta su solución | Ciclo de estados `sin_asignar` → `asignado` → `en_proceso` → `resuelto`. |
| Actualizaciones de estado que reflejan el avance | `PATCH /tickets/{id}/asignacion`. |
| Priorizar y organizar el trabajo del equipo | Filtros por estado y bandeja por agente (`/agentes/{dni}/tickets`). |
| Evitar solicitudes sin atender | `GET /tickets?estado=sin_asignar`. Los tickets no se eliminan. |
| Estado visible en todo momento | Todo ticket se devuelve con su `estado` y su `dni_agente`. |
