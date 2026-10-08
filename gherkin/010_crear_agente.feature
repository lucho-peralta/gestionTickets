# language: es
Característica: Dar de alta un agente

  Escenario: Se da de alta un agente nuevo

    Dado que el agente "40111222" no está cargado

    Cuando se da de alta el agente con DNI "40111222" y nombre "Juan Pérez"
    Entonces la creación debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta
    Y el DNI del agente debe ser "40111222"
    Y el nombre del agente debe ser "Juan Pérez"

    Cuando se vuelve a dar de alta el agente con DNI "40111222"
    Entonces la respuesta debe indicar un conflicto
    Y el mensaje debe ser "El agente ya existe"

    Cuando se da de baja el agente "40111222"
    Entonces la eliminación debe ser exitosa
