# Enunciado — Sistema de Gestión de Tickets de Soporte

Se requiere desarrollar un sistema de tickets de soporte que permita organizar y realizar el seguimiento de los reclamos, consultas o pedidos de ayuda que los usuarios de un servicio necesiten reportar.

Cada solicitud constituye un caso (**ticket**) que debe poder seguirse desde el momento en que se reporta hasta que recibe una respuesta o solución definitiva. A lo largo de este ciclo de vida, el ticket puede recibir actualizaciones de estado que reflejen el avance de su resolución, o la confirmación de que el problema ya fue resuelto.

De cada ticket debe registrarse la información necesaria para comprender **qué ocurrió**, **a quién afecta** y **en qué momento fue reportado**, de forma que el equipo de soporte pueda priorizar y organizar su trabajo de forma eficiente.

El sistema tiene como objetivo evitar que las solicitudes queden sin atender, garantizando que todo usuario reciba una respuesta y que el estado de cada caso sea visible en todo momento.

Además, la información registrada debe permitir analizar con qué frecuencia se repite cada tipo de problema, cuánto tardan en resolverse y cuáles son los más frecuentes, para mejorar el servicio en general.

## Cómo responde el sistema al enunciado

| El enunciado pide… | El sistema lo resuelve con… |
|---|---|
| Registrar qué ocurrió | `categoria` + `descripcion` del ticket |
| A quién afecta | `dni_cliente` del ticket |
| Cuándo fue reportado | `fecha_inicio` (la pone el sistema) |
| Que ninguna solicitud quede sin atender | Asignación **automática** de un agente al crear el ticket |
| Seguir el caso hasta su solución | Estados *Asignado → En proceso → En revisión → Cerrado* |
| Confirmación de que el problema fue resuelto | El **cliente** cierra el ticket; se registra `fecha_finalizacion` |
| Estado visible en todo momento | Cliente y agente consultan sus tickets por DNI |
| Analizar frecuencia, tiempos y problemas más comunes | Reportes de frecuencia por categoría, tiempo promedio de resolución y top de categorías |
