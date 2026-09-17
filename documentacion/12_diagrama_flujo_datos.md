# Nivel 0 (Contexto)
flowchart LR
Cliente([Cliente])
Agente([Agente de Soporte])
Sistema((Sistema de Gestión\nde Tickets de Soporte))
Cliente -- "Solicitudes" --> Sistema
Sistema -- "Respuestas" --> Cliente
Agente -- "Gestión" --> Sistema
Sistema -- "Tickets / Reportes" --> Agente

# Nivel 1 (Procesos)
flowchart TD
Cliente([Cliente])
Agente([Agente de Soporte])
P1((P1 Gestionar\nUsuarios))
P2((P2 Gestionar\nTickets))
P3((P3 Generar\nReportes))
D1[(D1: Usuarios)]
D2[(D2: Tickets)]
Cliente -- "alta / DNI" --> P1
Agente -- "alta / DNI" --> P1
P1 --> D1
Cliente -- "crear / buscar / comentar" --> P2
Agente -- "asignar / actualizar / comentar" --> P2
P2 --> D2
Agente -- "consultar" --> P3
P3 --> D2
