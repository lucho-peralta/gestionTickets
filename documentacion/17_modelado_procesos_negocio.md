# Modelado del Proceso de Negocio

Responsable: Franco

Herramienta: **Graphviz** (visualizar en <https://dreampuf.github.io/GraphvizOnline>). Se modela el proceso **"Atención de un pedido de soporte"** con notación inspirada en BPMN: un carril (*lane*) por participante, eventos de inicio y fin (círculos), tareas (rectángulos redondeados) y compuertas de decisión (rombos).

## 1. Proceso actual (antes del sistema)

```dot
digraph ProcesoActual {
    rankdir=LR;
    fontname="Helvetica,Arial,sans-serif";
    node [fontname="Helvetica,Arial,sans-serif", fontsize=11];
    edge [fontname="Helvetica,Arial,sans-serif", fontsize=9];
    label="Proceso actual: atención por canales informales";
    labelloc="t";

    subgraph cluster_cliente {
        label="Cliente"; style=filled; fillcolor="#f5f5f5";
        i  [shape=circle, label="", width=0.3, style=filled, fillcolor="#c8e6c9"];
        c1 [shape=box, style=rounded, label="Envía reclamo por\nmail, teléfono o chat"];
        c2 [shape=box, style=rounded, label="Vuelve a preguntar\npor su caso"];
    }

    subgraph cluster_soporte {
        label="Equipo de soporte"; style=filled; fillcolor="#e3f2fd";
        s1 [shape=box, style=rounded, label="Alguien lee el\npedido (si lo ve)"];
        s2 [shape=diamond, label="¿Alguien\nse hace cargo?"];
        s3 [shape=box, style=rounded, label="Resuelve el problema"];
        f1 [shape=doublecircle, label="", width=0.25, style=filled, fillcolor="#ffcdd2"];
        f2 [shape=doublecircle, label="", width=0.25, style=filled, fillcolor="#ffcdd2"];
    }

    i -> c1 -> s1 -> s2;
    s2 -> s3 [label="Sí"];
    s2 -> c2 [label="No"];
    c2 -> s1;
    s3 -> f1 [label="Se da por cerrado\nsin confirmación"];
    c2 -> f2 [label="El cliente\nabandona", style=dashed];
}
```

**Problemas visibles en el modelo:** nadie es responsable del pedido desde el inicio, el cliente tiene que volver a preguntar para saber el estado, el caso se cierra sin confirmación y no queda registro de fechas para medir tiempos.

## 2. Proceso propuesto (con el sistema)

```dot
digraph ProcesoPropuesto {
    rankdir=LR;
    fontname="Helvetica,Arial,sans-serif";
    node [fontname="Helvetica,Arial,sans-serif", fontsize=11];
    edge [fontname="Helvetica,Arial,sans-serif", fontsize=9];
    label="Proceso propuesto: atención con el Sistema de Tickets";
    labelloc="t";
    newrank=true;

    subgraph cluster_cliente {
        label="Cliente"; style=filled; fillcolor="#f5f5f5";
        inicio [shape=circle, label="", width=0.3, style=filled, fillcolor="#c8e6c9"];
        c1 [shape=box, style=rounded, label="Crea ticket\n(DNI, categoría,\ndescripción)"];
        c2 [shape=box, style=rounded, label="Consulta sus\ntickets por DNI"];
        c3 [shape=diamond, label="¿Problema\nresuelto?"];
        c4 [shape=box, style=rounded, label="Cierra el ticket"];
        c5 [shape=box, style=rounded, label="Devuelve a\nEn proceso"];
    }

    subgraph cluster_sistema {
        label="Sistema"; style=filled; fillcolor="#fff8e1";
        s1 [shape=box, style=rounded, label="Asigna agente al azar\nEstado: Asignado\nGuarda fecha de inicio"];
        s2 [shape=box, style=rounded, label="Guarda fecha de\nfinalización"];
        s3 [shape=box, style=rounded, label="Actualiza reportes:\nfrecuencia, tiempo\npromedio, top categorías"];
        fin [shape=doublecircle, label="", width=0.25, style=filled, fillcolor="#ffcdd2"];
    }

    subgraph cluster_agente {
        label="Agente de soporte"; style=filled; fillcolor="#e3f2fd";
        a1 [shape=box, style=rounded, label="Consulta tickets\nasignados por DNI"];
        a2 [shape=box, style=rounded, label="Estado: En proceso\ny trabaja el problema"];
        a3 [shape=box, style=rounded, label="Estado: En revisión"];
    }

    inicio -> c1 -> s1 -> a1 -> a2 -> a3 -> c2 -> c3;
    c3 -> c4 [label="Sí"];
    c3 -> c5 [label="No"];
    c5 -> a2;
    c4 -> s2 -> s3 -> fin;
}
```

## 3. Descripción del proceso propuesto

| # | Participante | Tarea | Resultado |
|---|---|---|---|
| 1 | Cliente | Crea el ticket con su DNI, la categoría y la descripción | Pedido registrado con formato común |
| 2 | Sistema | Asigna un agente al azar, pone el estado *Asignado* y guarda la fecha de inicio | Ningún pedido queda sin responsable |
| 3 | Agente | Consulta sus tickets por DNI | Sabe qué tiene pendiente |
| 4 | Agente | Pasa el ticket a *En proceso* y trabaja el problema | El cliente ve que su caso está siendo atendido |
| 5 | Agente | Pasa el ticket a *En revisión* | Queda pendiente de confirmación del cliente |
| 6 | Cliente | Consulta sus tickets y decide si el problema quedó resuelto | — |
| 7a | Cliente | Si está resuelto, cierra el ticket | El caso termina con confirmación del cliente |
| 7b | Cliente | Si no está resuelto, lo devuelve a *En proceso* | Vuelve al paso 4 |
| 8 | Sistema | Guarda la fecha de finalización | Se puede medir el tiempo de resolución |
| 9 | Sistema | Calcula los reportes | La empresa ve qué problemas se repiten y cuánto tardan |

## 4. Mejoras respecto del proceso actual

| Proceso actual | Proceso propuesto |
|---|---|
| Pedidos dispersos en mail, teléfono y chat | Un único punto de entrada: el ticket |
| Nadie es responsable hasta que alguien lo toma | Agente asignado automáticamente desde el inicio |
| El cliente tiene que volver a preguntar | El cliente consulta el estado por DNI cuando quiere |
| Se cierra sin confirmación | Solo el cliente cierra el ticket |
| Sin datos para mejorar | Reportes de frecuencia, tiempo promedio y top de categorías |
