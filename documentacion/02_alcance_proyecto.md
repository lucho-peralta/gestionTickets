# Alcance del Proyecto

Responsable: Juan

## 1. Descripción breve

El proyecto consiste en desarrollar un **Sistema de Gestión de Tickets de Soporte**: una aplicación web donde los clientes de un servicio reportan sus problemas, el sistema le asigna cada caso a un agente de soporte, el agente informa el avance cambiando el estado y el cliente confirma cuando su problema quedó resuelto. Con los datos registrados, el sistema genera reportes para analizar qué problemas son más frecuentes y cuánto tardan en resolverse.

Es un proyecto **con fines educativos**: se prioriza que el sistema sea simple y funcional por sobre que sea completo.

## 2. Criterios generales

| Criterio | Definición |
|---|---|
| **Sin inicio de sesión** | El sistema **no tiene** login, logout, contraseñas ni pantalla de ingreso, y no se va a agregar más adelante. Todos entran directo a la interfaz principal, sin importar el rol. |
| **Identificación por DNI** | Cuando una función necesita saber quién es el cliente o el agente, se le pide su DNI. |
| **Sin tabla de clientes** | El cliente no se registra: alcanza con guardar su DNI en el ticket. |
| **Agentes precargados** | Los agentes ya están cargados en la base de datos. El sistema no los crea, modifica ni elimina. |
| **Asignación automática** | Al crear un ticket, el sistema elige un agente al azar entre los cargados. No hay reasignación. |
| **Validaciones mínimas** | Solo se controla que los campos obligatorios estén completos y que la categoría y el estado sean valores válidos. |
| **Tickets no se eliminan** | Para que ninguna solicitud se pierda. |

## 3. Actores

| Actor | Qué puede hacer |
|---|---|
| **Cliente** | Crear un ticket, consultar sus tickets por DNI y cerrar el ticket cuando su problema fue resuelto. |
| **Agente de soporte** | Consultar los tickets que tiene asignados por su DNI y cambiarles el estado. |
| **Sistema** (procesos automáticos) | Asignar un agente a cada ticket nuevo y calcular los reportes. |

El detalle de cada actor y sus user stories está en `05_actores_casos_de_uso.md`.

## 4. Alcance funcional

| Incluido | Requerimiento |
|---|---|
| Crear ticket (DNI del cliente, categoría y descripción) | RF-01 |
| Asignación automática de agente | RF-02 |
| Consultar tickets del cliente por DNI | RF-03 |
| Confirmar resolución y cerrar el ticket (cliente) | RF-04 |
| Consultar tickets asignados al agente por DNI | RF-05 |
| Actualizar estado (agente) | RF-06 |
| Reporte: frecuencia por categoría | RF-07 |
| Reporte: tiempo promedio de resolución | RF-08 |
| Reporte: top de categorías | RF-09 |

El detalle de cada requerimiento (funcional y no funcional) está en `04_requerimientos.md`; no se duplica acá para no tener dos versiones que se contradigan.

## 5. Datos que maneja el sistema

Dos tablas:

- **agente**: `dni` (PK), `nombre`.
- **ticket**: `id` (PK), `dni_agente` (FK), `dni_cliente`, `categoria`, `descripcion`, `fecha_inicio`, `fecha_finalizacion`, `estado`.

Relación: un agente tiene muchos tickets; cada ticket tiene un solo agente (1:N). Detalle en `22_diseno_datos_erd.md` y `21_diccionario_de_datos.md`.

## 6. Estados del ticket

| Estado | Quién lo pone | Significado |
|---|---|---|
| **Asignado** | Sistema | Recién creado; ya tiene un agente asignado. |
| **En proceso** | Agente | El agente está trabajando en el problema. |
| **En revisión** | Agente | El agente terminó su trabajo; queda pendiente de confirmación del cliente. |
| **Cerrado** | Cliente | El cliente confirmó que su problema fue resuelto. Se registra la fecha de finalización. |

Diagrama y transiciones en `15_diagrama_transicion_estado.md`.

## 7. Fuera de alcance

| Excluido | Motivo |
|---|---|
| Login / logout / contraseñas | Directiva de la cátedra: el sistema no tiene inicio de sesión. |
| Registro de clientes | Alcanza con el DNI del cliente en el ticket. |
| Alta, baja y modificación de agentes | Los agentes están precargados. |
| Rol administrador | Solo existen Cliente y Agente. |
| Reasignación manual de agentes | La asignación es automática y única. |
| Comentarios / historial de eventos | El seguimiento se hace solo con el estado y las fechas. |
| Adjuntos | Fuera de alcance. |
| Notificaciones por email | Fuera de alcance. |
