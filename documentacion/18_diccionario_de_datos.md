# Diccionario de Datos

Describe cada elemento de los DFD de `12_diagrama_flujo_datos.md`: entidades externas, procesos, almacenamientos, flujos, registros y elementos de datos.

## 1. Entidades externas

### Cliente
- **Descripción:** Persona que usa el servicio y reporta un problema, consulta o reclamo.
- **Nombres alternativos:** Usuario final.
- **Flujos de entrada:** Comprobante de ticket, Tickets del cliente.
- **Flujos de salida:** Datos del ticket, DNI del cliente, Confirmación de resolución.

### Agente de Soporte
- **Descripción:** Miembro del equipo de soporte que atiende los tickets. Está cargado en el sistema: precargado o dado de alta. También da de alta y de baja agentes y elimina tickets.
- **Nombres alternativos:** Agente.
- **Flujos de entrada:** Tickets asignados, Reporte, Resultado de la operación.
- **Flujos de salida:** DNI del agente, Actualización de estado, Solicitud de reporte, Alta o baja de agente, Baja de ticket.

## 2. Procesos

### 0 Sistema de Gestión de Tickets de Soporte
- **Descripción:** Proceso único del diagrama de contexto; representa el límite del sistema.

### 1 Registrar ticket
- **Descripción:** Valida los datos del ticket, elige un agente al azar de D1, guarda el ticket en D2 con estado *Asignado* y fecha de inicio, y devuelve el comprobante.
- **Entradas:** Datos del ticket, Agentes disponibles.
- **Salidas:** Nuevo ticket, Comprobante de ticket.

### 2 Consultar tickets
- **Descripción:** Con el DNI de un cliente devuelve sus tickets; con el DNI de un agente verifica que exista y devuelve sus tickets asignados.
- **Entradas:** DNI del cliente, DNI del agente, Datos del agente, Datos de tickets.
- **Salidas:** Tickets del cliente, Tickets asignados.

### 3 Actualizar estado
- **Descripción:** Guarda el nuevo estado que informa el agente (*En proceso*, *En revisión*) o el cliente (*Cerrado* o vuelta a *En proceso*). Si el estado es *Cerrado*, registra la fecha de finalización.
- **Entradas:** Actualización de estado, Confirmación de resolución.
- **Salidas:** Ticket actualizado.

### 4 Generar reportes
- **Descripción:** Calcula la frecuencia por categoría, el tiempo promedio de resolución y el top de categorías a partir de D2.
- **Entradas:** Solicitud de reporte, Datos para reportes.
- **Salidas:** Reporte.

### 5 Administrar datos
- **Descripción:** Da de alta un agente en D1 (si su DNI no está repetido), da de baja un agente de D1 (si no tiene tickets en D2) y elimina un ticket de D2.
- **Entradas:** Alta o baja de agente, Baja de ticket, Tickets del agente.
- **Salidas:** Cambio de agentes, Ticket eliminado, Resultado de la operación.

## 3. Almacenamientos

### D1 Agentes
- **Descripción:** Agentes de soporte habilitados para recibir tickets. Se cargan al crear la base y después se pueden dar de alta y de baja.
- **Nombres alternativos:** Tabla `agente`.
- **Registro:** Registro_Agente.
- **Volumen y frecuencia:** Pocos registros; se leen en cada ticket nuevo y en cada consulta de un agente. Se escriben rara vez (altas y bajas).

### D2 Tickets
- **Descripción:** Todos los tickets con su agente, estado y fechas.
- **Nombres alternativos:** Tabla `ticket`.
- **Registro:** Registro_Ticket.
- **Volumen y frecuencia:** Crece con cada pedido. Lectura y escritura frecuentes.

## 4. Flujos de datos

| Flujo | Descripción | Origen | Destino | Composición |
|---|---|---|---|---|
| Datos del ticket | Pedido de soporte del cliente | Cliente | 1 Registrar ticket | DNI cliente + Categoría + Descripción |
| Comprobante de ticket | Confirmación del ticket creado | 1 Registrar ticket | Cliente | Registro_Ticket |
| Agentes disponibles | Lista de agentes para elegir uno | D1 Agentes | 1 Registrar ticket | {Registro_Agente} |
| Nuevo ticket | Alta del ticket | 1 Registrar ticket | D2 Tickets | Registro_Ticket |
| DNI del cliente | Identificación para consultar | Cliente | 2 Consultar tickets | DNI cliente |
| Tickets del cliente | Tickets reportados por ese DNI | 2 Consultar tickets | Cliente | {Registro_Ticket} |
| DNI del agente | Identificación para consultar | Agente | 2 Consultar tickets | DNI agente + [Estado] |
| Datos del agente | Verifica que el DNI sea de un agente | D1 Agentes | 2 Consultar tickets | Registro_Agente |
| Datos de tickets | Tickets filtrados por DNI | D2 Tickets | 2 Consultar tickets | {Registro_Ticket} |
| Tickets asignados | Bandeja de trabajo del agente | 2 Consultar tickets | Agente | {Registro_Ticket} |
| Actualización de estado | Avance informado por el agente | Agente | 3 Actualizar estado | ID ticket + Estado |
| Confirmación de resolución | El cliente cierra o reabre el ticket | Cliente | 3 Actualizar estado | ID ticket + Estado |
| Ticket actualizado | Nuevo estado y, si corresponde, fecha de finalización | 3 Actualizar estado | D2 Tickets | ID ticket + Estado + [Fecha finalización] |
| Solicitud de reporte | Pedido de un reporte | Agente | 4 Generar reportes | Tipo de reporte + [Categoría] + [Límite] |
| Datos para reportes | Lectura de tickets para calcular | D2 Tickets | 4 Generar reportes | {Categoría + Estado + Fecha inicio + Fecha finalización} |
| Reporte | Resultado calculado | 4 Generar reportes | Agente | Registro_Reporte |
| Alta o baja de agente | Agente a incorporar o a quitar | Agente | 5 Administrar datos | Alta: DNI agente + Nombre · Baja: DNI agente |
| Baja de ticket | Ticket a eliminar | Agente | 5 Administrar datos | ID ticket |
| Tickets del agente | Verifica que el agente a dar de baja no tenga tickets | D2 Tickets | 5 Administrar datos | Cantidad |
| Cambio de agentes | Agente nuevo o eliminado | 5 Administrar datos | D1 Agentes | Registro_Agente o DNI agente |
| Ticket eliminado | Ticket que se borra | 5 Administrar datos | D2 Tickets | ID ticket |
| Resultado de la operación | Confirmación o mensaje de error | 5 Administrar datos | Agente | [Registro_Agente] + [Mensaje] |

Notación: `+` = y; `{ }` = se repite; `[ ]` = opcional.

## 5. Registros

### Registro_Agente
- **Descripción:** Una fila de la tabla `agente`.
- **Composición:** DNI agente + Nombre.

### Registro_Ticket
- **Descripción:** Una fila de la tabla `ticket`.
- **Composición:** ID ticket + DNI agente + DNI cliente + Categoría + Descripción + Fecha inicio + [Fecha finalización] + Estado.

### Registro_Reporte
- **Descripción:** Resultado de un reporte. Según el tipo:
  - Frecuencia por categoría: {Categoría + Cantidad}.
  - Tiempo promedio de resolución: [Categoría] + Tickets cerrados + Promedio en horas.
  - Top de categorías: {Categoría + Cantidad}, ordenado de mayor a menor.

## 6. Elementos de datos

| Elemento | Tipo y longitud | Valores aceptados | Valor por defecto | Origen | Descripción |
|---|---|---|---|---|---|
| ID ticket | Entero | Único, autoincremental | Generado | Sistema | Número de ticket |
| DNI cliente | Texto, 7-8 caracteres | Solo dígitos | — | Cliente | Identifica a quién afecta el problema |
| DNI agente | Texto, 7-8 caracteres | DNI existente en D1 | Agente elegido al azar | Sistema | Agente asignado (FK) |
| Nombre | Texto, hasta 100 | Texto no vacío | — | Carga inicial / Agente | Nombre del agente |
| Categoría | Texto, hasta 20 | `conexion`, `facturacion`, `consulta_general`, `otro` | — | Cliente | Tipo de problema; base de los reportes |
| Descripción | Texto | No vacío | — | Cliente | Qué ocurrió |
| Fecha inicio | Fecha y hora | ISO 8601 | Fecha y hora actuales | Sistema | Cuándo se reportó |
| Fecha finalización | Fecha y hora | ISO 8601 o vacío | Vacío | Sistema | Cuándo el cliente cerró el ticket |
| Estado | Texto, hasta 15 | `asignado`, `en_proceso`, `en_revision`, `cerrado` | `asignado` | Sistema / Agente / Cliente | Etapa del ciclo de vida |
| Cantidad | Entero | ≥ 0 | — | Sistema | Tickets de una categoría |
| Tickets cerrados | Entero | ≥ 0 | — | Sistema | Tickets considerados en el promedio |
| Promedio en horas | Decimal | ≥ 0 o vacío | — | Sistema | Tiempo promedio de resolución |
| Límite | Entero | 1 a 4 | 3 | Agente | Cantidad de categorías del top |
| Mensaje | Texto | Textos de error de `19_rest_api.md` | — | Sistema | Motivo por el que no se hizo la operación |
