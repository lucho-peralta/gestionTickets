# Especificación OpenAPI — Tickets de Soporte

Responsable: Juan

Esta carpeta contiene la especificación **OpenAPI 3** de la REST API. La explicación completa de cada endpoint (supuestos, convenciones, ejemplos y flujo de uso) está en [`documentacion/19_rest_api.md`](../documentacion/19_rest_api.md); acá no se repite para no tener dos versiones.

## Archivos

| Archivo | Contenido |
|---|---|
| `openapi/main.yaml` | Punto de entrada: info, servidor, tags y rutas |
| `openapi/partials/common.yaml` | Esquemas compartidos (`dni`, `categoria`, `estado`, `agente`, `ticket`) y respuestas de error |
| `openapi/partials/tickets.yaml` | `POST /tickets`, `GET /tickets/{id}`, `PATCH /tickets/{id}/estado` |
| `openapi/partials/clientes.yaml` | `GET /clientes/{dni}/tickets` |
| `openapi/partials/agentes.yaml` | `GET /agentes/{dni}/tickets` |
| `openapi/partials/reportes.yaml` | Los tres endpoints de `/reportes` |

## Comandos útiles

```bash
# Validar la especificación
npx @redocly/cli lint tickets-openapi/openapi/main.yaml

# Ver la documentación en el navegador
npx @redocly/cli preview-docs tickets-openapi/openapi/main.yaml

# Generar un único archivo con todo resuelto
npx @redocly/cli bundle tickets-openapi/openapi/main.yaml -o tickets-openapi/openapi.bundle.yaml

# Levantar un mock de la API para los tests de la semana 5
npx @stoplight/prism-cli mock tickets-openapi/openapi.bundle.yaml
```
