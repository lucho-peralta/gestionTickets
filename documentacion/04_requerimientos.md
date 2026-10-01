# Requerimientos Funcionales y No Funcionales

Responsable: Luciano

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
- Permite filtrar por estado.
- Si el DNI no corresponde a ningún agente, el sistema informa "Agente no encontrado".

#### RF-06: Actualizar estado

- El agente cambia el estado de uno de sus tickets.
- Camino esperado: **Asignado → En proceso → En revisión**.
- Cuando termina su trabajo, el agente pasa el ticket a **En revisión** (pendiente de confirmación del cliente). El agente **no** cierra el ticket.

### Sistema (procesos automáticos)

#### RF-02: Asignar agente automáticamente

- Al crearse un ticket, el sistema elige **al azar** un agente entre los cargados en la base.
- Cada ticket tiene exactamente un agente; no hay reasignación.
- Si no hay agentes cargados, el ticket no se crea y el sistema informa "No hay agentes disponibles".

#### RF-07: Reporte — Frecuencia por categoría

- Cantidad de tickets registrados en cada categoría (incluye las que tienen 0).

#### RF-08: Reporte — Tiempo promedio de resolución

- Promedio de `fecha_finalizacion − fecha_inicio` de los tickets **cerrados**, expresado en horas.
- Opcionalmente filtrado por categoría.
- Si no hay tickets cerrados, el promedio se informa como vacío (no como 0).

#### RF-09: Reporte — Top de categorías

- Las N categorías con más tickets, de mayor a menor (por defecto N = 3).

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
- Todo ticket tiene un agente asignado (FK válida a `agente`).
- `fecha_finalizacion` solo se completa cuando el ticket pasa a **Cerrado**.

### RNF-04: Rendimiento

- Las consultas por DNI y los cambios de estado responden en menos de 2 segundos con el volumen esperado del proyecto.

### RNF-05: Portabilidad

- Back-end, front-end y base de datos se ejecutan en contenedores Docker y se levantan juntos con Docker Compose.
