
// corregir todo, está todo mezclado.


# Sistema de Gestión de Tickets de Soporte

## Alcance del Proyecto

El proyecto consiste en desarrollar un **Sistema de Gestión de Tickets de Soporte** orientado a centralizar y organizar consultas y reclamos.

El sistema tendrá una **interfaz web única**, identificación mediante **DNI** y no contará inicialmente con login tradicional, contraseña ni administrador.

### Alcance Funcional

#### RF-001: Crear Usuario

- El sistema permite crear clientes y agentes.
- Datos requeridos: nombre completo, DNI, email y rol (Cliente o Agente).
- El botón «Crear Usuario» es accesible en la interfaz principal.
- Valida que el DNI sea único en el sistema.
- No requiere contraseña.

#### RF-002: Buscar Tickets por DNI

- El usuario ingresa su DNI en pantalla.
- El sistema retorna sus tickets sin autenticación.
- Si es Cliente, muestra los tickets creados por ese DNI.
- Si es Agente, muestra los tickets asignados a ese DNI.

#### RF-003: Crear Ticket

- El Cliente puede generar un ticket completando asunto, descripción y categoría.
- El sistema genera un número único automáticamente.
- El estado inicial es «Abierto».
- Puede adjuntar archivos.

#### RF-004: Asignar Ticket

- El Agente puede asignar manualmente un ticket a otro agente.
- El sistema registra quién lo asignó, a quién y cuándo.

#### RF-005: Actualizar Estado

- El Agente puede cambiar el estado de un ticket.
- Estados disponibles:
  - Abierto
  - En Progreso
  - Esperando al Cliente
  - Resuelto
  - Cerrado
- El cambio debe reflejarse en tiempo real.

#### RF-006: Ver Detalles de Ticket

El sistema muestra:

- ID
- Asunto
- Descripción
- Categoría
- Estado
- Fecha
- Agente asignado
- Historial de comentarios con quién, cuándo y qué.

#### RF-007: Comentar en Ticket

- Cliente y agente pueden dejar comentarios.
- Se registra autor, timestamp y contenido.
- El comentario aparece inmediatamente en el historial.

#### RF-008: Ver Listado de Tickets

- Muestra una tabla con ID, asunto, categoría, estado y fecha.
- Se ordena por fecha, mostrando primero los más recientes.
- Permite filtrar por estado.

#### RF-009: Reportes Básicos

- Cantidad total de tickets.
- Tickets por estado.
- Categorías más frecuentes.

### Alcance No Funcional

#### RNF-001: Usabilidad

- Crear un ticket en un máximo de 3 pasos/clics.
- Interfaz intuitiva para cualquier usuario.
- Mensajes de error claros.

#### RNF-002: Rendimiento

- Cambios de estado en menos de 2 segundos.
- La búsqueda responde inmediatamente.

#### RNF-003: Integridad de Datos

- No permitir tickets duplicados.
- Mantener estados consistentes.
- Validar los campos obligatorios.

### Actores Incluidos en el Proyecto

#### Cliente / Usuario Final

- Crear tickets.
- Consultar sus tickets.
- Ver el estado de sus tickets.
- Comunicarse con el agente.
- Identificarse por DNI.

#### Agente de Soporte

- Recibir asignaciones.
- Ver detalles de tickets.
- Actualizar estados.
- Comunicarse con clientes.
- Asignar tickets.
- Identificarse por DNI.

### Características principales del alcance

- 9 User Stories.
- 2 actores.
- 5 estados de Ticket.
- Identificación por DNI.
- Sin autenticación tradicional.
- Interfaz única.
- Sin login/logout.
- Sin administrador.
- Búsqueda por DNI.
- Reportes básicos integrados.
- Sistema básico y funcional.
