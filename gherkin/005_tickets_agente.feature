# language: es
Característica: Consultar los tickets asignados a un agente

  Escenario: El agente consulta su bandeja de trabajo por DNI

    Dado que hay agentes cargados en el sistema

    Cuando el cliente crea un ticket con DNI "30123456" y categoría "facturacion"
    Entonces la creación debe ser exitosa
    Y el ID del ticket se guarda como "id"
    Y el DNI del agente asignado se guarda como "dni_agente"

    Cuando se solicitan los tickets del agente "dni_agente"
    Entonces la solicitud debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta
    Y la respuesta debe contener una lista con al menos un ticket
    Y la lista debe contener el ticket "id"
    Y los tickets deben estar asignados al agente "dni_agente"

    Cuando se solicitan los tickets del agente "dni_agente" filtrados por estado "asignado"
    Entonces la solicitud debe ser exitosa
    Y todos los tickets de la lista deben estar en estado "asignado"
