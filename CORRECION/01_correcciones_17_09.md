# CORRECCIONES SUGERIDAS POR CLAUDE

## COMENTARIO: si necesitan que genere sus archivos con Claudito, me avisan y actualizo el repo. Sino, actualiza cada uno lo suyo.

Termino de auditar todo. Organizo primero los problemas transversales (los que afectan a varios archivos), después el detalle archivo por archivo.

Problemas transversales

1. El "sin login" no está firmemente establecido en ningún lado. Vos me marcaste que es una directiva del profesor a respetar a rajatabla: nadie se loguea, todos entran directo a la interfaz principal sin importar el rol, identificación solo por DNI cuando la función lo requiere. Pero ningún documento lo dice así de claro:

02_alcance_proyecto.md dice "no contará inicialmente con login tradicional" — la palabra "inicialmente" da a entender que es algo temporal, a agregar después. Contradice la firmeza que pedís.
04_requerimientos.md (RF-001) solo dice "No requiere contraseña" para el alta de usuario — no hay ninguna declaración general de que el sistema entero carece de pantalla de login y que todos entran directo.
06_api.md directamente dice: "Si el proyecto incorpora roles y autenticación en una etapa posterior, se podrían sumar los endpoints /auth/login y /auth/logout" — esto plantea el login como algo pendiente/futuro, exactamente lo contrario de lo que me acabás de aclarar.

Esto hay que resolverlo agregando una declaración explícita y firme (probablemente en Alcance y en Requerimientos) y sacando la sugerencia de /auth/login de la API.

2. Violación de la elección de herramienta por semana (Graphviz vs Mermaid). Ya lo vimos con Casos de Uso. Pero 12_diagrama_flujo_datos.md (DFD, Juan) tiene el mismo problema: usa flowchart LR / flowchart TD de Mermaid, cuando por la misma lógica que aplicamos a Casos de Uso (Mermaid solo está asignado a Secuencia y Estado), el DFD debería estar en Graphviz. Este archivo no se corrigió todavía.

3. Duplicación de contenido entre documentos. 02_alcance_proyecto.md tiene copiado el RF-001 a RNF-003 completo, que es contenido de 04_requerimientos.md. Vos mismo ya lo marcaste con un comentario en el archivo. Si mañana cambia algo en Requerimientos (por ejemplo, al aclarar el punto del login), hay que acordarse de cambiarlo en dos lugares o quedan contradictorios.

4. Referencias rotas a archivos que no existen. 11_metodologia_trabajo.md menciona 03_planificacion.md y S2_03_kanban.md como referencias — ninguno de los dos existe en el repo (el cronograma real es planifProfesor.md, y el kanban vive dentro de 07_plan_de_trabajo.md).

5. Contenido cruzado entre archivos 15 y 16. 15_diagrama_transicion_estado.md está vacío (solo "Responsable: Lucas"). El diagrama de transición de estados (stateDiagram-v2, los 5 estados) está metido dentro de 16_diagrama_actividades.md, que debería tener el diagrama de Actividades. Estos dos están invertidos.

6. Archivos con solo código, sin ninguna explicación ni fence de markdown. 08_gannt.md, 09_pert_cpm.md y 12_diagrama_flujo_datos.md pegan el código de diagrama en crudo, sin ```mermaid ni texto que diga qué muestra el diagrama. Encima, 08_gannt.md tiene un bug de formato: la última línea del Gantt se pegó sin salto de línea con "Responsable: Lucas" (...2026-11-16, 7dResponsable: Lucas), lo que probablemente rompe el render del diagrama.

7. Archivos vacíos. 14_diagrama_secuencias.md y 17_modelado_procesos_negocio.md no tienen contenido, solo el nombre del responsable. (15 también está vacío, ya cubierto en el punto 5.)

8. 06_api.md no corresponde a la semana en la que está. Tu planificación del profesor pide en Semana 1: "Documentar API básica (endpoints previstos)" — algo liviano, solo la lista de endpoints esperados. Lo que hay en 06_api.md es el diseño completo de API REST con bodies de request/response, justificación de PATCH vs PUT, decisiones de versionado — eso es literalmente lo que pide Semana 4: "Diseño de la REST API (endpoints, métodos, request/response, etc)", con herramientas como OpenAPI. O sea: el archivo está adelantando trabajo de Semana 4 bajo el nombre y la etapa de Semana 1, y ni siquiera usa las herramientas que Semana 4 pide (OpenAPI/Redocly) — es un markdown con JSON de ejemplo, no una spec real. Esto es exactamente lo que notaste vos.

9. enunciadoGral.md y planifProfesor.md no tienen ningún encabezado que aclare su rol. Están sueltos en la raíz del repo sin indicar que son material de referencia del profesor (no entregables del equipo). El equipo de frontend que reciba esto podría confundirlos con documentación propia del proyecto.

## DETALLE ESPECIFICO POR ARCHIVOS

**01_enunciado.md**: bien, consistente con enunciadoGral.md, sin problemas de fondo.
**02_alcance_proyecto.md**: duplicación de RF/RNF (punto 3) + wording débil del "sin login" (punto 1). Necesita reescritura para quedar solo con alcance real (qué entra/no entra, límites generales).
**03_procesos_problema.md**: bien, completo, sin contradicciones.
**04_requerimientos.md**: correcto en su contenido actual, pero le falta la declaración explícita de "sin login" (punto 1).
**05_actores_casos_de_uso.md**: buen nivel de detalle. Pero la matriz "Actores vs User Stories" no incluye US-009 (Ver Reportes Básicos) para ningún actor — un descuido real, porque en el resto del proyecto (diagrama de Casos de Uso) UC9 está asignado a Agente.
**06_api.md**: desalineado con la semana que le corresponde (punto 8) + menciona login como posible futuro (punto 1).
**07_plan_de_trabajo.md**: nombres de archivo desalineados en su propia tabla interna (punto ya visto antes).
**08_gannt.md**: sin fence, sin texto, bug de formato en la última línea (punto 6).
**09_pert_cpm.md**: sin fence, sin ningún texto explicativo ni "Responsable".
**10_flujo_control_versiones.md**: tiene buena explicación en prosa, pero falta el fence de mermaid.
**11_metodologia_trabajo.md**: buena prosa, pero con las dos referencias rotas (punto 4).
**12_diagrama_flujo_datos.md**: herramienta incorrecta (Mermaid en vez de Graphviz, punto 2), sin fence, sin "Responsable", sin explicación de qué representa cada nivel más allá del título.
**13_casos_de_uso.md**: ya corregido, consistente con la herramienta correcta.
**14_diagrama_secuencias.md**: vacío.
**15_diagrama_transicion_estado.md**: vacío, contenido real está en 16 (punto 5).
**16_diagrama_actividades.md**: tiene el contenido de Transición de Estado en vez de Actividades (punto 5); Actividades no existe todavía.
**17_modelado_procesos_negocio.md**: vacío.
**backend/aDesarrollar.md y README.md**: placeholders sin contenido.

Esto es la evaluación completa. Decime con qué documentos querés que empiece cuando me autorices a generar contenido nuevo.

## Modelo de Datos — Análisis de Almacenamientos (DFD)

El `12_diagrama_flujo_datos.md` actual define solo dos almacenamientos (D1: Usuarios, D2: Tickets). Cruzando esto contra los requerimientos funcionales y las User Stories, esas dos tablas no alcanzan para cubrir lo que el propio proyecto pide:

- RF-006/RF-007 piden un historial de comentarios (autor, timestamp, contenido) — relación uno-a-muchos que no entra como campo de Tickets.
- La postcondición de CU-06 dice explícitamente que el cambio de estado "se registra en su historial" — no alcanza con sobreescribir un campo `estado`, hace falta persistir cada transición.
- El criterio CA-7.2 de la User Story 7 (`05_actores_casos_de_uso.md`) pide "registro histórico" de las reasignaciones — mismo problema que el punto anterior.
- `06_api.md` ya da por hecho una tabla de Categorías (endpoint `/categorias`, campo `categoria_id`) que el DFD no refleja.
- RF-003 permite adjuntar archivos (plural) a un ticket, otra relación uno-a-muchos sin definición de dónde vive.

**Resolución propuesta (3 tablas, dentro del límite de simplicidad del proyecto):**

1. **Usuarios**: `dni` (PK), `nombre_completo`, `email`, `rol`.
2. **Tickets**: `id` (PK), `asunto`, `descripcion`, `categoria` (campo simple, sin tabla aparte), `adjuntos` (lista/JSON de archivos, sin tabla aparte), `estado`, `fecha_creacion`, `dni_cliente` (FK), `dni_agente_asignado` (FK, nullable).
3. **Eventos_Ticket**: `id` (PK), `ticket_id` (FK), `tipo_evento` (`comentario` / `cambio_estado` / `reasignacion`), `dni_actor`, `contenido` (solo si es comentario), `valor_anterior`, `valor_nuevo` (solo si es cambio de estado o reasignación), `timestamp`.

Esta tercera tabla unifica comentarios, historial de estado e historial de asignación en un solo registro de eventos, filtrable por tipo. Cubre los cuatro requisitos citados sin necesidad de una tabla separada para cada uno, y mantiene el modelo en 3 tablas en vez de 6 o 7.

**Impacto en otros documentos:** de aplicarse este modelo, `06_api.md` debería reemplazar el endpoint `/categorias` (que asume tabla propia) por una lista fija documentada, y agregar un endpoint de consulta de eventos/historial (por ejemplo `GET /tickets/{id}/eventos`) que hoy no existe.