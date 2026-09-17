# CORRECCIONES SUGERIDAS POR CLAUDE

## COMENTARIO: si necesitan que genere sus archivos con Claudito, me avisan y actualizo el repo. Sino, actualiza cada uno lo suyo.

Termino de auditar todo. Organizo primero los problemas transversales (los que afectan a varios archivos), después el detalle archivo por archivo.

## Problemas transversales

1. El "sin login" no está firmemente establecido en ningún lado. Es una directiva del profesor a respetar a rajatabla: nadie se loguea, todos entran directo a la interfaz principal sin importar el rol, identificación solo por DNI cuando la función lo requiere. Pero ningún documento lo dice así de claro:

- `02_alcance_proyecto.md` dice "no contará inicialmente con login tradicional" — la palabra "inicialmente" da a entender que es algo temporal, a agregar después. Contradice la firmeza que se pide.
- `04_requerimientos.md` (RF-001) solo dice "No requiere contraseña" para el alta de usuario — no hay ninguna declaración general de que el sistema entero carece de pantalla de login y que todos entran directo.
- `06_api.md` directamente dice: "Si el proyecto incorpora roles y autenticación en una etapa posterior, se podrían sumar los endpoints /auth/login y /auth/logout" — esto plantea el login como algo pendiente/futuro, exactamente lo contrario de lo que se pidió aclarar.

Esto hay que resolverlo agregando una declaración explícita y firme (probablemente en Alcance y en Requerimientos) y sacando la sugerencia de /auth/login de la API.

2. Violación de la elección de herramienta por semana (Graphviz vs Mermaid). Ya se corrigió en Casos de Uso. Pero `12_diagrama_flujo_datos.md` (DFD, Juan) sigue con el mismo problema: usa `flowchart LR` / `flowchart TD` de Mermaid, cuando por la misma lógica aplicada a Casos de Uso (Mermaid solo está asignado a Secuencia y Estado), el DFD debería estar en Graphviz.

3. Duplicación de contenido entre documentos. `02_alcance_proyecto.md` tiene copiado el RF-001 a RNF-003 completo, que es contenido de `04_requerimientos.md`. Si mañana cambia algo en Requerimientos, hay que acordarse de cambiarlo en dos lugares o quedan contradictorios.

4. Referencias rotas a archivos que no existen. `11_metodologia_trabajo.md` menciona `03_planificacion.md` y `S2_03_kanban.md` — ninguno de los dos existe en el repo (el cronograma real es `planifProfesor.md`, y el kanban vive dentro del plan de trabajo).

5. El diagrama de Actividades (`16_diagrama_actividades.md`) ya tiene contenido propio y correcto. Pero al corregirlo, el diagrama de Transición de Estado que antes estaba (mal ubicado) ahí adentro desapareció — no se movió a `15_diagrama_transicion_estado.md`, que sigue completamente vacío (solo "Responsable: Lucas"). Resultado: hoy el proyecto no tiene ningún diagrama de Transición de Estado. Hay que rehacerlo desde cero en el archivo 15 (los 5 estados y sus transiciones ya están definidos en RF-005, no hace falta inventar nada nuevo, solo modelarlos).

6. Archivos con solo código, sin explicación ni fence de markdown. `08_gannt.md`, `09_pert_cpm.md` y `12_diagrama_flujo_datos.md` pegan el código de diagrama en crudo, sin ` ```mermaid ` ni texto que diga qué muestra. `08_gannt.md` tiene un bug de formato: la última línea del Gantt está pegada sin salto de línea con "Responsable: Lucas", lo que probablemente rompe el render.

7. Archivos vacíos: `17_modelado_procesos_negocio.md` sigue sin contenido. `15` también sigue vacío (punto 5), con el agravante de que el contenido que tenía se perdió.

8. `06_api.md` no corresponde a la semana en la que está. La planificación del profesor pide en Semana 1 solo "Documentar API básica (endpoints previstos)". Lo que hay en `06_api.md` es el diseño completo de API REST con bodies de request/response, justificación de PATCH vs PUT, decisiones de versionado — eso es lo que pide Semana 4, con herramientas como OpenAPI que acá ni se usan.

9. `enunciadoGral.md` y `planifProfesor.md` no tienen encabezado que aclare su rol de referencia (no son entregables del equipo).

10. El plan de trabajo quedó duplicado: `07_plan_de_trabajo.md` (vacío, 0 bytes) y `07_plan_de_trabajo_y_Kanban.md` (contenido real). La tabla de Semana 2 dentro de este último sigue mencionando `07_plan_de_trabajo.md` como nombre de archivo — desalineado de su propio nombre real. Hay que borrar el archivo viejo vacío y corregir la referencia interna.

## DETALLE ESPECIFICO POR ARCHIVOS

**01_enunciado.md**: bien, consistente con `enunciadoGral.md`.

**02_alcance_proyecto.md**: duplicación de RF/RNF (punto 3) + wording débil del "sin login" (punto 1).

**03_procesos_problema.md**: bien, completo, sin contradicciones.

**04_requerimientos.md**: correcto, pero le falta la declaración explícita de "sin login" (punto 1).

**05_actores_casos_de_uso.md**: buen nivel de detalle, pero la matriz "Actores vs User Stories" no incluye US-009 para ningún actor.

**06_api.md**: desalineado con su semana (punto 8) + menciona login como posible futuro (punto 1).

**07_plan_de_trabajo_y_Kanban.md**: contenido correcto y actualizado (incluye "En revisión"), pero ver punto 10.

**08_gannt.md**: sin fence, sin texto, bug de formato sin corregir (punto 6).

**09_pert_cpm.md**: sin fence, sin texto explicativo ni "Responsable".

**10_flujo_control_versiones.md**: buena explicación en prosa, falta el fence de mermaid.

**11_metodologia_trabajo.md**: buena prosa, con las dos referencias rotas (punto 4).

**12_diagrama_flujo_datos.md**: herramienta incorrecta (punto 2), sin fence, sin "Responsable", sin explicación de cada nivel.

**13_casos_de_uso.md**: ya corregido, consistente con la herramienta correcta.

**14_diagrama_secuencias.md**: ya tiene contenido (3 diagramas: Crear Ticket, Actualizar Estado, Agregar Comentario), pero arranca directo en "### 2." sin que exista un "### 1." ni título/introducción al inicio; el primer ítem tiene la etiqueta poco clara "(Duplicado provisto)"; y el último bloque de código no tiene el cierre ` ``` `, lo que rompe el render de todo lo que venga después.

**15_diagrama_transicion_estado.md**: sigue vacío. El contenido que debía tener se perdió al corregir el archivo 16 (punto 5) — hay que rehacerlo.

**16_diagrama_actividades.md**: ya tiene su diagrama de Actividades propio y correcto. Detalles menores: el encabezado está mal escrito como `##Diagrama de Actividades` (sin espacio, no va a renderizar como título), y el flowchart sigue sin fence de mermaid.

**17_modelado_procesos_negocio.md**: vacío.

**backend/aDesarrollar.md y README.md**: placeholders sin contenido.

## Modelo de Datos — Análisis de Almacenamientos (DFD)

El `12_diagrama_flujo_datos.md` actual define solo dos almacenamientos (D1: Usuarios, D2: Tickets). Cruzando esto contra los requerimientos, esas dos tablas no alcanzan:

- RF-006/RF-007 piden un historial de comentarios — relación uno-a-muchos que no entra como campo de Tickets.
- La postcondición de CU-06 dice explícitamente que el cambio de estado "se registra en su historial" — no alcanza con sobreescribir un campo `estado`.
- El criterio CA-7.2 de la User Story 7 pide "registro histórico" de las reasignaciones.
- `06_api.md` ya da por hecho una tabla de Categorías (`/categorias`, `categoria_id`) que el DFD no refleja.
- RF-003 permite adjuntar archivos (plural), otra relación uno-a-muchos sin definición de dónde vive.

**Resolución propuesta (3 tablas):**

1. **Usuarios**: `dni` (PK), `nombre_completo`, `email`, `rol`.
2. **Tickets**: `id` (PK), `asunto`, `descripcion`, `categoria`, `adjuntos` (lista/JSON), `estado`, `fecha_creacion`, `dni_cliente` (FK), `dni_agente_asignado` (FK, nullable).
3. **Eventos_Ticket**: `id` (PK), `ticket_id` (FK), `tipo_evento` (`comentario`/`cambio_estado`/`reasignacion`), `dni_actor`, `contenido`, `valor_anterior`, `valor_nuevo`, `timestamp`.

**Impacto en otros documentos:** `06_api.md` debería reemplazar `/categorias` por una lista fija documentada, y agregar un endpoint de historial (`GET /tickets/{id}/eventos`) que hoy no existe.