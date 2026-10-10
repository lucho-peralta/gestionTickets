# Herramientas, Frameworks y Librerías

| Área | Elección | Para qué |
|---|---|---|
| Lenguaje | **JavaScript** sobre **Node.js** | Back-end |
| Framework HTTP | **Express** | Capa de controladores y ruteo |
| Especificación de la API | **OpenAPI 3** escrito a mano en YAML (`documentacion/openapi/`) | Contrato entre back-end y front-end |
| Documentación de la API | **Redocly CLI** | Validar y renderizar la especificación |
| Validación de entrada | **Zod** (a confirmar) | Validar el body y los parámetros de cada endpoint |
| Base de datos | **PostgreSQL** | Tablas `agente` y `ticket` |
| Acceso a datos | **pg** (driver nativo) | SQL explícito dentro de cada repositorio |
| Testing | **Hurl** + **Prism** | Tests Happy Path contra el mock de Prism (semana 5) y después contra el back-end real |
| Configuración | **dotenv** | Variables de entorno (conexión a la base, puerto) |
| Calidad de código | **ESLint** + **Prettier** | Estilo y errores comunes |
| Contenedores | **Docker** (Dockerfile) | Empaquetar back-end y front-end |
| Orquestación local | **Docker Compose** | Levantar front-end, back-end y PostgreSQL con un solo comando |
| Diagramas | **Mermaid** y **Graphviz** | Según la herramienta indicada en cada semana del cronograma |
| Diseño de datos | **drawDB** | Importar el script SQL de `22_diseno_datos_erd.md` y visualizar el ERD |
| Front-end | A definir en la semana 9 | Opciones de la cátedra: Alpine, Preact, Mithril, Pico CSS, Bulma, entre otras |

## Datos iniciales

Para que el sistema arranque con agentes, el back-end incluye un script SQL de **seed** que inserta los agentes iniciales al crear la base (ver `22_diseno_datos_erd.md`). Después se pueden dar de alta y de baja con `POST /agentes` y `DELETE /agentes/{dni}`.
