# Actores, User Stories y Escenarios Gherkin

> Estos escenarios describen el comportamiento desde el punto de vista del usuario (semana 1). Los escenarios a nivel API, que se usan para los tests de la semana 5, están en `gherkin/` (un `.feature` por cada `.hurl` de `hurl/`).



### Actor 1: Cliente

Persona que usa el servicio y necesita reportar un problema, consulta o reclamo.

| Objetivos | Características |
|---|---|
| Reportar un problema creando un ticket | Se identifica solo con su DNI |
| Saber en qué estado están sus tickets | No está registrado en el sistema (no hay tabla de clientes) |
| Confirmar cuando su problema fue resuelto | Accede por la interfaz web, sin login |

### Actor 2: Agente de soporte

Miembro del equipo de soporte que atiende y resuelve los tickets.

| Objetivos | Características |
|---|---|
| Ver los tickets que tiene asignados | Está precargado en el sistema (DNI y nombre) |
| Informar el avance cambiando el estado | Se identifica con su DNI |
| Consultar los reportes para mejorar el servicio | Accede por la interfaz web, sin login |

### Comportamiento automático (no es un actor)

El sistema no es un actor: los actores son siempre externos a él. Sí hay tareas que realiza por su cuenta como respuesta a la acción de un actor:

* **Asignar un agente** a cada ticket nuevo: ocurre dentro de *Crear ticket* (US-01), que inicia el Cliente.
* **Calcular los reportes**: ocurre cuando el Agente de soporte los consulta (US-07, US-08, US-09).

## 2. User Stories con criterios de aceptación

### US-01: Crear ticket

> *Como **cliente** quiero crear un ticket con mi DNI, la categoría y la descripción del problema para que el equipo de soporte lo atienda.*

| Criterio | Resultado esperado |
|---|---|
| CA-1.1 Completa DNI, categoría y descripción | Se crea el ticket y se muestra su número |
| CA-1.2 El ticket se crea | Queda en estado **Asignado**, con agente y fecha de inicio |
| CA-1.3 Falta algún campo | Mensaje: "Complete todos los campos" |
| CA-1.4 Categoría fuera de la lista | Mensaje: "Categoría inválida" |

```gherkin
Característica: Crear ticket

  Escenario: El cliente crea un ticket con todos los datos
    Dado que hay agentes cargados en el sistema
    Cuando el cliente ingresa el DNI "30123456", la categoría "Conexión" y la descripción "No tengo internet desde ayer"
    Y confirma la creación del ticket
    Entonces el sistema crea el ticket con un número único
    Y el ticket queda en estado "Asignado"
    Y el ticket tiene un agente asignado
    Y la fecha de inicio es la fecha y hora actuales

  Escenario: El cliente no completa la descripción
    Cuando el cliente ingresa el DNI "30123456" y la categoría "Conexión" sin descripción
    Y confirma la creación del ticket
    Entonces el sistema muestra el mensaje "Complete todos los campos"
    Y no se crea ningún ticket
```

### US-02: Asignación automática de agente

> *Como **cliente** quiero que mi ticket quede asignado a un agente apenas lo creo para que ninguna solicitud quede sin atender.*

| Criterio | Resultado esperado |
|---|---|
| CA-2.1 Hay agentes cargados | El sistema elige uno al azar y lo asigna |
| CA-2.2 No hay agentes cargados | Mensaje: "No hay agentes disponibles"; no se crea el ticket |

```gherkin
Característica: Asignación automática de agente

  Escenario: Se asigna un agente al crear el ticket
    Dado que los agentes "25987654" y "28555111" están cargados
    Cuando el cliente crea un ticket
    Entonces el ticket queda asignado a uno de esos dos agentes

  Escenario: No hay agentes cargados
    Dado que no hay agentes cargados
    Cuando el cliente intenta crear un ticket
    Entonces el sistema muestra el mensaje "No hay agentes disponibles"
    Y no se crea ningún ticket
```

### US-03: Consultar mis tickets

> *Como **cliente** quiero ingresar mi DNI para ver mis tickets y en qué estado está cada uno.*

| Criterio | Resultado esperado |
|---|---|
| CA-3.1 El DNI tiene tickets | Lista con número, categoría, estado, agente y fechas |
| CA-3.2 El DNI no tiene tickets | Mensaje: "No hay tickets para este DNI" |
| CA-3.3 Campo vacío | Mensaje: "Ingrese su DNI" |

```gherkin
Característica: Consultar tickets del cliente

  Escenario: El cliente tiene tickets
    Dado que el DNI "30123456" tiene 2 tickets
    Cuando el cliente busca sus tickets con el DNI "30123456"
    Entonces el sistema muestra 2 tickets con su estado actual

  Escenario: El cliente no tiene tickets
    Cuando el cliente busca sus tickets con el DNI "40111222"
    Entonces el sistema muestra el mensaje "No hay tickets para este DNI"
```

### US-04: Confirmar resolución

> *Como **cliente** quiero confirmar que mi problema fue resuelto para cerrar el ticket.*

| Criterio | Resultado esperado |
|---|---|
| CA-4.1 Ticket en revisión y problema resuelto | Pasa a **Cerrado** y se registra la fecha de finalización |
| CA-4.2 Ticket en revisión y el problema sigue | Vuelve a **En proceso** |

```gherkin
Característica: Confirmar resolución del ticket

  Escenario: El cliente confirma que el problema fue resuelto
    Dado que el ticket 1 está en estado "En revisión"
    Cuando el cliente cambia el estado del ticket 1 a "Cerrado"
    Entonces el ticket 1 queda en estado "Cerrado"
    Y se registra la fecha de finalización

  Escenario: El problema del cliente sigue
    Dado que el ticket 1 está en estado "En revisión"
    Cuando el cliente cambia el estado del ticket 1 a "En proceso"
    Entonces el ticket 1 queda en estado "En proceso"
    Y la fecha de finalización sigue vacía
```

### US-05: Ver tickets asignados

> *Como **agente** quiero ingresar mi DNI para ver los tickets que tengo asignados y organizar mi trabajo.*

| Criterio | Resultado esperado |
|---|---|
| CA-5.1 DNI de un agente con tickets | Lista de sus tickets, del más antiguo al más reciente |
| CA-5.2 Filtro por estado | Solo los tickets en ese estado |
| CA-5.3 DNI que no es de un agente | Mensaje: "Agente no encontrado" |

```gherkin
Característica: Consultar tickets asignados

  Escenario: El agente ve sus tickets
    Dado que el agente "25987654" tiene 3 tickets asignados
    Cuando el agente busca sus tickets con el DNI "25987654"
    Entonces el sistema muestra 3 tickets

  Escenario: El DNI no corresponde a un agente
    Cuando se buscan los tickets asignados al DNI "99999999"
    Entonces el sistema muestra el mensaje "Agente no encontrado"
```

### US-06: Actualizar estado

> *Como **agente** quiero cambiar el estado de un ticket para reflejar el avance de su resolución.*

| Criterio | Resultado esperado |
|---|---|
| CA-6.1 Empieza a trabajar | **Asignado → En proceso** |
| CA-6.2 Termina su trabajo | **En proceso → En revisión** (pendiente de confirmación del cliente) |
| CA-6.3 Estado fuera de la lista | Mensaje: "Estado inválido" |

```gherkin
Característica: Actualizar estado del ticket

  Escenario: El agente empieza a trabajar el ticket
    Dado que el ticket 1 está en estado "Asignado"
    Cuando el agente cambia el estado del ticket 1 a "En proceso"
    Entonces el ticket 1 queda en estado "En proceso"

  Escenario: El agente termina su trabajo
    Dado que el ticket 1 está en estado "En proceso"
    Cuando el agente cambia el estado del ticket 1 a "En revisión"
    Entonces el ticket 1 queda en estado "En revisión"
    Y el cliente puede ver que su ticket espera confirmación
```

### US-07: Frecuencia por categoría

> *Como **agente** quiero ver cuántos tickets hay de cada categoría para saber qué problemas se repiten.*

| Criterio | Resultado esperado |
|---|---|
| CA-7.1 Hay tickets | Cantidad por cada categoría, incluidas las que tienen 0 |

```gherkin
Característica: Frecuencia por categoría

  Escenario: Se consulta la frecuencia
    Dado que hay 3 tickets de "Conexión" y 1 de "Facturación"
    Cuando se consulta la frecuencia por categoría
    Entonces el sistema informa "Conexión": 3, "Facturación": 1, "Consulta general": 0 y "Otro": 0
```

### US-08: Tiempo promedio de resolución

> *Como **agente** quiero saber cuánto se tarda en promedio en resolver un ticket para medir la eficiencia del equipo.*

| Criterio | Resultado esperado |
|---|---|
| CA-8.1 Hay tickets cerrados | Promedio en horas entre fecha de inicio y de finalización |
| CA-8.2 No hay tickets cerrados | Mensaje: "Todavía no hay tickets cerrados" |
| CA-8.3 Elige una categoría | Promedio calculado solo con los tickets cerrados de esa categoría |

```gherkin
Característica: Tiempo promedio de resolución

  Escenario: Hay tickets cerrados
    Dado que un ticket cerrado tardó 2 horas y otro tardó 4 horas
    Cuando se consulta el tiempo promedio de resolución
    Entonces el sistema informa 3 horas
```

### US-09: Top de categorías

> *Como **agente** quiero ver las categorías con más tickets para priorizar mejoras del servicio.*

| Criterio | Resultado esperado |
|---|---|
| CA-9.1 Sin indicar cantidad | Las 3 categorías con más tickets, de mayor a menor |
| CA-9.2 Indicando cantidad N | Las N categorías con más tickets |

```gherkin
Característica: Top de categorías

  Escenario: Se consulta el top 2
    Dado que hay 5 tickets de "Conexión", 3 de "Facturación" y 1 de "Otro"
    Cuando se consulta el top de 2 categorías
    Entonces el sistema informa "Conexión" con 5 y "Facturación" con 3
```

## 3. Matriz actores vs. user stories

| Actor | User stories |
|---|---|
| Cliente | US-01, US-02 (incluida en US-01), US-03, US-04 |
| Agente de soporte | US-05, US-06, US-07, US-08, US-09 |

**Resumen:** 9 user stories · 2 actores · 4 estados · identificación por DNI · sin login.
