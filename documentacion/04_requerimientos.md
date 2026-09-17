# Alcance Funcional y No Funcional (Requerimientos)

## Requerimientos Funcionales (RF)

### RF-001: Crear Usuario

- Sistema permite crear clientes y agentes
- Datos: nombre completo, DNI, email, rol (Cliente o Agente)
- Botón "Crear Usuario" accesible en interfaz principal
- Valida que DNI sea único en el sistema
- No requiere contraseña

### RF-002: Buscar Tickets por DNI

- Usuario ingresa su DNI en pantalla de búsqueda
- Sistema retorna sus tickets
- Si es Cliente: muestra tickets creados por ese DNI
- Si es Agente: muestra tickets asignados a ese DNI

### RF-003: Crear Ticket

- Cliente puede generar ticket completando:
  - Asunto (título del problema)
  - Descripción (detalle del problema)
  - Categoría (seleccionar de dropdown)
- Sistema genera número único automático
- Estado inicial: Abierto
- Puede adjuntar archivos

### RF-004: Asignar Ticket

- Agente puede asignar manualmente un ticket a otro agente
- Sistema registra: quién lo asignó, a quién, cuándo

### RF-005: Actualizar Estado

- Agente puede cambiar el estado de un ticket
- Estados disponibles: Abierto, En Progreso, Esperando al Cliente, Resuelto, Cerrado
- Cambio reflejado en tiempo real

### RF-006: Ver Detalles de Ticket

- Mostrar: ID, asunto, descripción, categoría, estado, fecha, agente asignado
- Mostrar historial de comentarios con: quién escribió, cuándo, qué escribió

### RF-007: Comentar en Ticket

- Cliente y agente pueden dejar comentarios
- Se registra: autor, timestamp, contenido
- Aparece inmediatamente en historial

### RF-008: Ver Listado de Tickets

- Muestra tabla con: ID, asunto, categoría, estado, fecha creación, última actualización
- Ordenado por fecha (más recientes primero)
- Opción para filtrar por estado

### RF-009: Reportes Básicos

- Ver cantidad total de tickets
- Ver tickets por estado
- Ver categorías más frecuentes

## Requerimientos No Funcionales (RNF)

### RNF-001: Usabilidad

- Crear ticket en máximo 3 pasos/clics desde pantalla principal
- Interfaz intuitiva para cualquier usuario
- Mensajes de error claros y comprensibles

### RNF-002: Rendimiento

- Cambios de estado reflejarse en menos de 2 segundos
- Búsqueda de tickets responde inmediatamente

### RNF-003: Integridad de Datos

- No permitir tickets duplicados
- Estados deben ser consistentes
- Validación en campos obligatorios
- DNI no puede duplicarse en tabla de usuarios
