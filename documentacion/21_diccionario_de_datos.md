# Diccionario de Datos - Sistema de Gestión de Tickets de Soporte

## 1. Entidades

### Cliente
- **Descripción:** Persona que utiliza el servicio y necesita reportar problemas o hacer consultas.
- **Nombre(s) alternativo(s):** Usuario Final.
- **Flujos de datos de entrada:** Confirmación de usuario, Respuesta de ticket.
- **Flujos de datos de salida:** Dato de usuario, Solicitud de ticket.

### Agente de Soporte
- **Descripción:** Miembro del equipo de soporte responsable de atender y resolver tickets.
- **Nombre(s) alternativo(s):** Agente, Soporte Técnico.
- **Flujos de datos de entrada:** Confirmación de usuario, Ticket asignado, Reporte.
- **Flujos de datos de salida:** Dato de usuario, Ticket gestionado, Solicitud de reporte.

---

## 2. Procesos

### 0.0 Sistema de Gestión de Tickets de Soporte
- **Descripción:** Proceso central de alto nivel que representa el límite del sistema informático y su interacción con el exterior.

### 1.0 GESTIONAR USUARIO
- **Descripción:** Recibe los datos del formulario, valida que el DNI sea único en el sistema y crea el usuario sin contraseña.

### 2.0 GESTIONAR TICKET
- **Descripción:** Permite crear un ticket con ID único y estado Abierto, cambiar estados, asignar agentes y gestionar los comentarios.

### 3.0 GENERAR REPORTE
- **Descripción:** Consulta la base de datos para calcular métricas operativas como totales, estados y categorías.

---

## 3. Almacenamientos de Datos

### D1 USUARIOS
- **Descripción:** Repositorio central que almacena las cuentas de todos los clientes y agentes del sistema.
- **Nombre(s) alternativo(s):** Tabla Usuarios, Base de Cuentas.
- **Atributos:** Registro_Usuario.
- **Volumen y frecuencia:** Estimado: Consultas altas diarias (por validación de acceso mediante DNI) y escrituras moderadas (nuevos registros).

### D2 TICKETS
- **Descripción:** Repositorio principal donde se guardan todas las solicitudes de soporte y sus estados actuales.
- **Nombre(s) alternativo(s):** Tabla Tickets.
- **Atributos:** Registro_Ticket.
- **Volumen y frecuencia:** Estimado: Alta frecuencia de lectura y escritura por actualizaciones en tiempo real y búsquedas.

### D3 EVENTOS TICKET
- **Descripción:** Historial de todas las interacciones, comentarios y reasignaciones vinculadas a un ticket específico.
- **Nombre(s) alternativo(s):** Tabla Comentarios, Historial.
- **Atributos:** Registro_Evento.
- **Volumen y frecuencia:** Estimado: Muy alta frecuencia de escritura (inserción de comentarios y estados).

---

## 4. Flujos de Datos

### Dato de usuario
- **Descripción:** Envío de información para crear una cuenta o DNI para identificarse en el sistema.
- **Nombre(s) alternativo(s):** Datos de Login/Registro.
- **Origen de los datos:** Cliente, Agente de Soporte.
- **Destino de los datos:** 1.0 GESTIONAR USUARIO (y 0.0).
- **Registro:** Registro_Acceso_Usuario.
- **Volumen y frecuencia:** Alto, cada vez que un usuario ingresa al sistema.

### Confirmación de usuario
- **Descripción:** Mensaje de éxito o error al intentar crear un usuario (ej. "DNI ya registrado").
- **Nombre(s) alternativo(s):** Respuesta de registro.
- **Origen de los datos:** 1.0 GESTIONAR USUARIO (y 0.0).
- **Destino de los datos:** Cliente, Agente de Soporte.
- **Registro:** Mensaje del sistema.
- **Volumen y frecuencia:** Moderado.

### Solicitud de ticket
- **Descripción:** Petición inicial del cliente para reportar un problema.
- **Nombre(s) alternativo(s):** Formulario Nuevo Ticket.
- **Origen de los datos:** Cliente.
- **Destino de los datos:** 2.0 GESTIONAR TICKET (y 0.0).
- **Registro:** Registro_Solicitud_Ticket.
- **Volumen y frecuencia:** Variable según demanda de clientes.

### Respuesta de ticket
- **Descripción:** Devolución visual hacia el cliente mostrando sus tickets o la confirmación del nuevo ticket.
- **Nombre(s) alternativo(s):** Vista de Ticket.
- **Origen de los datos:** 2.0 GESTIONAR TICKET (y 0.0).
- **Destino de los datos:** Cliente.
- **Registro:** Registro_Ticket, Registro_Evento.
- **Volumen y frecuencia:** Alto.

### Ticket asignado
- **Descripción:** Notificación y despliegue del listado de tickets correspondientes al DNI de un agente.
- **Nombre(s) alternativo(s):** Mis Tickets (Agente).
- **Origen de los datos:** 2.0 GESTIONAR TICKET (y 0.0).
- **Destino de los datos:** Agente de Soporte.
- **Registro:** Registro_Ticket.
- **Volumen y frecuencia:** Alto.

### Ticket gestionado
- **Descripción:** Acciones del agente sobre un ticket (cambio de estado, asignación manual o comentario).
- **Nombre(s) alternativo(s):** Actualización de Ticket.
- **Origen de los datos:** Agente de Soporte.
- **Destino de los datos:** 2.0 GESTIONAR TICKET (y 0.0).
- **Registro:** Registro_Actualizacion_Ticket, Registro_Evento.
- **Volumen y frecuencia:** Alto.

### Solicitud de reporte
- **Descripción:** Petición del agente para visualizar las métricas del sistema.
- **Nombre(s) alternativo(s):** Cargar Dashboard.
- **Origen de los datos:** Agente de Soporte.
- **Destino de los datos:** 3.0 GENERAR REPORTE (y 0.0).
- **Registro:** Petición de lectura.
- **Volumen y frecuencia:** Bajo a moderado.

### Reporte
- **Descripción:** Devolución de los indicadores (totales, por estado y top categorías).
- **Nombre(s) alternativo(s):** Estadísticas.
- **Origen de los datos:** 3.0 GENERAR REPORTE (y 0.0).
- **Destino de los datos:** Agente de Soporte.
- **Registro:** Registro_Reporte.
- **Volumen y frecuencia:** Bajo a moderado.

### Registro de usuario
- **Descripción:** Inserción de una nueva cuenta en la base de datos.
- **Nombre(s) alternativo(s):** Insert Usuario.
- **Origen de los datos:** 1.0 GESTIONAR USUARIO.
- **Destino de los datos:** D1 USUARIOS.
- **Registro:** Registro_Usuario.
- **Volumen y frecuencia:** Bajo a moderado (solo altas nuevas).

### Validación de usuario
- **Descripción:** Consulta a la base de datos para verificar si un DNI existe, su rol, o si está duplicado.
- **Nombre(s) alternativo(s):** Check DNI.
- **Origen de los datos:** D1 USUARIOS.
- **Destino de los datos:** 2.0 GESTIONAR TICKET.
- **Registro:** DNI, Rol.
- **Volumen y frecuencia:** Muy alto.

### Nuevo evento
- **Descripción:** Grabación de un nuevo comentario o registro de cambio de estado.
- **Nombre(s) alternativo(s):** Insert Comentario.
- **Origen de los datos:** 2.0 GESTIONAR TICKET.
- **Destino de los datos:** D3 EVENTOS TICKET.
- **Registro:** Registro_Evento.
- **Volumen y frecuencia:** Alto.

### Historial de eventos
- **Descripción:** Extracción cronológica de los comentarios para mostrar en los detalles del ticket.
- **Nombre(s) alternativo(s):** Leer Comentarios.
- **Origen de los datos:** D3 EVENTOS TICKET.
- **Destino de los datos:** 2.0 GESTIONAR TICKET.
- **Registro:** Registro_Evento.
- **Volumen y frecuencia:** Alto.

### Ticket actualizado
- **Descripción:** Modificación de la tabla principal de tickets (nuevo ticket, cambio de estado, o asignación).
- **Nombre(s) alternativo(s):** Update/Insert Ticket.
- **Origen de los datos:** 2.0 GESTIONAR TICKET.
- **Destino de los datos:** D2 TICKETS.
- **Registro:** Registro_Ticket.
- **Volumen y frecuencia:** Alto.

### Datos de ticket
- **Descripción:** Lectura de la información de uno o varios tickets específicos.
- **Nombre(s) alternativo(s):** Leer Ticket.
- **Origen de los datos:** D2 TICKETS.
- **Destino de los datos:** 2.0 GESTIONAR TICKET.
- **Registro:** Registro_Ticket.
- **Volumen y frecuencia:** Alto.

### Datos de tickets
- **Descripción:** Lectura masiva de todos tickets para calcular reportes.
- **Nombre(s) alternativo(s):** Volcado de datos estadísticos.
- **Origen de los datos:** D2 TICKETS.
- **Destino de los datos:** 3.0 GENERAR REPORTE.
- **Registro:** Registro_Ticket (campos Estado, Categoría).
- **Volumen y frecuencia:** Moderado.

---

## 5. Registros

### Registro_Usuario
- **Definición o descripción:** Estructura que almacena los datos personales de un usuario.
- **Nombre(s) alternativo(s):** Fila Usuario.
- **Atributos:** Nombre completo, DNI, Email, Rol.

### Registro_Ticket
- **Definición o descripción:** Estructura que almacena la información principal de un reclamo.
- **Nombre(s) alternativo(s):** Fila Ticket.
- **Atributos:** ID, Asunto, Descripción, Categoría, Estado, Fecha creación, Última actualización, Agente asignado.

### Registro_Evento
- **Definición o descripción:** Estructura que contiene una interacción dentro de un ticket.
- **Nombre(s) alternativo(s):** Fila Comentario.
- **Atributos:** ID Ticket, Autor, Timestamp, Contenido.

### Registro_Reporte
- **Definición o descripción:** Estructura de salida generada por las métricas estadísticas.
- **Nombre(s) alternativo(s):** Salida Dashboard.
- **Atributos:** Cantidad total de tickets, tickets agrupados por estado, top 5 categorías más frecuentes.

### Registro_Acceso_Usuario
- **Definición o descripción:** Estructura temporal usada para la creación o búsqueda.
- **Nombre(s) alternativo(s):** Payload Login/Registro.
- **Atributos:** DNI, (Nombre completo, Email, Rol si es registro nuevo).

---

## 6. Elementos de Datos

### DNI
- **Alias:** Documento de Identidad.
- **Tipo y longitud:** Alfanumérico o Numérico (según implementación), longitud estándar.
- **Valor por defecto:** N/A.
- **Valores aceptados:** Único en tabla usuarios (RNF-003).
- **Procedencia de los datos:** Entidades (Cliente, Agente).
- **Usuario(s) responsables:** Cliente, Agente.
- **Descripción y comentarios:** Identificador principal y único; no requiere contraseña.

### Nombre completo
- **Alias:** Nombre.
- **Tipo y longitud:** Texto, longitud variable.
- **Valor por defecto:** N/A.
- **Valores aceptados:** Texto.
- **Procedencia de los datos:** Entidades al registrarse.
- **Usuario(s) responsables:** Cliente, Agente.
- **Descripción y comentarios:** Campo obligatorio para crear usuario.

### Email
- **Alias:** Correo electrónico.
- **Tipo y longitud:** Texto.
- **Valor por defecto:** N/A.
- **Valores aceptados:** Formato válido de correo (ej. arroba y dominio).
- **Procedencia de los datos:** Entidades al registrarse.
- **Usuario(s) responsables:** Cliente, Agente.
- **Descripción y comentarios:** Validado en el requerimiento US-001.

### Rol
- **Alias:** Tipo de Usuario.
- **Tipo y longitud:** Texto o Booleano.
- **Valor por defecto:** N/A.
- **Valores aceptados:** Cliente, Agente.
- **Procedencia de los datos:** Formulario de registro (Dropdown).
- **Usuario(s) responsables:** Cliente, Agente.
- **Descripción y comentarios:** Define los permisos de visualización de tickets.

### ID Ticket
- **Alias:** Número de Ticket.
- **Tipo y longitud:** Alfanumérico o Entero.
- **Valor por defecto:** Autogenerado.
- **Valores aceptados:** Valores únicos.
- **Procedencia de los datos:** Sistema (Proceso 2.0).
- **Usuario(s) responsables:** Sistema.
- **Descripción y comentarios:** Generado automáticamente al crear (ej. #TK-001234).

### Asunto
- **Alias:** Título.
- **Tipo y longitud:** Texto, máximo 100 caracteres.
- **Valor por defecto:** N/A.
- **Valores aceptados:** Texto.
- **Procedencia de los datos:** Cliente.
- **Usuario(s) responsables:** Cliente.
- **Descripción y comentarios:** Obligatorio para reportar un problema.

### Descripción
- **Alias:** Detalle del problema.
- **Tipo y longitud:** Texto, máximo 2000 caracteres.
- **Valor por defecto:** N/A.
- **Valores aceptados:** Texto.
- **Procedencia de los datos:** Cliente.
- **Usuario(s) responsables:** Cliente.
- **Descripción y comentarios:** Campo obligatorio; admite explicación detallada.

### Categoría
- **Alias:** N/A.
- **Tipo y longitud:** Texto.
- **Valor por defecto:** N/A.
- **Valores aceptados:** Selecciones del Dropdown.
- **Procedencia de los datos:** Cliente.
- **Usuario(s) responsables:** Cliente.
- **Descripción y comentarios:** Usado para agrupación y estadísticas (Top 5).

### Estado_Ticket
- **Alias:** Estado.
- **Tipo y longitud:** Texto.
- **Valor por defecto:** Abierto.
- **Valores aceptados:** Abierto, En Progreso, Esperando al Cliente, Resuelto, Cerrado.
- **Procedencia de los datos:** Sistema (creación) o Agente (actualización).
- **Usuario(s) responsables:** Agente, Sistema.
- **Descripción y comentarios:** Reflejado en tiempo real en la interfaz.

### Agente asignado
- **Alias:** Asignado a.
- **Tipo y longitud:** Identificador (DNI o ID de agente).
- **Valor por defecto:** Nulo o auto-asignado.
- **Valores aceptados:** Agentes existentes en D1 USUARIOS.
- **Procedencia de los datos:** Agente de Soporte (Asignación manual).
- **Usuario(s) responsables:** Agente.
- **Descripción y comentarios:** Define en el listado de qué agente aparece el ticket.

### Autor Comentario
- **Alias:** Quién escribió.
- **Tipo y longitud:** Texto (Nombre) o Identificador.
- **Valor por defecto:** N/A.
- **Valores aceptados:** Identidad validada.
- **Procedencia de los datos:** Entidades (Cliente, Agente).
- **Usuario(s) responsables:** Cliente, Agente.
- **Descripción y comentarios:** Se registra automáticamente al enviar.

### Contenido Comentario
- **Alias:** Qué escribió.
- **Tipo y longitud:** Texto.
- **Valor por defecto:** N/A.
- **Valores aceptados:** Texto (no puede estar vacío).
- **Procedencia de los datos:** Entidades (Cliente, Agente).
- **Usuario(s) responsables:** Cliente, Agente.
- **Descripción y comentarios:** Aparece inmediatamente en el historial.

### Timestamp
- **Alias:** Cuándo, Fecha/hora.
- **Tipo y longitud:** Fecha y Hora (Datetime).
- **Valor por defecto:** Tiempo actual del sistema.
- **Valores aceptados:** Formato válido de tiempo.
- **Procedencia de los datos:** Sistema.
- **Usuario(s) responsables:** Sistema.
- **Descripción y comentarios:** Se graba automáticamente en tickets y comentarios.
