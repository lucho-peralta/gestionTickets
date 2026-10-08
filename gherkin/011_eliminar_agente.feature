# language: es
Característica: Dar de baja un agente

  Escenario: Se da de baja un agente sin tickets

    Dado que el agente "40111222" no está cargado

    Cuando se da de alta el agente con DNI "40111222" y nombre "Juan Pérez"
    Entonces la creación debe ser exitosa

    Cuando se da de baja el agente "40111222"
    Entonces la eliminación debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta

    Cuando se vuelve a dar de baja el agente "40111222"
    Entonces la respuesta debe indicar que el agente no existe
    Y el mensaje debe ser "Agente no encontrado"

  Escenario: No se puede dar de baja un agente con tickets

    Dado que hay agentes cargados en el sistema

    Cuando el cliente crea un ticket con DNI "30123456" y categoría "consulta_general"
    Entonces la creación debe ser exitosa
    Y el DNI del agente asignado se guarda como "dni_agente"

    Cuando se da de baja el agente "dni_agente"
    Entonces la respuesta debe indicar un conflicto
    Y el mensaje debe ser "El agente tiene tickets asignados"
