# Diseño de la REST API

Alcance: endpoints, verbos, request/response y contrato de error. No incluye campos ni relaciones de tablas (ERD) ni framework o librería concretos (punto 4).

## Convenciones generales

- Identificación exclusiva por DNI. No existe login ni logout en ningún endpoint.
- Formato de datos: JSON.
- Base URL: `https://api.ticketsystem.com` (a revisar)
- `POST` crea recursos. `GET` los lee. `PATCH` actualiza parcialmente (estado, asignación) — no reemplazan el ticket completo, por eso no se usa `PUT`.
- Categorías: lista fija, no es un recurso de base de datos ni tiene endpoint propio. Valores (definidos para este documento, no provienen de otro archivo del proyecto): `Soporte Técnico`, `Facturación`, `Reclamo por Servicio`, `Consulta General`, `Otro`.

## Endpoints

| Recurso | Endpoint | Verbo | Descripción |
|---|---|---|---|
| Usuarios | `/usuarios` | POST | Crea un usuario (Cliente o Agente). |
| Usuarios | `/usuarios/{dni}` | GET | Obtiene un usuario por DNI. |
| Tickets | `/tickets` | POST | Crea un ticket. |
| Tickets | `/tickets` | GET | Lista tickets. Query params: `estado`, `categoria`, `orderBy=fecha`. |
| Tickets | `/tickets/{id}` | GET | Detalle del ticket (sin historial). |
| Tickets | `/tickets/buscar?dni={dni}` | GET | Tickets asociados a un DNI (creados si es Cliente, asignados si es Agente). |
| Tickets | `/tickets/{id}/estado` | PATCH | Actualiza el estado del ticket. |
| Tickets | `/tickets/{id}/asignar` | PATCH | Asigna el ticket a un agente. |
| Eventos | `/tickets/{id}/eventos` | GET | Historial completo del ticket (comentarios, cambios de estado, reasignaciones), orden cronológico. Query param opcional `tipo` (`comentario`, `cambio_estado`, `reasignacion`). |
| Eventos | `/tickets/{id}/comentarios` | POST | Agrega un comentario al ticket (se registra como evento tipo `comentario`). |
| Reportes | `/reportes/resumen` | GET | Total de tickets, tickets por estado, categorías más frecuentes. |

## Detalle de request/response

### POST /usuarios

Request:
```json
{
  "nombre": "string",
  "dni": "string",
  "email": "string",
  "rol": "Cliente | Agente"
}
```

Response (201):
```json
{
  "dni": "string",
  "nombre": "string",
  "email": "string",
  "rol": "Cliente | Agente"
}
```

### GET /usuarios/{dni}

Response (200): mismo cuerpo que la creación.

### POST /tickets

Request:
```json
{
  "dni_cliente": "string",
  "asunto": "string",
  "descripcion": "string",
  "categoria": "string",
  "adjuntos": ["string"]
}
```

Response (201):
```json
{
  "id": "string",
  "asunto": "string",
  "descripcion": "string",
  "categoria": "string",
  "adjuntos": ["string"],
  "estado": "Abierto",
  "fecha_creacion": "string (ISO 8601)",
  "dni_cliente": "string",
  "dni_agente_asignado": null
}
```

### GET /tickets

Query params: `estado`, `categoria`, `orderBy=fecha`.

Response (200): lista de objetos con la misma forma que la respuesta de `POST /tickets`.

### GET /tickets/{id}

Response (200): un objeto con la misma forma que la respuesta de `POST /tickets`.

### GET /tickets/buscar?dni={dni}

Response (200): lista de tickets. Si el DNI corresponde a un Cliente, tickets donde `dni_cliente` coincide. Si corresponde a un Agente, tickets donde `dni_agente_asignado` coincide.

### PATCH /tickets/{id}/estado

Request:
```json
{
  "estado": "Abierto | En Progreso | Esperando al Cliente | Resuelto | Cerrado",
  "dni_agente": "string"
}
```

Transiciones válidas desde el estado actual: ver `15_diagrama_transicion_estado.md`.

Response (200): objeto ticket actualizado.

### PATCH /tickets/{id}/asignar

Request:
```json
{
  "dni_agente": "string",
  "dni_asignador": "string"
}
```

Response (200): objeto ticket actualizado, con `dni_agente_asignado` reemplazado.

### GET /tickets/{id}/eventos

Response (200):
```json
[
  {
    "id": "string",
    "ticket_id": "string",
    "tipo_evento": "comentario | cambio_estado | reasignacion",
    "dni_actor": "string",
    "contenido": "string",
    "valor_anterior": "string | null",
    "valor_nuevo": "string | null",
    "timestamp": "string (ISO 8601)"
  }
]
```

### POST /tickets/{id}/comentarios

Request:
```json
{
  "dni_autor": "string",
  "contenido": "string"
}
```

Response (201): objeto evento con `tipo_evento: "comentario"`, misma forma que en `GET /tickets/{id}/eventos`.

### GET /reportes/resumen

Response (200):
```json
{
  "total_tickets": "number",
  "por_estado": { "Abierto": "number", "En Progreso": "number", "Esperando al Cliente": "number", "Resuelto": "number", "Cerrado": "number" },
  "categorias_mas_frecuentes": [{ "categoria": "string", "cantidad": "number" }]
}
```

## Contrato de error

Toda respuesta de error tiene esta forma:

```json
{
  "error": "string (código)",
  "mensaje": "string"
}
```

| Código HTTP | Clase | Códigos de `error` |
|---|---|---|
| 400 | Error de formato | `CAMPO_OBLIGATORIO_FALTANTE`, `ASUNTO_OBLIGATORIO`, `DESCRIPCION_OBLIGATORIA`, `CATEGORIA_OBLIGATORIA`, `COMENTARIO_VACIO` |
| 404 | Recurso inexistente | `USUARIO_NO_ENCONTRADO`, `TICKET_NO_ENCONTRADO` |
| 409 | Conflicto de negocio | `DNI_YA_REGISTRADO`, `TRANSICION_ESTADO_INVALIDA` |
| 500 | Error no previsto | `ERROR_INTERNO` |

## Fuera de alcance de este documento

- Campos, tipos y relaciones de tablas → ERD.
- Framework, librería de validación, motor de base de datos → punto 4.

