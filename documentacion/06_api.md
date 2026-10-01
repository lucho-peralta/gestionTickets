# API Básica — Endpoints Previstos

Este documento corresponde a la Semana 1 ("Documentar API básica"): lista **qué endpoints va a tener la API** y quién los usa. El diseño completo (request, response, códigos de error) está en `19_rest_api.md` y en la especificación OpenAPI de `tickets-openapi/`.

## Convenciones

- Sin login ni autenticación: ningún endpoint pide usuario o contraseña. La identificación es por DNI.
- Formato JSON.
- El cliente no se registra: su DNI viaja dentro del ticket.
- Los agentes están precargados: la API no los crea ni los modifica.

## Endpoints

| # | Quién lo usa | Verbo | Ruta | Qué hace |
|---|---|---|---|---|
| 1 | Cliente | `POST` | `/tickets` | Crea un ticket. El sistema asigna un agente, pone la fecha de inicio y el estado **Asignado**. |
| 2 | Cliente / Agente | `GET` | `/tickets/{id}` | Muestra un ticket puntual. |
| 3 | Cliente / Agente | `PATCH` | `/tickets/{id}/estado` | Modifica el estado del ticket. El agente lo pasa a *En proceso* o *En revisión*; el cliente lo pasa a *Cerrado* (o lo devuelve a *En proceso*). |
| 4 | Cliente | `GET` | `/clientes/{dni}/tickets` | Consulta los tickets del cliente por su DNI. |
| 5 | Agente | `GET` | `/agentes/{dni}/tickets` | Consulta los tickets asignados al agente. Filtro opcional por estado. |
| 6 | Agente | `GET` | `/reportes/frecuencia-categorias` | Cantidad de tickets por categoría. |
| 7 | Agente | `GET` | `/reportes/tiempo-promedio-resolucion` | Tiempo promedio de resolución de los tickets cerrados. |
| 8 | Agente | `GET` | `/reportes/top-categorias` | Categorías con más tickets (por defecto, las 3 primeras). |

> **Asignar agente** es una acción del sistema que ocurre **dentro** del endpoint 1; no tiene un endpoint propio.

## Relación con los requerimientos

| Requerimiento | Endpoint |
|---|---|
| RF-01 Crear ticket | 1 |
| RF-02 Asignar agente | 1 (automático) |
| RF-03 Consultar tickets del cliente | 4, 2 |
| RF-04 Confirmar resolución (cliente) | 3 |
| RF-05 Consultar tickets asignados | 5, 2 |
| RF-06 Actualizar estado (agente) | 3 |
| RF-07 Frecuencia por categoría | 6 |
| RF-08 Tiempo promedio de resolución | 7 |
| RF-09 Top de categorías | 8 |
