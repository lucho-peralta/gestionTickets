digraph Diagrama0 {
    // Configuración general fluida (líneas curvas) y espaciado amplio
    rankdir=LR;
    splines=true; 
    nodesep=1.0;
    ranksep=2.0;
    
    fontname="Helvetica,Arial,sans-serif";
    node [fontname="Helvetica,Arial,sans-serif", margin=0.3];
    edge [fontname="Helvetica,Arial,sans-serif", fontsize=10, color="#555555"];

    labelloc="t";
    label="Diagrama 0";
    fontsize=14;

    // Entidades Externas
    node [shape=box, style=filled, fillcolor="#f0f0f0", color="#cccccc"];
    C [label="Cliente"];
    A [label="Agente de Soporte"];

    // Proceso Central
    node [shape=ellipse, style=filled, fillcolor="#e1f5fe", color="#81d4fa"];
    P0 [label="0.0\nSistema de Gestión\nde Tickets de Soporte"];

    // Flujos del Cliente
    C -> P0 [label="Solicitud de ticket"];
    P0 -> C [label="Respuesta de ticket"];

    // Flujos del Agente
    A -> P0 [label="Ticket gestionado"];
    A -> P0 [label="Solicitud de reporte"];
    P0 -> A [label="Ticket asignado"];
    P0 -> A [label="Reporte"];
}

digraph Diagrama1 {
    // Configuración general fluida (líneas curvas) y espaciado amplio
    rankdir=TD;
    splines=true;
    nodesep=1.2;
    ranksep=2.0;

    fontname="Helvetica,Arial,sans-serif";
    node [fontname="Helvetica,Arial,sans-serif", margin=0.3, fontsize=12];
    edge [fontname="Helvetica,Arial,sans-serif", fontsize=11, color="#555555"];

    labelloc="t";
    label="Diagrama 1";
    fontsize=16;

    // CAPA SUPERIOR: Entidades Externas
    {
        rank=source;
        node [shape=box, style=filled, fillcolor="#f0f0f0", color="#cccccc"];
        C [label="Cliente"];
        A [label="Agente de Soporte"];
    }

    // CAPA CENTRAL: Procesos
    {
        rank=same;
        node [shape=ellipse, style=filled, fillcolor="#e1f5fe", color="#81d4fa"];
        P1 [label="1.0\nGESTIONAR USUARIO"];
        P2 [label="2.0\nGESTIONAR TICKET"];
        P3 [label="3.0\nGENERAR REPORTE"];
    }

    // CAPA INFERIOR: Almacenamientos de Datos
    {
        rank=sink;
        node [shape=cylinder, style=filled, fillcolor="#fff3e0", color="#ffcc80"];
        D1 [label="D1 USUARIOS"];
        D2 [label="D2 TICKETS"];
        D3 [label="D3 EVENTOS TICKET"];
    }

    // --- Flujos del Cliente ---
    C -> P1 [label="Dato de usuario"];
    P1 -> C [label="Confirmación de usuario"];

    C -> P2 [label="Solicitud de ticket"];
    P2 -> C [label="Respuesta de ticket"];

    // --- Flujos del Agente ---
    A -> P1 [label="Dato de usuario"];
    P1 -> A [label="Confirmación de usuario"];

    A -> P2 [label="Ticket gestionado"];
    P2 -> A [label="Ticket asignado"];

    A -> P3 [label="Solicitud de reporte"];
    P3 -> A [label="Reporte"];

    // --- Flujos Internos del Sistema ---
    P1 -> D1 [label="Registro de usuario"];
    D1 -> P2 [label="Validación de usuario"];

    P2 -> D2 [label="Actualiza ticket"];
    D2 -> P2 [label="Lee ticket"];

    P2 -> D3 [label="Nuevo evento"];
    D3 -> P2 [label="Historial de evento"];

    D2 -> P3 [label="Métrica de ticket"];
}
