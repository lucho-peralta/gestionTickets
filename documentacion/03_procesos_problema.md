# Procesos Actuales y Problemas a Resolver

Responsable: Juan

## 1. Proceso actual

Hoy las consultas y reclamos llegan por **canales informales**, principalmente correos electrónicos, llamados y mensajes directos.

1. El cliente realiza una consulta o reclamo por el canal que tenga a mano.
2. La información queda repartida entre distintos canales y personas.
3. Alguien del equipo de soporte tiene que darse cuenta del pedido y decidir, a mano, quién lo atiende.
4. No hay un registro de cuándo se reportó cada caso ni de cuándo se resolvió.
5. El cliente no tiene forma de saber en qué estado está su pedido sin volver a preguntar.
6. No queda claro cuándo un caso está terminado: el agente lo da por resuelto sin que el cliente lo confirme.
7. No hay datos para analizar qué tipo de problemas se repiten ni cuánto tardan en resolverse.

## 2. Situación problemática

- **Desorganización de solicitudes:** los pedidos llegan por canales distintos y sin un formato común.
- **Pedidos sin atender:** sin asignación explícita, un caso puede quedar sin responsable.
- **Falta de visibilidad:** ni el cliente ni el agente saben con certeza en qué estado está cada caso.
- **Cierre sin confirmación:** un caso se da por terminado sin que el cliente confirme que su problema se resolvió.
- **Sin métricas:** es imposible saber qué categorías de problema son más frecuentes o cuánto se tarda en resolverlas.
- **Impacto en la reputación:** las fallas en la atención afectan la satisfacción y la retención de clientes.

## 3. Problemas a resolver

| Problema | Impacto | Solución propuesta |
|---|---|---|
| Pedidos dispersos en distintos canales | Casos perdidos | Cada pedido se registra como **ticket** en un único sistema |
| Asignación manual o inexistente | Casos sin responsable | **Asignación automática** de un agente al crear el ticket |
| Estado desconocido | El cliente vuelve a preguntar | Cliente y agente consultan sus tickets **por DNI** y ven el estado actual |
| Cierre sin confirmación del cliente | Casos mal cerrados | El agente pasa el ticket a **En revisión** y solo el **cliente** lo cierra |
| Sin registro de tiempos | No se sabe cuánto se tarda | Se guardan **fecha de inicio** y **fecha de finalización** de cada ticket |
| Sin datos de los problemas | No se puede mejorar el servicio | Reportes de **frecuencia por categoría**, **tiempo promedio de resolución** y **top de categorías** |
