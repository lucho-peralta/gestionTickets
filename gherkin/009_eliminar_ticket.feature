# language: es
Característica: Eliminar un ticket

  Escenario: El agente elimina un ticket

    Dado que hay agentes cargados en el sistema

    Cuando el cliente crea un ticket con DNI "30123456" y categoría "otro"
    Entonces la creación debe ser exitosa
    Y el ID del ticket se guarda como "id"

    Cuando se elimina el ticket "id"
    Entonces la eliminación debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta

    Cuando se solicita el ticket "id"
    Entonces la respuesta debe indicar que el ticket no existe
    Y el mensaje debe ser "Ticket no encontrado"
