# Sistema de Gestión de Tickets de Soporte — Diagramas de Flujo de Datos

Ver Diagrama de Contexto en GraphvizOnline: https://dreampuf.github.io/GraphvizOnline


## Diagrama de Contexto


```dot
digraph DiagramaContexto {
    // Configuración general
    rankdir=LR;
    splines=true;
    nodesep=0.8;
    ranksep=2.2;

    fontname="Helvetica,Arial,sans-serif";
    labelloc="t";
    label="Diagrama de Contexto";
    fontsize=16;

    node [fontname="Helvetica,Arial,sans-serif", fontsize=12, margin=0.3];
    edge [fontname="Helvetica,Arial,sans-serif", fontsize=10, color="#555555", arrowsize=0.8];

    // Entidades externas
    node [shape=box, style=filled, fillcolor="#f0f0f0", color="#cccccc"];
    C [label="Cliente"];
    A [label="Agente de Soporte"];

    // Proceso central
    node [shape=ellipse, style=filled, fillcolor="#e1f5fe", color="#81d4fa"];
    P0 [label="0.0\nSistema de Gestión\nde Tickets de Soporte"];

    // Flujos del Cliente (Cliente queda a la izquierda)
    // Arriba: ciclo del usuario
    C -> P0 [label="Dato de usuario"];
    C -> P0 [label="Confirmación de usuario", dir=back];
    // Abajo: ciclo del ticket
    C -> P0 [label="Solicitud de ticket"];
    C -> P0 [label="Respuesta de ticket", dir=back];

    // Flujos del Agente (Agente queda a la derecha)
    // Arriba: ciclo del usuario
    P0 -> A [label="Dato de usuario", dir=back];
    P0 -> A [label="Confirmación de usuario"];
    // Medio: ciclo del ticket
    P0 -> A [label="Ticket asignado"];
    P0 -> A [label="Ticket gestionado", dir=back];
    // Abajo: ciclo del reporte
    P0 -> A [label="Solicitud de reporte", dir=back];
    P0 -> A [label="Reporte"];
}
```

## Diagrama 0


```dot
digraph Diagrama0 {
    // Configuración general
    rankdir=TB;
    splines=true;
    nodesep=1.2;
    ranksep=1.8;

    fontname="Helvetica,Arial,sans-serif";
    labelloc="t";
    label="Diagrama 0";
    fontsize=16;

    node [fontname="Helvetica,Arial,sans-serif", fontsize=12, margin=0.3];
    edge [fontname="Helvetica,Arial,sans-serif", fontsize=10, color="#555555", arrowsize=0.8];

    // CAPA SUPERIOR: Entidades externas (Cliente izquierda, Agente derecha)
    {
        rank=same;
        node [shape=box, style=filled, fillcolor="#f0f0f0", color="#cccccc"];
        C [label="Cliente"];
        A [label="Agente de Soporte"];
        C -> A [style=invis];
    }

    // CAPA CENTRAL: Procesos (1.0, 2.0, 3.0 de izquierda a derecha)
    {
        rank=same;
        node [shape=ellipse, style=filled, fillcolor="#e1f5fe", color="#81d4fa"];
        P1 [label="1.0\nGESTIONAR USUARIO"];
        P2 [label="2.0\nGESTIONAR TICKET"];
        P3 [label="3.0\nGENERAR REPORTE"];
        P1 -> P2 -> P3 [style=invis];
    }

    // CAPA INFERIOR: Almacenamientos (D1, D3, D2 de izquierda a derecha)
    {
        rank=same;
        node [shape=cylinder, style=filled, fillcolor="#fff3e0", color="#ffcc80"];
        D1 [label="D1 USUARIOS"];
        D3 [label="D3 EVENTOS TICKET"];
        D2 [label="D2 TICKETS"];
        D1 -> D3 -> D2 [style=invis];
    }

    // --- Flujos del Cliente ---
    C -> P1 [label="Dato de usuario"];
    C -> P1 [label="Confirmación de usuario", dir=back];

    C -> P2 [label="Solicitud de ticket"];
    C -> P2 [label="Respuesta de ticket", dir=back];

    // --- Flujos del Agente ---
    A -> P1 [label="Dato de usuario"];
    A -> P1 [label="Confirmación de usuario", dir=back];

    A -> P2 [label="Ticket asignado", dir=back];
    A -> P2 [label="Ticket gestionado"];

    A -> P3 [label="Solicitud de reporte"];
    A -> P3 [label="Reporte", dir=back];

    // --- Flujos internos: procesos y almacenamientos ---
    P1 -> D1 [label="Registro de usuario"];
    P2 -> D1 [label="Validación de usuario", dir=back];

    P2 -> D3 [label="Nuevo evento"];
    P2 -> D3 [label="Historial de eventos", dir=back];

    P2 -> D2 [label="Ticket actualizado"];
    P2 -> D2 [label="Datos de ticket", dir=back];

    P3 -> D2 [label="Datos de tickets", dir=back];
}
```

