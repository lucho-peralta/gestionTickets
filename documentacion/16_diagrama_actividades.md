# Diagrama de transicion
Muestra las transiciones válidas entre los 5 estados de un ticket definidos en Requerimientos (RF-
005).


stateDiagram-v2
[*] --> Abierto: Cliente crea ticket
Abierto --> EnProgreso: Agente toma el ticket
EnProgreso --> EsperandoCliente: Agente pide información
EsperandoCliente --> EnProgreso: Cliente responde
EnProgreso --> Resuelto: Agente resuelve
Resuelto --> Cerrado: Agente cierra
Resuelto --> EnProgreso: Cliente indica que no está resuelto
Cerrado --> [*]
EnProgreso: En Progreso
EsperandoCliente: Esperando al Cliente
