# Metodología de Trabajo

El equipo trabaja con **entregas parciales semanales**, siguiendo el cronograma de la cátedra (`planifProfesor.md`), que ya funciona como una serie de entregas de una semana con un objetivo propio cada una. No se arma un esquema de sprints aparte porque duplicaría lo que el cronograma ya define.

## Ciclo semanal

| Momento | Qué se hace |
|---|---|
| **1. Reparto** (inicio de semana) | Se revisan las tareas de la semana y se asigna un responsable único a cada una. Queda cargado en el Kanban (`07_plan_de_trabajo_y_Kanban.md`). |
| **2. Ejecución** (durante la semana) | Cada uno trabaja su tarea en su propia rama, con commits chicos y frecuentes (ver `10_flujo_control_versiones.md`). |
| **3. Integración** (antes del corte) | Revisión cruzada por Pull Request, para que las tareas de la semana no queden inconsistentes entre sí. |

El tablero Kanban es la referencia del estado del equipo en todo momento.

## Entregas parciales

| Entrega | Semanas | Qué se entrega | Criterio de "terminado" |
|---|---|---|---|
| 1. Documentación de análisis | 1-2 | Documentos 01 a 11 | Revisados por el equipo y alineados al alcance |
| 2. Modelado | 3 | Documentos 12 a 17 y 21 | Diagramas renderizan y usan los mismos estados, datos y actores |
| 3. Diseño | 4 | Documentos 18 a 20, 22 y `documentacion/openapi/` | La especificación OpenAPI valida con Redocly |
| 4. Tests | 5 | Batería Happy Path en Hurl | Los tests pasan contra el mock de Prism |
| 5. Back-end | 6-8 | API funcionando en Docker | Los tests Happy Path pasan contra el back-end real |
| 6. Front-end | 9-11 | Interfaz web en Docker | Cliente y agente pueden hacer todas sus user stories |
| 7. Integración y cierre | 12-13 | Sistema completo con Docker Compose | Demo completa del flujo: crear → asignar → resolver → cerrar → reportes |
