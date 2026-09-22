# Nivel 0 (Contexto)
---
title: Diagrama de Contexto
---
flowchart LR
    %% Entidades en rectángulos clásicos
    C[Cliente]
    A[Agente de Soporte]
    
    %% Proceso Central
    P0("0.0\nSistema de Gestión\nde Tickets de Soporte")
    
    %% Flujos del Cliente
    C -->|Solicitud de Ticket| P0
    P0 -->|Respuesta de Ticket| C
    
    %% Flujos del Agente (Separados como solicitaste)
    A -->|Gestión de Ticket| P0
    A -->|Solicitud de Reporte| P0
    
    P0 -->|Ticket Asignado| A
    P0 -->|Reporte| A

# Nivel 1 (Procesos)
---
title: Diagrama 0
---
flowchart TD
    C[Cliente]
    A[Agente de Soporte]
    
    P1("1.0\nGESTIONAR USUARIO")
    P2("2.0\nGESTIONAR TICKET")
    P3("3.0\nGENERAR REPORTE")
    
    D1[(D1 USUARIOS)]
    D2[(D2 TICKETS)]
    D3[(D3 EVENTOS TICKET)]
    
    %% --- Interacciones con P1 (US-001) ---
    C -->|Dato de usuario| P1
    A -->|Dato de usuario| P1
    P1 -->|Registro de usuario| D1
    P1 -->|Confirmación de usuario| C
    P1 -->|Confirmación de usuario| A
    
    %% --- Interacciones con P2 (US-002 a US-008) ---
    C -->|Solicitud de ticket| P2
    P2 -->|Respuesta de ticket| C
    
    A -->|Ticket gestionado| P2
    P2 -->|Ticket asignado| A
    
    D1 -->|Validación de usuario| P2
    P2 <-->|Dato de ticket| D2
    P2 -->|Nuevo evento| D3
    D3 -->|Historial de evento| P2
    
    %% --- Interacciones con P3 (US-009) ---
    A -->|Solicitud de reporte| P3
    D2 -->|Métrica de ticket| P3
    P3 -->|Reporte| A
