##Diagrama de Actividades

flowchart TD
Start([Inicio]) --> A[Cliente completa el formulario del ticket]
A       --> B[Sistema genera el ticket en estado Abierto]
B       --> C[Agente revisa la cola de tickets]
C       --> D[Agente toma o asigna el ticket]
D       --> E[Agente cambia el estado a En Progreso]
E       --> F{¿Necesita más\ninformación del cliente?}
F       -- Sí --> G[Estado: Esperando al Cliente]
G       --> H[Cliente agrega un comentario]
H       --> E
F -- No --> I[Agente resuelve el problema]
I       --> J[Estado: Resuelto]
J       --> K{¿Cliente confirma\nla solución?}
K       -- No --> E
K       -- Sí --> L[Agente cierra el ticket]
L       --> End([Fin])

