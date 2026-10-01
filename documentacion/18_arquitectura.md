# Diseño de la Arquitectura General

Responsable: Luciano

Alcance: bloques del sistema y cómo se comunican. El detalle de los endpoints está en `19_rest_api.md`, el de las tablas en `22_diseno_datos_erd.md` y las tecnologías concretas en `20_herramientas_frameworks_librerias.md`.

## Diagrama de arquitectura

```mermaid
architecture-beta
    group frontend(cloud)[Front-end]
    group backend(server)[Back-end]
    group persistencia(database)[Persistencia]

    service app(internet)[Aplicacion Web] in frontend
    service controlador(server)[Controladores] in backend
    service servicio(server)[Servicios] in backend
    service dominio(server)[Dominio] in backend
    service repositorio(disk)[Repositorios] in backend
    service bd(database)[Base de Datos] in persistencia

    app:R -- L:controlador
    controlador:R -- L:servicio
    servicio:B -- T:dominio
    servicio:R -- L:repositorio
    repositorio:R -- L:bd
```

Cada bloque corre en su propio contenedor Docker (front-end, back-end y base de datos) y se levantan juntos con Docker Compose.

## Bloques

**Front-end.** Aplicación web con tres secciones accesibles desde la pantalla principal, sin login: *Soy cliente* (crear ticket, mis tickets, confirmar resolución), *Soy agente* (tickets asignados, cambiar estado) y *Reportes*. Se comunica con el back-end solo por HTTP/JSON; nunca accede a la base de datos.

**Controladores.** Reciben la petición HTTP, validan su forma (campos obligatorios, tipos, valores de las listas fijas), llaman al servicio correspondiente y arman la respuesta HTTP.

| Controlador | Endpoints |
|---|---|
| `TicketControlador` | `POST /tickets`, `GET /tickets/{id}`, `PATCH /tickets/{id}/estado` |
| `ClienteControlador` | `GET /clientes/{dni}/tickets` |
| `AgenteControlador` | `GET /agentes/{dni}/tickets` |
| `ReporteControlador` | `GET /reportes/frecuencia-categorias`, `GET /reportes/tiempo-promedio-resolucion`, `GET /reportes/top-categorias` |

**Servicios.** Orquestan cada caso de uso y aplican las reglas de negocio.

| Servicio | Responsabilidades |
|---|---|
| `TicketService` | Crear ticket (pide un agente a `AsignacionService`, fija estado `asignado` y `fecha_inicio`), consultar por cliente y por agente, cambiar estado (si el nuevo estado es `cerrado`, fija `fecha_finalizacion`). |
| `AsignacionService` | Elegir un agente al azar entre los cargados; si no hay, lanza `SinAgentesDisponibles`. |
| `ReporteService` | Frecuencia por categoría, tiempo promedio de resolución y top de categorías. |

**Dominio.** Dos entidades:

- `Agente` (`dni`, `nombre`).
- `Ticket` (`id`, `dniCliente`, `dniAgente`, `categoria`, `descripcion`, `fechaInicio`, `fechaFinalizacion`, `estado`). Regla propia: `cambiarEstado(nuevo)` actualiza el estado y, si es `cerrado`, registra la fecha de finalización.

Las listas fijas (`Categoria`, `Estado`) se definen como constantes del dominio.

**Repositorios.** Uno por entidad, expuestos como interfaz. Reciben y devuelven objetos del dominio, nunca filas crudas.

| Repositorio | Operaciones |
|---|---|
| `AgenteRepositorio` | `listar()`, `buscarPorDni(dni)` |
| `TicketRepositorio` | `guardar(ticket)`, `buscarPorId(id)`, `buscarPorCliente(dni)`, `buscarPorAgente(dni, estado?)`, `actualizarEstado(ticket)`, `contarPorCategoria()`, `promedioResolucion(categoria?)` |

**Base de datos.** Dos tablas: `agente` y `ticket`. Solo la acceden los repositorios.

## Validación

| Tipo | Dónde | Ejemplos |
|---|---|---|
| De forma | Controlador | Campos obligatorios, DNI de 7 u 8 dígitos, categoría y estado dentro de sus listas |
| De negocio | Servicio | Existe el ticket, existe el agente, hay agentes para asignar |

Siguiendo el criterio de validaciones mínimas del alcance, no se validan las transiciones entre estados.

## Manejo de errores

| Error | Se origina en | Código HTTP |
|---|---|---|
| Datos inválidos | Controlador | 400 |
| Ticket o agente inexistente | Servicio | 404 |
| No hay agentes disponibles | `AsignacionService` | 409 |
| Error no previsto | Cualquier capa | 500 |

Un manejador central captura las excepciones y las traduce a la respuesta `{ "message": "..." }` definida en `19_rest_api.md`.

## Flujo de una petición (ejemplo: crear ticket)

1. `TicketControlador` recibe `POST /tickets` y valida que vengan DNI, categoría válida y descripción.
2. Llama a `TicketService.crear(datos)`.
3. `TicketService` pide un agente a `AsignacionService`, que consulta `AgenteRepositorio.listar()` y elige uno al azar.
4. `TicketService` crea el `Ticket` con estado `asignado` y `fechaInicio` = ahora.
5. `TicketRepositorio.guardar(ticket)` lo inserta y devuelve el ticket con su `id`.
6. El controlador responde `201` con el ticket creado.
