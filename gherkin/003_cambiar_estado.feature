# language: es
Característica: Cambiar el estado de un ticket

  Escenario: El agente trabaja el ticket y el cliente confirma la resolución

    Dado que hay agentes cargados en el sistema

    Cuando el cliente crea un ticket con DNI "30123456" y categoría "conexion"
    Entonces la creación debe ser exitosa
    Y el ID del ticket se guarda como "id"

    Cuando el agente cambia el estado del ticket "id" a "en_proceso"
    Entonces la solicitud debe ser exitosa
    Y no deben existir errores o violaciones en la respuesta
    Y el estado debe ser "en_proceso"
    Y la fecha de finalización debe estar vacía

    Cuando el agente cambia el estado del ticket "id" a "en_revision"
    Entonces la solicitud debe ser exitosa
    Y el estado debe ser "en_revision"
    Y la fecha de finalización debe estar vacía

    Cuando el cliente cambia el estado del ticket "id" a "cerrado"
    Entonces la solicitud debe ser exitosa
    Y el estado debe ser "cerrado"
    Y la fecha de finalización debe ser una fecha válida
