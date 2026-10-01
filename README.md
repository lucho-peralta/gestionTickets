# Sistema de Gestión de Tickets de Soporte

Proyecto de la materia (ISFDT 166 — Análisis de Sistemas). Sistema web para registrar y seguir los reclamos, consultas o pedidos de ayuda de los clientes de un servicio, desde que se reportan hasta que se resuelven.

**Equipo:** Franco · Juan · Luciano · Lucas

## Cómo funciona el sistema (resumen)

| Quién | Qué hace |
|---|---|
| **Cliente** | Crea un ticket con su DNI, consulta sus tickets por DNI y confirma (cierra) el ticket cuando su problema fue resuelto. |
| **Agente de soporte** | Consulta los tickets que tiene asignados (por su DNI) y les cambia el estado; cuando termina su trabajo, lo pasa a *En revisión* para que el cliente confirme. También consulta los reportes. |

Además, al crear un ticket el sistema **asigna automáticamente un agente**, y cuando se consultan los reportes los calcula: frecuencia por categoría, tiempo promedio de resolución y top de categorías.

Ciclo de vida del ticket: **Asignado → En proceso → En revisión → Cerrado**.

No hay login ni contraseñas: todos entran directo a la interfaz principal y se identifican con su **DNI** cuando la función lo requiere.

## Estructura del repositorio

| Ruta | Contenido |
|---|---|
| `enunciadoGral.md` | Enunciado original de la cátedra (referencia). |
| `planifProfesor.md` | Cronograma semanal de la cátedra (referencia). |
| `documentacion/` | Entregables del equipo, numerados según el cronograma. |
| `tickets-openapi/` | Especificación OpenAPI 3 de la REST API. |
| `backend/` | Código del back-end (a desarrollar). |

## Índice de la documentación

| Semana | Archivo | Tema |
|---|---|---|
| 1 | [01_enunciado.md](documentacion/01_enunciado.md) | Enunciado del sistema |
| 1 | [02_alcance_proyecto.md](documentacion/02_alcance_proyecto.md) | Alcance del proyecto |
| 1 | [03_procesos_problema.md](documentacion/03_procesos_problema.md) | Procesos actuales y problemas |
| 1 | [04_requerimientos.md](documentacion/04_requerimientos.md) | Requerimientos funcionales y no funcionales |
| 1 | [05_actores_casos_de_uso.md](documentacion/05_actores_casos_de_uso.md) | Actores, user stories y escenarios Gherkin |
| 1 | [06_api.md](documentacion/06_api.md) | API básica (endpoints previstos) |
| 2 | [07_plan_de_trabajo_y_Kanban.md](documentacion/07_plan_de_trabajo_y_Kanban.md) | Plan de trabajo y Kanban |
| 2 | [08_gannt.md](documentacion/08_gannt.md) | Diagrama de Gantt |
| 2 | [09_pert_cpm.md](documentacion/09_pert_cpm.md) | PERT / CPM |
| 2 | [10_flujo_control_versiones.md](documentacion/10_flujo_control_versiones.md) | Flujo de control de versiones |
| 2 | [11_metodologia_trabajo.md](documentacion/11_metodologia_trabajo.md) | Metodología y entregas parciales |
| 3 | [12_diagrama_flujo_datos.md](documentacion/12_diagrama_flujo_datos.md) | Diagramas de flujo de datos |
| 3 | [13_casos_de_uso.md](documentacion/13_casos_de_uso.md) | Diagrama y plantillas de casos de uso |
| 3 | [14_diagrama_secuencias.md](documentacion/14_diagrama_secuencias.md) | Diagramas de secuencia |
| 3 | [15_diagrama_transicion_estado.md](documentacion/15_diagrama_transicion_estado.md) | Transición de estados del ticket |
| 3 | [16_diagrama_actividades.md](documentacion/16_diagrama_actividades.md) | Diagrama de actividades |
| 3 | [17_modelado_procesos_negocio.md](documentacion/17_modelado_procesos_negocio.md) | Modelado del proceso de negocio |
| 4 | [18_arquitectura.md](documentacion/18_arquitectura.md) | Arquitectura general |
| 4 | [19_rest_api.md](documentacion/19_rest_api.md) | Diseño de la REST API |
| 4 | [20_herramientas_frameworks_librerias.md](documentacion/20_herramientas_frameworks_librerias.md) | Herramientas, frameworks y librerías |
| 3/4 | [21_diccionario_de_datos.md](documentacion/21_diccionario_de_datos.md) | Diccionario de datos |
| 4 | [22_diseno_datos_erd.md](documentacion/22_diseno_datos_erd.md) | Diseño de datos (ERD) |

## Cómo ver los diagramas

- **Mermaid** (Gantt, Kanban, secuencia, estados, actividades, arquitectura, ERD): se ven directo en GitHub o pegando el código en <https://mermaid.live>.
- **Graphviz** (DFD, casos de uso, proceso de negocio): pegar el bloque `dot` en <https://dreampuf.github.io/GraphvizOnline>.
- **OpenAPI**: `npx @redocly/cli preview-docs tickets-openapi/openapi/main.yaml`.
