## 3. Identificación de Actores

### Actor 1: Cliente / Usuario Final

Persona que utiliza el servicio y necesita reportar problemas o hacer consultas.

**Objetivos:**

- Crear un ticket para reportar un problema
- Ver el estado de sus tickets
- Comunicarse con el agente
- Identificarse por DNI

**Características:**

- Necesita interfaz simple
- Accede a través de web

### Actor 2: Agente de Soporte

Miembro del equipo de soporte responsable de atender y resolver tickets.

**Objetivos:**

- Recibir asignaciones de tickets
- Ver detalles del problema
- Actualizar el estado
- Comunicarse con cliente
- Asignar tickets
- Identificarse por DNI

**Características:**

- Accede a través de web
- Múltiples tickets asignados

## 4. Casos de Uso — User Stories con Criterios de Aceptación

### USER STORY 1 — US-001: Crear Usuario (Cliente o Agente)

> *Como usuario nuevo quiero crear una cuenta con mi DNI para poder acceder al sistema*

**Descripción funcional:** Sistema muestra formulario (nombre, DNI, email, rol). Usuario completa datos y hace clic en «Crear Usuario». Valida DNI único. Si válido: usuario creado con confirmación.

| Criterio | Resultado Esperado |
|---|---|
| Completa todos los campos correctamente | Usuario se crea exitosamente |
| DNI ya existe | Mensaje: DNI ya registrado |
| Email inválido | Mensaje: Email inválido |
| Campo obligatorio vacío | Mensaje: Complete todos los campos |
| Usuario creado | Puede buscarse por DNI inmediatamente |

### USER STORY 2 — US-002: Buscar Tickets por DNI

> *Como usuario quiero ingresar mi DNI para ver mis tickets*

**Descripción funcional:** Pantalla con campo «Ingresa tu DNI». Usuario ingresa DNI y hace clic en Buscar. Si Cliente: retorna tickets creados. Si Agente: retorna tickets asignados.

| Criterio | Resultado Esperado |
|---|---|
| DNI existe y es Cliente | Muestra tickets creados por ese Cliente |
| DNI existe y es Agente | Muestra tickets asignados a ese Agente |
| DNI no existe | Mensaje: DNI no encontrado |
| DNI sin tickets | Mensaje: No tienes tickets aún |
| Campo vacío | Mensaje: Ingresa tu DNI |

### USER STORY — US-003: Crear Ticket (Cliente)

> *Como cliente quiero crear un ticket en 3 pasos para reportar un problema*

Completa asunto, descripción y categoría. Sistema genera ID único, estado inicial «Abierto». Puede adjuntar archivos. Validación de campos obligatorios.

### USER STORY — US-004: Ver Listado de Tickets

> *Como usuario quiero ver mis tickets en una tabla para revisar su estado*

Tabla con ID, asunto, categoría, estado y fecha. Ordenado por fecha (más recientes primero). Filtro por estado.

### USER STORY — US-005: Ver Detalles de Ticket

> *Como usuario quiero ver detalles completos de un ticket para revisar comentarios*

Muestra ID, asunto, descripción, categoría, estado, fecha, agente asignado e historial de comentarios (autor, fecha, contenido).

### USER STORY — US-006: Actualizar Estado de Ticket

> *Como agente quiero cambiar el estado de un ticket para reflejar su avance*

Estados: Abierto, En Progreso, Esperando al Cliente, Resuelto, Cerrado. Cambio reflejado en menos de 2 segundos. Cliente puede ver el estado actualizado.

### USER STORY — US-007: Asignar Ticket a Agente

> *Como agente quiero asignar un ticket a otro agente para distribuir la carga*

Asignación manual. Sistema registra quién asignó, a quién y fecha/hora. Ticket visible en búsqueda por DNI del agente asignado.

### USER STORY — US-008: Agregar Comentario

> *Como usuario quiero dejar comentarios en un ticket para comunicarme*

Cliente y agente pueden comentar. Se registra autor, timestamp y contenido. Aparece inmediatamente en el hilo.

### USER STORY — US-009: Ver Reportes Básicos

> *Como usuario quiero ver reportes básicos para analizar el estado general*

Cantidad total de tickets, tickets agrupados por estado y categorías con mayor cantidad de tickets.

### Matriz: Actores vs User Stories

| Actor | User Stories | Funcionalidades |
|---|---|---|
| Cliente | US-001, US-002, US-003, US-004, US-005, US-008 | Crear cuenta, buscar, crear ticket, ver listado, detalles, comentar |
| Agente | US-001, US-002, US-004, US-005, US-006, US-007, US-008 | Crear cuenta, buscar, ver listado, detalles, actualizar estado, asignar, comentar |

**Componentes del sistema:** 9 User Stories · 2 Actores · 5 Estados de Ticket · Identificación por DNI (sin autenticación) · Interfaz única · Reportes básicos integrados.

**Características principales:** Sin login/logout · Sin administrador · Búsqueda por DNI · Sistema básico y funcional.
