# Diagrama de Actividades

Responsable: Lucas

Herramienta: **Mermaid** (`flowchart`). Muestra el flujo completo de atención de un ticket, desde que el cliente lo crea hasta que se cierra, incluyendo las decisiones del camino.

```mermaid
flowchart TD
    Start([Inicio]) --> A[Cliente completa DNI, categoría y descripción]
    A --> V{¿Datos completos<br/>y categoría válida?}
    V -- No --> E1[Sistema muestra error] --> A
    V -- Sí --> AG{¿Hay agentes<br/>cargados?}
    AG -- No --> E2[Sistema informa: no hay agentes disponibles] --> Fin1([Fin])
    AG -- Sí --> B[Sistema asigna un agente al azar<br/>y registra la fecha de inicio]
    B --> C[Ticket en estado Asignado]
    C --> D[Agente consulta sus tickets por DNI]
    D --> F[Agente cambia el estado a En proceso]
    F --> G[Agente trabaja en el problema]
    G --> H[Agente cambia el estado a En revisión]
    H --> I[Cliente consulta sus tickets por DNI]
    I --> K{¿El problema<br/>fue resuelto?}
    K -- No --> F2[Cliente devuelve el ticket a En proceso] --> G
    K -- Sí --> L[Cliente cambia el estado a Cerrado]
    L --> M[Sistema registra la fecha de finalización]
    M --> End([Fin])
```
