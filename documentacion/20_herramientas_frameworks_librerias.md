# Herramientas, Frameworks y Librerías

## Lenguaje

JavaScript. Entorno de ejecución: Node.js.

## Framework HTTP

Express. Implementa la capa Controlador.

## API

OpenAPI, spec escrito a mano en YAML a partir de `06_api.md`. Redocly CLI, para renderizar y validar ese spec.

## Validación

Zod — pendiente de validación. Define y valida los esquemas de entrada de cada endpoint antes de pasar el request al Servicio.

## Base de datos

PostgreSQL. Almacena los datos de Usuarios, Tickets y Eventos_Ticket.

## Acceso a datos (Repositorio)

pg (driver nativo de PostgreSQL), con SQL explícito en cada implementación de Repositorio.

## Testing

Hurl y Prism, para la batería de tests de Happy Path sobre el contrato OpenAPI. Ambas herramientas están listadas por la cátedra para Semana 5.

## Configuración

dotenv, para variables de entorno (cadena de conexión a la base, puerto del servidor).

## Calidad de código

ESLint y Prettier.

## Contenedores

Docker (Dockerfile): empaqueta el backend como una imagen ejecutable, con Node.js y sus dependencias incluidas, para que corra igual en cualquier máquina.

Docker Compose: levanta juntos, con un solo comando, el backend y la base de datos PostgreSQL (y más adelante el frontend), cada uno en su propio contenedor.
