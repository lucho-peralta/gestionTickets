# Requerimientos Funcionales y No Funcionales

Valores de referencia usados en todo el documento:

- **Categorías** (lista fija): `conexion` (Conexión), `facturacion` (Facturación), `consulta_general` (Consulta general), `otro` (Otro).
- **Estados**: `asignado` (Asignado), `en_proceso` (En proceso), `en_revision` (En revisión — pendiente de confirmación del cliente), `cerrado` (Cerrado).

## Requerimientos Funcionales (RF)

### Cliente

#### RF-01: Crear ticket

- El cliente completa **DNI**, **categoría** (de la lista fija) y **descripción** del problema.
- Los tres campos son obligatorios.
- El sistema genera el **número de ticket** automáticamente.
- El sistema registra la **fecha de inicio** (fecha y hora actuales).
- El sistema asigna un agente (RF-02) y deja el ticket en estado **Asignado**.
- El sistema muestra el número de ticket y el agente asignado.
- Si falta algún campo, el sistema informa "Complete todos los campos"; si la categoría no es de la lista, "Categoría inválida".

#### RF-02: Asignar agente automáticamente

- Ocurre dentro de RF-01, al crearse el ticket: el sistema elige **al azar** un agente entre los cargados en la base.
- Cada ticket tiene exactamente un agente; no hay reasignación.
- Si no hay agentes cargados, el ticket no se crea y el sistema informa "No hay agentes disponibles".

#### RF-03: Consultar tickets del cliente

- El cliente ingresa su DNI.
- El sistema muestra todos los tickets cuyo `dni_cliente` coincide, del más reciente al más antiguo.
- De cada ticket se muestra: número, categoría, descripción, estado, agente asignado, fecha de inicio y fecha de finalización (si está cerrado).
- Si no tiene tickets, el sistema informa "No hay tickets para este DNI".

#### RF-04: Confirmar resolución (cerrar ticket)

- Solo aplica a tickets en estado **En revisión**.
- Si el problema fue resuelto, el cliente cambia el estado a **Cerrado** y el sistema registra la **fecha de finalización**.
- Si el problema sigue, el cliente puede devolver el ticket a **En proceso** para que el agente siga trabajando.

### Agente de soporte

#### RF-05: Consultar tickets asignados

- El agente ingresa su DNI.
- El sistema muestra los tickets cuyo `dni_agente` coincide, del más antiguo al más reciente (para atender primero los que llevan más tiempo).
- Si el DNI no corresponde a ningún agente, el sistema informa "Agente no encontrado".

#### RF-06: Actualizar estado

- El agente cambia el estado de uno de sus tickets.
- Camino esperado: **Asignado → En proceso → En revisión**.
- Cuando termina su trabajo, el agente pasa el ticket a **En revisión** (pendiente de confirmación del cliente). El agente **no** cierra el ticket.
- Si el estado no es de la lista, el sistema informa "Estado inválido".

#### RF-07: Reporte — Frecuencia por categoría

- Cantidad de tickets registrados en cada categoría (incluye las que tienen 0).

#### RF-08: Reporte — Tiempo promedio de resolución

- Promedio de `fecha_finalizacion − fecha_inicio` de los tickets **cerrados**, expresado en horas.
- Opcionalmente, el agente elige una categoría y el promedio se calcula solo con los tickets de esa categoría.
- Si no hay tickets cerrados, el sistema informa "Todavía no hay tickets cerrados".

#### RF-09: Reporte — Top de categorías

- Las N categorías con más tickets, de mayor a menor (por defecto N = 3; N puede ir de 1 a 4).

#### RF-10: Dar de alta un agente

- El agente ingresa el **DNI** y el **nombre** del agente nuevo. Los dos campos son obligatorios.
- A partir del alta, el agente nuevo puede recibir tickets en la asignación automática (RF-02).
- Si falta algún campo, el sistema informa "Complete todos los campos"; si el DNI no tiene 7 u 8 dígitos, "DNI inválido"; si ya hay un agente con ese DNI, "El agente ya existe".

#### RF-11: Dar de baja un agente

- El agente ingresa el DNI del agente a dar de baja.
- Solo se puede dar de baja un agente que **no tiene tickets asignados**, para que ningún ticket quede sin responsable.
- Si el DNI no corresponde a ningún agente, el sistema informa "Agente no encontrado"; si tiene tickets, "El agente tiene tickets asignados".

#### RF-12: Eliminar ticket

- El agente elimina un ticket por su número (por ejemplo, si se cargó por error).
- El ticket eliminado deja de aparecer en las consultas y en los reportes.
- Si el número no corresponde a ningún ticket, el sistema informa "Ticket no encontrado".

## Requerimientos No Funcionales (RNF)

### RNF-01: Acceso sin autenticación

- El sistema **no tiene login, logout ni contraseñas**, ni ahora ni en etapas posteriores.
- Todos los usuarios entran directo a la interfaz principal, sin importar su rol.
- La identificación se hace únicamente por DNI cuando la función lo requiere.

### RNF-02: Usabilidad

- Crear un ticket requiere un solo formulario de tres campos.
- Mensajes de error claros que indiquen qué campo falta o es inválido.

### RNF-03: Integridad de datos

- Campos obligatorios validados antes de guardar.
- `categoria` y `estado` solo aceptan valores de sus listas.
- El DNI se guarda como texto de 7 u 8 dígitos.
- Todo ticket tiene un agente asignado (FK válida a `agente`); por eso no se da de baja un agente que tiene tickets.
- No puede haber dos agentes con el mismo DNI.
- `fecha_finalizacion` solo se completa cuando el ticket pasa a **Cerrado**.

### RNF-04: Rendimiento

- Las consultas por DNI y los cambios de estado responden en menos de 2 segundos con el volumen esperado del proyecto.

### RNF-05: Portabilidad

- Back-end, front-end y base de datos se ejecutan en contenedores Docker y se levantan juntos con Docker Compose.
